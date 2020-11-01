//
//  BankLocatorCoordinator.swift
//  BankLocator
//
//  Created by Pritam on 31/10/20.
//

import UIKit

final class BankLocatorCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let viewModel = RegionsViewModel(network: Network.shared)
        viewModel.coordinator = self
        let controller = RegionsViewController.instantiate(withViewModel: viewModel)
        navigationController.pushViewController(controller, animated: true)
    }
    
    func navigateToRegionDetails() {
        let viewModel = RegionDetailsViewModel()
        viewModel.coordinator = self
        let controller = RegionDetailsViewController.instantiate(withViewModel: viewModel)
        navigationController.pushViewController(controller, animated: true)
    }
    
    func navigateToDetails() {
        let viewModel = DetailsViewModel()
        viewModel.coordinator = self
        let controller = DetailsViewController.instantiate(withViewModel: viewModel)
        navigationController.pushViewController(controller, animated: true)
    }
}

