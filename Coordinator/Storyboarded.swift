//
//  Storyboarded.swift
//  coordinator
//
//  Created by Romain Roche on 29/03/2020.
//  Copyright © 2020 Romain Roche. All rights reserved.
//

import Foundation
import UIKit

/// The `Storyboarded` protocol helps creating a view controller from a storyboard.
public protocol Storyboarded {
    static func instantiate(storyboardName: String, in bundle: Bundle) -> Self
}

public extension Storyboarded where Self: UIViewController {
    
    /// Instantiate a view controller using its class name.
    ///
    /// The view controller should have its class name set as storyboard id.
    /// - Parameter storyboardName: The name of the storyboard. Optional, "Main" by default.
    /// - Parameter bundle: The bundle of the storyboard, Optional, `Bundle.main` by default.
    static func instantiate(
        storyboardName: String = "Main",
        in bundle: Bundle = Bundle.main
    ) -> Self {
        let fullName = NSStringFromClass(self)
        let className = fullName.components(separatedBy: ".")[1]
        let storyboard = UIStoryboard(name: storyboardName, bundle: bundle)
        return storyboard.instantiateViewController(withIdentifier: className) as! Self
    }
    
}
