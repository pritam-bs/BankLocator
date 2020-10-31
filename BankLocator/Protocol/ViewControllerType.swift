//
//  ViewControllerType.swift
//  BankLocator
//
//  Created by Pritam on 31/10/20.
//

import UIKit
import Combine

protocol ViewControllerType {
    var viewModelType: ViewModelType { get }
    var activityIndictor: UIActivityIndicatorView? { get }
    func shouldShowErrorDialog(errorResponse: AppError, requestTag: String) -> Bool
}

extension ViewControllerType where  Self: UIViewController {
    var activityIndictor: UIActivityIndicatorView? { return nil }
    
    func shouldShowErrorDialog(errorResponse: AppError, requestTag: String) -> Bool {
        return false
    }
    
    func initialize(anyCancellable: inout Set<AnyCancellable>) {
        self.viewModelType
            .isLoading!
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] (isLoading) in
                guard let self = self else { return }
                guard let activityIndictor = self.activityIndictor else { return }
                if isLoading {
                    self.view.addSubview(activityIndictor)
                    activityIndictor.center = self.view.center
                    activityIndictor.startAnimating()
                } else {
                    activityIndictor.stopAnimating()
                    activityIndictor.removeFromSuperview()
                }
            }).store(in: &anyCancellable)
        
        viewModelType
            .errorResponse?
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] (touple) in
                guard let self = self else { return }
                if !self.shouldShowErrorDialog(errorResponse: touple.errorResponse, requestTag: touple.requestTag) {
                    return
                }
                
                let alert = UIAlertController(title: nil, message: touple.errorResponse.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                self.present(alert, animated: true)
            }).store(in: &anyCancellable)
    }
}
