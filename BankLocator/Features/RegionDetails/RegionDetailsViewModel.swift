//
//  RegionDetailsViewModel.swift
//  BankLocator
//
//  Created by Pritam on 31/10/20.
//

import Combine
import Foundation

class RegionDetailsViewModel: ViewModelType {
    weak var coordinator: BankLocatorCoordinator?
    
    private(set) var region: Region
    private(set) var regionSubject = CurrentValueSubject<Region, Never>(Region(name: "", branches: []))
    
    init(region: Region) {
        self.region = region
        self.regionSubject.send(self.region)
    }
}

extension RegionDetailsViewModel {
    func navigateToDetails(indexPath: IndexPath) {
        let branch = regionSubject.value.branches[indexPath.row]
        self.coordinator?.navigateToDetails(branch: branch)
    }
}
