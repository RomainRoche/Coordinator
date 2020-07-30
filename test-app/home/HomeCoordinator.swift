//
//  HomeCoordinator.swift
//  test-app
//
//  Created by Romain Roche on 30/07/2020.
//  Copyright © 2020 rroche. All rights reserved.
//

import UIKit
import Coordinator

class HomeCoordinator: Coordinator {
    
    let storyboardName: String = "home"
    
    var index = 0
    
    func goToSub(navigationController: UINavigationController) {
        self.show(
            HomeSubViewController.self,
            in: navigationController
        )
    }
    
}
