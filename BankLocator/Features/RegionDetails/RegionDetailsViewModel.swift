//
//  RegionDetailsViewModel.swift
//  BankLocator
//
//  Created by Pritam on 31/10/20.
//

import Combine

class RegionDetailsViewModel: ViewModelType {
    weak var coordinator: BankLocatorCoordinator?
}

extension RegionDetailsViewModel {
    func navigateToDetails() {
        self.coordinator?.navigateToDetails()
    }
}
