//
//  Network.swift
//  BankLocator
//
//  Created by Pritam on 1/11/20.
//

import Foundation
import Combine

class Network {
    static var shared: Network = Network()
    
    private init() {
        
    }
    
    public func request<T: Decodable>(router: ApiRouter) -> AnyPublisher<T, AppError> {
        
        guard let urlRequest = router.asURLRequest() else {
            fatalError("Invalid URL request")
        }
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        return session.dataTaskPublisher(for: urlRequest)
            .tryMap { response -> Data in
                guard let httpURLResponse = response.response as? HTTPURLResponse else {
                    throw AppError.unknown
                }
                
                if !(200..<300 ~= httpURLResponse.statusCode) {
                    throw AppError.httpError(httpURLResponse.statusCode)
                }
                
                return response.data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { AppError.map($0) }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
