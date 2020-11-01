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
    
    var anyCancellable = Set<AnyCancellable>()
    
    static let branchCellId: String = "branchCellId"
    @IBOutlet weak var branchTableView: UITableView!
    private var dataSource: UITableViewDiffableDataSource<Region, Branch>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setUpBindings()
    }
    
    private func setUpBindings() {
        func bindViewModelToView() {
            let regionValueHandler: (Region) -> Void = { [weak self] region in
                Logger.log(region)
                self?.applySnapshot(region: region, animate: true)
            }
            
            self.viewModel.regionSubject
                .receive(on: DispatchQueue.main)
                .sink(receiveValue: regionValueHandler)
                .store(in: &anyCancellable)
        }
        
        bindViewModelToView()
    }
    
    private func setupTableView() {
        let branchTableViewCell = UINib(nibName: "BranchTableViewCell",
                                      bundle: nil)
        branchTableView.register(branchTableViewCell, forCellReuseIdentifier: RegionDetailsViewController.branchCellId)
        branchTableView.delegate = self
        
        dataSource = UITableViewDiffableDataSource(tableView: branchTableView) { (tableView, indexPath, barnch) -> BranchTableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: RegionDetailsViewController.branchCellId, for: indexPath) as? BranchTableViewCell
            
            cell?.configure(barnch: barnch)
            return cell
        }
    }
    
    private func applySnapshot(region: Region, animate: Bool) {
        var snapshot = NSDiffableDataSourceSnapshot<Region, Branch>()
        snapshot.appendSections([region])
        snapshot.appendItems(region.branches, toSection: region)
        dataSource?.apply(snapshot, animatingDifferences: animate)
    }
}

extension RegionDetailsViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
