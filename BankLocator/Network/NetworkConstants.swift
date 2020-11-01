//
//  NetworkEnums.swift
//  BankLocator
//
//  Created by Pritam on 31/10/20.
//

import Foundation

//Name: “Swedbank-Embedded”
//Value: “iphone-app”

public enum MethodType: String {
    case post = "POST"
    case get = "GET"
    case put = "PUT"
}

public enum ContentType: String {
    case json = "application/json; charset=utf-8"
    case urlencoded = "application/x-www-form-urlencoded"
    case password = "X- -Password"
}

public enum CookieProperties: String {
    case name = "Swedbank-Embedded"
    case value = "iphone-app"
    case path = "\\"
}

public enum HTTPHeaderField: String {
    case authentication = "Authorization"
    case contentType = "Content-Type"
    case acceptType = "Accept"
    case acceptEncoding = "Accept-Encoding"
    case acceptLanguage = "Accept-Language"
    case ifModifiedSince = "If-Modified-Since"
}

struct NetworkProperties {
    static var timeOut: TimeInterval { return 60 }
    static var cachePolicy: URLRequest.CachePolicy { return .useProtocolCachePolicy }
}
