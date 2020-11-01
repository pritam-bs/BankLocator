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
    
    var anyCancellable = Set<AnyCancellable>()
    
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var regionLabel: UILabel!
    @IBOutlet weak var availabilityLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpBindings()
    }
    
    private func setUpBindings() {
        func bindViewModelToView() {
            let branchValueHandler: (Branch) -> Void = { [weak self] branch in
                Logger.log(branch)
                self?.title = branch.name
                self?.typeLabel.text = branch.type.name
                self?.nameLabel.text = branch.name
                self?.addressLabel.text = branch.address
                self?.regionLabel.text = branch.region
                self?.availabilityLabel.text = branch.availability ?? " "
                self?.infoLabel.text = branch.info ?? " "
            }
            
            self.viewModel.branchSubject
                .receive(on: DispatchQueue.main)
                .sink(receiveValue: branchValueHandler)
                .store(in: &anyCancellable)
        }
        
        bindViewModelToView()
    }
}


