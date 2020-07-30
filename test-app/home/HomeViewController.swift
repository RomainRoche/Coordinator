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
//        guard let navigation = self.navigationController else { return }
//        self.coordinator.goToSub(navigationController: navigation)
        let vc = FooCoordinator()
        .show(FooViewController.self, in: UINavigationController(), animated: false)
        self.present(vc.navigationController ?? vc, animated: true, completion: nil)
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
