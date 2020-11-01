//
//  AppError.swift
//  BankLocator
//
//  Created by Pritam on 31/10/20.
//

public enum AppError: Error {
    case urlError
    case httpError(Int)
    case other(Error)
    case unknown
    
    public var localizedDescription: String {
      switch self {
      case .urlError:
        return "URL is invalid"
      case .other(let error):
        return error.localizedDescription
      case .httpError(let code):
        return "Failed with error: \(code)"
      case .unknown:
        return "Something went wrong"
      }
    }
    
    static func map(_ error: Error) -> AppError {
      return (error as? AppError) ?? .other(error)
    }
}
