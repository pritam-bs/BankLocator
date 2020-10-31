//
//  RegionDetailsViewController.swift
//  BankLocator
//
//  Created by Pritam on 31/10/20.
//

import UIKit
import Combine

class RegionDetailsViewController: UIViewController, StoryboardBased, ViewModelBased {
    
    static var storyboard = UIStoryboard(name: StoryboardName.bankLocator, bundle: nil)
    
    var viewModel: RegionDetailsViewModel!
    var viewModelType: ViewModelType { return viewModel }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func press(_ sender: Any) {
        self.viewModel.navigateToDetails()
    }
    
}
