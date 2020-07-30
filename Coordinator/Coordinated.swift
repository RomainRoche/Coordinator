//
//  Coordinated.swift
//  Coordinator
//
//  Created by Romain Roche on 30/07/2020.
//  Copyright © 2020 rroche. All rights reserved.
//

import UIKit

public protocol Coordinated: Storyboarded {
    associatedtype CoordinatorType: Coordinator
    var coordinator: CoordinatorType { get set }
}
