//
//  FooCoordinator.swift
//  test-app
//
//  Created by Romain Roche on 30/07/2020.
//  Copyright © 2020 rroche. All rights reserved.
//

import UIKit
import Coordinator

class FooCoordinator: Coordinator {
    
    let storyboardName: String = "foo"
    var navigationController: UINavigationController
    
    var index = 0
    
    required init() {
        self.navigationController = UINavigationController()
    }
    
}
