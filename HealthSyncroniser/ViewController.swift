//
//  HealthInteractionViewController.swift
//  Watch_With_HealthKit
//
//  Created by Daniel Metzing on 15.04.19.
//  Copyright © 2019 Daniel Metzing. All rights reserved.
//

import UIKit
import HealthKit

final class ViewController: UIViewController {
    
    private let healthService = HealthService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    func setUpView() {
        let authorizeButton = UIButton(frame: .zero)
        view.addSubview(authorizeButton)
        
        authorizeButton.translatesAutoresizingMaskIntoConstraints = false
        authorizeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50).isActive = true
        authorizeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        authorizeButton.setTitle("Authorize", for: .normal)
        authorizeButton.setTitleColor(.blue, for: .normal)
        authorizeButton.addTarget(self, action: #selector(didPressAuthorizeButton(_:)), for: .touchUpInside)
    }
    
    @objc
    func didPressAuthorizeButton(_ sender: UIButton) {
        
        guard healthService.isHealthDataAvaialble else {
            return
        }
        
        self.healthService.authorizeHealthAccess(quantityIdentifersToRead: HKQuantityTypeIdentifier.quantityTypeIdentifiersToRead) { result in
            switch result {
            case .success(let success):
                if success {
                    self.healthService.startObservingChanges()
                    ApplicationStore.shared.isHealthAccessAuthorized = true
                }
            case .failure(let error):
                print("Failed to get authorization access with error: \(error)")
            }
            
        }
    }
}

