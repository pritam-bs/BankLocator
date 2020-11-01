//
//  DetailsViewModel.swift
//  BankLocator
//
//  Created by Pritam on 31/10/20.
//

import Combine

class DetailsViewModel: ViewModelType {
    weak var coordinator: BankLocatorCoordinator?
    
    private(set) var branch: Branch
    private(set) var branchSubject: CurrentValueSubject<Branch, Never>
    
    init(branch: Branch) {
        self.branch = branch
        branchSubject = CurrentValueSubject<Branch, Never>(self.branch)
    }
}
