//
//  Coordinator.swift
//  BankLocator
//
//  Created by Pritam on 31/10/20.
//

import UIKit

protocol Coordinator: class {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }

    func start()
}
