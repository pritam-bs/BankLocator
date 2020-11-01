//
//  RegionDetailsViewModel.swift
//  BankLocator
//
//  Created by Pritam on 31/10/20.
//

import Combine

class RegionDetailsViewModel: ViewModelType {
    weak var coordinator: BankLocatorCoordinator?
    private(set) var region: Region
    
    init(region: Region) {
        self.region = region
    }
}

extension RegionDetailsViewModel {
    func navigateToDetails() {
        self.coordinator?.navigateToDetails()
    }
}
