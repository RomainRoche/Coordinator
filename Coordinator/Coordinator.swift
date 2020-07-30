//
//  Coordinator.swift
//  Coordinator
//
//  Created by Romain Roche on 30/07/2020.
//  Copyright © 2020 rroche. All rights reserved.
//

import UIKit

public protocol Coordinator: class {
    /// The name of the storyboard used to instantiate the view controllers.
    var storyboardName: String { get }
}

public extension Coordinator {
    
    /// Show a view controller in the given navigation controller.
    /// - Parameter coordinated: The type of coordinated view controller to use.
    /// - Parameter navigationController: The navigation controller used to push.
    /// - Parameter animated: Is the transition animated (`true` by default)?
    /// - Returns: The view controller created.
    @discardableResult func show<T: UIViewController & Coordinated>(
        _ coordinated: T.Type,
        in navigationController: UINavigationController,
        animated: Bool = true
    ) -> T where T.CoordinatorType == Self {
        var viewController = T.instantiate(storyboardName: self.storyboardName)
        viewController.coordinator = self
        navigationController.pushViewController(viewController, animated: animated)
        return viewController
    }
    
    /// Show a view controller on the given view controller modally.
    /// - Parameter coordinated: The type of coordinated view controller to use.
    /// - Parameter presenter: The view controller used to present.
    /// - Parameter animated: Is the transition animated (`true` by default)?
    /// - Parameter modalStyle: The modal presentation style.
    /// - Parameter then: The completion closure.
    /// - Returns: The view controller created.
    @discardableResult func show<T: UIViewController & Coordinated>(
        _ coordinated: T.Type,
        on presenter: UIViewController,
        animated: Bool = true,
        modalStyle: UIModalPresentationStyle = .formSheet,
        then: (() -> Void)? = nil
    ) -> T where T.CoordinatorType == Self {
        var viewController = T.instantiate(storyboardName: self.storyboardName)
        viewController.coordinator = self
        viewController.modalPresentationStyle = modalStyle
        presenter.present(viewController, animated: animated, completion: then)
        return viewController
    }
    
}
