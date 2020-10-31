//
//  AppError.swift
//  BankLocator
//
//  Created by Pritam on 31/10/20.
//

public enum AppError: Error {
    case urlError
    case httpError(Int)
    case custom(Error)
    case unknown
    
    public var localizedDescription: String {
      switch self {
      case .urlError:
        return "URL is invalid"
      case .custom(let err):
        return err.localizedDescription
      case .httpError(let code):
        return "Failed with error: \(code)"
      case .unknown:
        return "Something went wrong"
      }
    }
}
