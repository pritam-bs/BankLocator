//
//  ViewModelType.swift
//  BankLocator
//
//  Created by Pritam on 31/10/20.
//

import UIKit
import Combine

protocol ViewModelType {
    var isLoading: PassthroughSubject<Bool, Never>? { get }
    var errorResponse: PassthroughSubject<(errorResponse: AppError, requestTag: String), Never>? { get }
}

extension ViewModelType {
    var isLoading: PassthroughSubject<Bool, Never>? { return nil }
    var errorResponse: PassthroughSubject<(errorResponse: AppError, requestTag: String), Never>? { return nil }
}

protocol ServicesViewModelType: ViewModelType {
    associatedtype Services
    var services: Services! { get set }
}

protocol ViewModelBased: class {
    associatedtype ViewModel: ViewModelType
    var viewModel: ViewModel! { get set }
}

extension ViewModelBased where Self: StoryboardBased & UIViewController {
    static func instantiate<ViewModel> (withViewModel viewModel: ViewModel) -> Self where ViewModel == Self.ViewModel {
        let viewController = Self.instantiate()
        viewController.viewModel = viewModel
        return viewController
    }
}

extension ViewModelBased where Self: StoryboardBased & UIViewController, ViewModel: ServicesViewModelType {
    static func instantiate<ViewModel, Services> (withViewModel viewModel: ViewModel,
                                                  andServices services: Services) -> Self
        where ViewModel == Self.ViewModel, Services == Self.ViewModel.Services {
            let viewController = Self.instantiate()
            viewController.viewModel = viewModel
            viewController.viewModel.services = services
            return viewController
    }
}
