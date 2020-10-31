//
//  RegionsViewModel.swift
//  BankLocator
//
//  Created by Pritam on 31/10/20.
//

import Combine

class RegionsViewModel: ViewModelType {
    weak var coordinator: BankLocatorCoordinator?
    
    var isLoading: PassthroughSubject<Bool, Never>? = PassthroughSubject<Bool, Never>()
    
    var errorResponse: PassthroughSubject<(errorResponse: AppError, requestTag: String), Never>? = PassthroughSubject<(errorResponse: AppError, requestTag: String), Never>()
    
    enum RequestTagKey: String {
        case regions
    }
}

extension RegionsViewModel {
    func navigateToRegionDetails() {
        self.coordinator?.navigateToRegionDetails()
    }
}
