//
//  RegionsViewModel.swift
//  BankLocator
//
//  Created by Pritam on 31/10/20.
//

import Combine
import Foundation

class RegionsViewModel: ViewModelType {
    weak var coordinator: BankLocatorCoordinator?
    
    var isLoading: PassthroughSubject<Bool, Never>? = PassthroughSubject<Bool, Never>()
    
    var errorResponse: PassthroughSubject<(errorResponse: AppError, requestTag: String), Never>? = PassthroughSubject<(errorResponse: AppError, requestTag: String), Never>()
    
    enum RequestTagKey: String {
        case regions
    }
    
    private var network: Network
    private var anyCancellable = Set<AnyCancellable>()
    
    private(set) var viewWillAppearTrigger = PassthroughSubject<Void, Never>()
    private(set) var countries = CurrentValueSubject<[Country], Never>([])
    
    init(network: Network) {
        self.network = network
        let countries = getCountries(estoniaBranchList: PersistenceManager.shared.estoniaBranchList,
                        latviaBranchList: PersistenceManager.shared.latviaBranchList,
                        lithuaniaBranchList: PersistenceManager.shared.lithuaniaBranchList)
        self.countries.send(countries)
        
        self.viewWillAppearTrigger.sink { [weak self] _ in
            self?.getRegionData()
        }.store(in: &anyCancellable)
    }
    
    private func getRegionData() {
        let estoniaPublisher: AnyPublisher<BranchList, AppError> = network.request(router: ApiRouter.estonia)
        let latviaPublisher: AnyPublisher<BranchList, AppError> = network.request(router: ApiRouter.latvia)
        let lithuaniaPublisher: AnyPublisher<BranchList, AppError> = network.request(router: ApiRouter.lithuania)
        
        let onRequest: (Subscribers.Demand) -> Void = { [weak self] _ in
            if !(self?.hasCacheData() ?? false) {
                self?.isLoading?.send(true)
            }
        }
        
        let completionHandler: (Subscribers.Completion<AppError>) -> Void = { [weak self] completion in
            switch completion {
            case .failure(let error):
                self?.isLoading?.send(false)
                self?.errorResponse?.send((errorResponse: error,
                                           requestTag: RequestTagKey.regions.rawValue))
            case .finished:
                self?.isLoading?.send(false)
            }
        }
        
        let receiveValueHandler: (BranchList, BranchList, BranchList) -> Void = { [weak self] (estoniaBranchList, latviaBranchList, lithuaniaBranchList) in
            Logger.log(estoniaBranchList)
            Logger.log(latviaBranchList)
            Logger.log(lithuaniaBranchList)
            
            PersistenceManager.shared.estoniaBranchList = estoniaBranchList
            PersistenceManager.shared.latviaBranchList = latviaBranchList
            PersistenceManager.shared.lithuaniaBranchList = lithuaniaBranchList
            
            guard let self = self else { return }
            let countries = self.getCountries(estoniaBranchList: estoniaBranchList,
                            latviaBranchList: latviaBranchList,
                            lithuaniaBranchList: lithuaniaBranchList)
            self.countries.send(countries)
        }
        
        Publishers.Zip3(estoniaPublisher, latviaPublisher, lithuaniaPublisher)
            .handleEvents(receiveRequest: onRequest)
            .sink(receiveCompletion: completionHandler, receiveValue: receiveValueHandler)
            .store(in: &anyCancellable)
    }
    
    private func getCountries(estoniaBranchList: BranchList,
                            latviaBranchList: BranchList,
                            lithuaniaBranchList: BranchList) -> [Country] {
        
        let estoniaBranchListSorted = estoniaBranchList.sorted { $0.name < $1.name }
        let regionEstonia = Dictionary.init(grouping: estoniaBranchListSorted,
                                            by: { $0.region ?? "Unknown"})
        let regionEstoniaSorted = regionEstonia
            .sorted { $0.key < $1.key }
            .map { return Region(name: $0.key, branches: $0.value) }
        let estonia = Country(name: CountryName.estonia.rawValue,
                                   regions: regionEstoniaSorted)
        
        let latviaBranchListSorted = latviaBranchList.sorted { $0.name < $1.name }
        let regionLatvia = Dictionary.init(grouping: latviaBranchListSorted,
                                            by: { $0.region ?? "Unknown"})
        let regionLatviaSorted = regionLatvia
            .sorted { $0.key < $1.key }
            .map { return Region(name: $0.key, branches: $0.value) }
        let latvia = Country(name: CountryName.latvia.rawValue,
                                   regions: regionLatviaSorted)
        
        let lithuaniaBranchListSorted = lithuaniaBranchList.sorted { $0.name < $1.name }
        let regionLithuania = Dictionary.init(grouping: lithuaniaBranchListSorted,
                                            by: { $0.region ?? "Unknown"})
        let regionLithuaniaSorted = regionLithuania
            .sorted { $0.key < $1.key }
            .map { return Region(name: $0.key, branches: $0.value) }
        let lithuania = Country(name: CountryName.lithuania.rawValue,
                                   regions: regionLithuaniaSorted)
        
        var regions = [Country]()
        regions.append(estonia)
        regions.append(latvia)
        regions.append(lithuania)
        return regions
    }
    
    private func hasCacheData() -> Bool {
        for contry in self.countries.value {
            return !contry.regions.isEmpty
        }
        return false
    }
}

extension RegionsViewModel {
    func navigateToRegionDetails(indexPath: IndexPath) {
        let country = countries.value[indexPath.section]
        let region = country.regions[indexPath.row]
        self.coordinator?.navigateToRegionDetails(region: region)
    }
}
