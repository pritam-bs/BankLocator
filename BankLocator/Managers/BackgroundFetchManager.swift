//
//  BackgroundFetchManager.swift
//  BankLocator
//
//  Created by Pritam on 2/11/20.
//

import BackgroundTasks
import Combine

class BackgroundFetchManager {
    static let shared = BackgroundFetchManager()
    private var network: Network
    
    private let appRefreshTaskWithIdentifier = "bd.com.banklocator.apprefresh"
    private let interval = 3600
    
    private var anyCancellable = Set<AnyCancellable>()
    private var task: BGAppRefreshTask?
    
    private init() {
        network = Network.shared
    }
    
    func registerBackgroundTaks() {
        BGTaskScheduler.shared.register(forTaskWithIdentifier: appRefreshTaskWithIdentifier, using: nil) { [weak self] task in
            self?.handleAppRefresh(task: task as! BGAppRefreshTask)
        }
    }
    
    func scheduleAppRefresh() {
        let request = BGAppRefreshTaskRequest(identifier: appRefreshTaskWithIdentifier)
        request.earliestBeginDate = Date(timeIntervalSinceNow: TimeInterval(interval))
        
        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            Logger.log("Could not schedule app refresh: \(error)")
        }
    }
    
    func cancelAllPandingBackgroundTaks() {
        BGTaskScheduler.shared.cancelAllTaskRequests()
    }
    
    private func handleAppRefresh(task: BGAppRefreshTask) {
        self.task = task
        scheduleAppRefresh()
        task.expirationHandler = { [weak self] in
            Logger.log("App refresh task expirationHandler")
            self?.anyCancellable.removeAll()
        }
        self.getRegionData()
    }
    
    private func getRegionData() {
        let estoniaPublisher: AnyPublisher<BranchList, AppError> = network.request(router: ApiRouter.estonia)
        let latviaPublisher: AnyPublisher<BranchList, AppError> = network.request(router: ApiRouter.latvia)
        let lithuaniaPublisher: AnyPublisher<BranchList, AppError> = network.request(router: ApiRouter.lithuania)
        
        let onRequest: (Subscribers.Demand) -> Void = { [weak self] _ in
            Logger.log("Fetch data task stared")
        }
        
        let onCancel: () -> Void = { [weak self] in
            Logger.log("Fetch data task canceled")
            self?.appRefreshCompleted(success: false)
        }
        
        let completionHandler: (Subscribers.Completion<AppError>) -> Void = { [weak self] completion in
            switch completion {
            case .failure(let error):
                Logger.log("Fetch data task failed with: \(error)")
                self?.appRefreshCompleted(success: false)
            case .finished:
                Logger.log("Fetch data task finished")
            }
        }
        
        let receiveValueHandler: (BranchList, BranchList, BranchList) -> Void = { [weak self] (estoniaBranchList, latviaBranchList, lithuaniaBranchList) in
//            Logger.log(estoniaBranchList)
//            Logger.log(latviaBranchList)
//            Logger.log(lithuaniaBranchList)
            
            PersistenceManager.shared.estoniaBranchList = estoniaBranchList
            PersistenceManager.shared.latviaBranchList = latviaBranchList
            PersistenceManager.shared.lithuaniaBranchList = lithuaniaBranchList
            
            guard let self = self else { return }
            self.sendCompletionNotification()
            Logger.log("Fetch data task successful")
            self.appRefreshCompleted(success: true)
        }
        
        Publishers.Zip3(estoniaPublisher, latviaPublisher, lithuaniaPublisher)
            .handleEvents(receiveCancel: onCancel,
                          receiveRequest: onRequest)
            .sink(receiveCompletion: completionHandler, receiveValue: receiveValueHandler)
            .store(in: &anyCancellable)
    }
    
    private func sendCompletionNotification() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.post(name: Notification.Name(AppRefreshConstant.appRefreshCompletionNotificationName), object: nil)
    }
    
    private func appRefreshCompleted(success: Bool) {
        Logger.log("appRefreshCompleted")
        self.task?.setTaskCompleted(success: success)
        if self.task != nil {
            Logger.log("App refresh task setTaskCompleted")
        }
        self.task = nil
    }
}

struct AppRefreshConstant {
    static let appRefreshCompletionNotificationName = "bd.com.banklocator.apprefresh.completion"
}
