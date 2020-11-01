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
    
    static let regionCellId: String = "regionCellId"
    @IBOutlet weak var regionTableView: UITableView!
    private var dataSource: RegionsTableViewDiffableDataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize(anyCancellable: &anyCancellable)
        setUpBindings()
        setupTableView()
    }
    
    private func setupTableView() {
        regionTableView.register(UITableViewCell.self, forCellReuseIdentifier: RegionsViewController.regionCellId)
        regionTableView.delegate = self
        
        dataSource = RegionsTableViewDiffableDataSource(tableView: regionTableView) { (tableView, indexPath, region) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: RegionsViewController.regionCellId, for: indexPath)
            cell.textLabel?.text = region.name
            cell.accessoryType = .disclosureIndicator
            return cell
        }
    }
    
    private func applySnapshot(countries: [Country], animate: Bool) {
        var snapshot = NSDiffableDataSourceSnapshot<Country, Region>()
        snapshot.appendSections(countries)
        for country in countries {
            snapshot.appendItems(country.regions, toSection: country)
        }
        dataSource?.apply(snapshot, animatingDifferences: animate)
    }
    
    private func setUpBindings() {
        func bindViewToViewModel() {
            self.viewModel.viewWillAppearTrigger.send(())
        }
        
        func bindViewModelToView() {
            let regionValueHandler: ([Country]) -> Void = { [weak self] countries in
                Logger.log(countries)
                self?.applySnapshot(countries: countries, animate: false)
            }
            
            self.viewModel.countries
                .receive(on: DispatchQueue.main)
                .sink(receiveValue: regionValueHandler)
                .store(in: &anyCancellable)
        }
        
        bindViewModelToView()
        bindViewToViewModel()
    }
    
    func shouldShowErrorDialog(errorResponse: AppError, requestTag: String) -> Bool {
        switch requestTag {
        default:
            return true
        }
    }
}

extension RegionsViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.viewModel.navigateToRegionDetails(indexPath: indexPath)
    }
}

