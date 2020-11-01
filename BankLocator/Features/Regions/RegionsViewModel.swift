//
//  RegionsViewModel.swift
//  BankLocator
//
//  Created by Pritam on 31/10/20.
//

import Combine

class RegionsViewModel: ViewModelType {
    weak var coordinator: BankLocatorCoordinator?
    
    var isLoading: PassthroughSubject<Bool, Never>? = PassthroughSubject<Bool, Never>()
    
    var errorResponse: PassthroughSubject<(errorResponse: AppError, requestTag: String), Never>? = PassthroughSubject<(errorResponse: AppError, requestTag: String), Never>()
    
    enum RequestTagKey: String {
        case regions
    }
    
    private var network: Network
    private var anyCancellable = Set<AnyCancellable>()
    
    private(set) var regions = CurrentValueSubject<[Region], Never>([])
    
    init(network: Network) {
        self.network = network
        let regions = getRegions(estoniaBranchList: PersistenceManager.shared.estoniaBranchList,
                        latviaBranchList: PersistenceManager.shared.latviaBranchList,
                        lithuaniaBranchList: PersistenceManager.shared.lithuaniaBranchList)
        self.regions.send(regions)
    }
    
    func getRegionData() {
        let estoniaPublisher: AnyPublisher<BranchList, AppError> = network.request(router: ApiRouter.estonia)
        let latviaPublisher: AnyPublisher<BranchList, AppError> = network.request(router: ApiRouter.latvia)
        let lithuaniaPublisher: AnyPublisher<BranchList, AppError> = network.request(router: ApiRouter.lithuania)
        
        let onRequest: (Subscribers.Demand) -> Void = { [weak self] _ in
            self?.isLoading?.send(true)
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
            let regions = self.getRegions(estoniaBranchList: estoniaBranchList,
                            latviaBranchList: latviaBranchList,
                            lithuaniaBranchList: lithuaniaBranchList)
            self.regions.send(regions)
        }
        
        Publishers.Zip3(estoniaPublisher, latviaPublisher, lithuaniaPublisher)
            .handleEvents(receiveRequest: onRequest)
            .sink(receiveCompletion: completionHandler, receiveValue: receiveValueHandler)
            .store(in: &anyCancellable)
    }
    
    private func getRegions(estoniaBranchList: BranchList,
                            latviaBranchList: BranchList,
                            lithuaniaBranchList: BranchList) -> [Region] {
        let regionEstonia = Region(name: RegionName.estonia.rawValue,
                                   Branchs: estoniaBranchList)
        let regionLatvia = Region(name: RegionName.latvia.rawValue,
                                   Branchs: latviaBranchList)
        let regionLithuania = Region(name: RegionName.lithuania.rawValue,
                                   Branchs: lithuaniaBranchList)
        
        var regions = [Region]()
        regions.append(regionEstonia)
        regions.append(regionLatvia)
        regions.append(regionLithuania)
        return regions
    }
}

extension RegionsViewModel {
    func navigateToRegionDetails() {
        self.coordinator?.navigateToRegionDetails()
    }
}
