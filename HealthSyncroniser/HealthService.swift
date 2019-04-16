//
//  HealthService.swift
//  Watch_With_HealthKit
//
//  Created by Daniel Metzing on 15.04.19.
//  Copyright © 2019 Daniel Metzing. All rights reserved.
//

import HealthKit

enum Result<T> {
    case success(T)
    case failure(Swift.Error)
}

extension HKQuantityTypeIdentifier {
    static let quantityTypeIdentifiersToRead: Set<HKQuantityTypeIdentifier>  = [.stepCount,
                                                                                .flightsClimbed]
}

final class HealthService {
    
    private let healthKitStore = HKHealthStore()
    private let fileService = FileService()
    
    var isHealthDataAvaialble: Bool {
        return HKHealthStore.isHealthDataAvailable()
    }
    
    func authorizeHealthAccess(quantityIdentifersToRead: Set<HKQuantityTypeIdentifier>,_ completion: @escaping (Result<Bool>) -> Void) {
        let quantityTypes = Set(quantityIdentifersToRead.compactMap(HKObjectType.quantityType(forIdentifier:)))
        healthKitStore.requestAuthorization(toShare: [], read: quantityTypes) { success, error in
            if let error = error {
                print("Authorization has failed with error: \(error)")
                completion(.failure(error))
                return
            }
            completion(.success(success))
        }
    }
    
    func startObservingChanges() {
        self.startObservingStepCount()
        self.startObservingFlightsClimbed()
    }
}

private extension HealthService {
    
    func startObservingStepCount() {
        self.startObserving(sample: HKObjectType.quantityType(forIdentifier: .stepCount)!)
    }
    
    func startObservingFlightsClimbed() {
        self.startObserving(sample: HKObjectType.quantityType(forIdentifier: .flightsClimbed)!)
    }
    
    func startObserving(sample: HKQuantityType) {
        
        healthKitStore.enableBackgroundDelivery(for: sample, frequency: .immediate, withCompletion: { success, error in
            if success {
                print("Enabled background delivery of changes for sample: \(sample)")
            } else {
                if let theError = error {
                    print("Failed to enable background delivery of changes for sample: \(sample)")
                    print("Error = \(theError)")
                }
            }
        })
        
        let query = HKObserverQuery(sampleType: sample, predicate: nil, updateHandler: self.updateHandler)
        healthKitStore.execute(query)
    }
    
    func updateHandler(query: HKObserverQuery, completionHandler: HKObserverQueryCompletionHandler, error: Error?) {
        
        guard let type = query.objectType else {
            fileService.add(entry: "Missing objectType on query: \(query)")
            completionHandler()
            return
        }
        
        switch type.identifier {
        case HKQuantityTypeIdentifier.stepCount.rawValue:
            fileService.add(entry: "stepCount update available at date: \(Date())")
        case HKQuantityTypeIdentifier.flightsClimbed.rawValue:
            fileService.add(entry: "flightsClimbed update available at date: \(Date())")
        default:
            fileService.add(entry: "Unhandled type in updateHandler")
        }
        completionHandler()
    }
}
