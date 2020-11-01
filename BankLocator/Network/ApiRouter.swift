//
//  APIRouter.swift
//  BankLocator
//
//  Created by Pritam on 31/10/20.
//

import Foundation

enum ApiRouter {
    case estonia
    case latvia
    case lithuania
    
    var domain: String {
        switch self {
        case .estonia:
            return ApiPath.domainForEstonia
        case .latvia:
            return ApiPath.domainForLatvia
        case .lithuania:
            return ApiPath.domainForLithuania
        }
    }
    
    var method: MethodType {
        switch self {
        case .estonia,
             .latvia,
             .lithuania:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .estonia:
            return "/finder.json"
        case .latvia:
            return "/finder.json"
        case .lithuania:
            return "/finder.json"
        }
    }
    
    var url: URL? {
        let scheme = "https://"
        return URL(string: scheme + domain + path)
    }
    
    var cookie: HTTPCookie? {
        var cookieProperties = [
            HTTPCookiePropertyKey.name: CookieProperties.name.rawValue,
            HTTPCookiePropertyKey.value: CookieProperties.value.rawValue,
            HTTPCookiePropertyKey.path: CookieProperties.path.rawValue
        ]
        
        cookieProperties[HTTPCookiePropertyKey.domain] = domain
        
        let cookie = HTTPCookie(properties: cookieProperties)
        return cookie
    }
    
    var headers: [String: String]? {
        if let cookie = cookie {
            HTTPCookieStorage.shared.setCookie(cookie)
        }
        
        var headers = [
            HTTPHeaderField.contentType.rawValue: ContentType.json.rawValue,
        ]
        
        if let url = url {
            let cookies = HTTPCookie.requestHeaderFields(with: HTTPCookieStorage.shared.cookies(for: url) ?? [])
            for cookie in cookies {
                headers[cookie.key] = cookie.value
            }
        }
        
        return headers
    }
    
    func asURLRequest() -> URLRequest? {
        guard let url = url else {return nil}
        var urlRequest = URLRequest(url: url,
                                    cachePolicy: NetworkProperties.cachePolicy,
                                    timeoutInterval: NetworkProperties.timeOut)
        
        urlRequest.allHTTPHeaderFields = headers
        urlRequest.httpMethod = method.rawValue
        urlRequest.timeoutInterval = NetworkProperties.timeOut
        
        return urlRequest
    }
}

