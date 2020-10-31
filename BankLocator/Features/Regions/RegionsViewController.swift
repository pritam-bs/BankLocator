//
//  RegionsViewController.swift
//  BankLocator
//
//  Created by Pritam on 31/10/20.
//

import UIKit
import Combine

class RegionsViewController: UIViewController, ViewControllerType, StoryboardBased, ViewModelBased {
    static var storyboard = UIStoryboard(name: StoryboardName.bankLocator, bundle: nil)
    
    var viewModel: RegionsViewModel!
    var viewModelType: ViewModelType { return viewModel }
    
    
    var activityIndictor: UIActivityIndicatorView? = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    
    var anyCancellable = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize(anyCancellable: &anyCancellable)
    }
    
    @IBAction func press(_ sender: Any) {
        self.viewModel.navigateToRegionDetails()
    }
    
    func shouldShowErrorDialog(errorResponse: AppError, requestTag: String) -> Bool {
        switch requestTag {
        default:
            return true
        }
    }
}

