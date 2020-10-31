//
//  DetailsViewController.swift
//  BankLocator
//
//  Created by Pritam on 31/10/20.
//

import UIKit
import Combine

class DetailsViewController: UIViewController, StoryboardBased, ViewModelBased {
    
    static var storyboard = UIStoryboard(name: StoryboardName.bankLocator, bundle: nil)
    
    var viewModel: DetailsViewModel!
    var viewModelType: ViewModelType { return viewModel }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}


