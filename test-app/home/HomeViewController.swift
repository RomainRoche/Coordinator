//
//  HomeViewController.swift
//  test-app
//
//  Created by Romain Roche on 30/07/2020.
//  Copyright © 2020 rroche. All rights reserved.
//

import UIKit
import Coordinator

class HomeViewController: UIViewController, Coordinated {

    @IBAction private func btn0(_ sender: UIButton) {
        self.coordinator.push(
            coordinator: FooCoordinator(),
            coordinated: FooViewController.self
        )
    }
    
    typealias CoordinatorType = HomeCoordinator
    var coordinator: HomeCoordinator = HomeCoordinator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.coordinator.index += 1
        print(self.coordinator.index)
    }

}
