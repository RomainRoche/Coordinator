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
    var navigationController: UINavigationController
    
    var index = 0
    
    required init() {
        self.navigationController = UINavigationController()
    }
    
    func goToSub(navigationController: UINavigationController) {
        self.push(HomeSubViewController.self)
    }
    
}
