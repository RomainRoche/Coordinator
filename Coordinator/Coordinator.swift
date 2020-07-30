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
    /// The navigation controller used to navigate in the coordinator.
    var navigationController: UINavigationController? { get set }
}

public extension Coordinator {
    
    // MARK: - public
    
    /// Attach the coordinator's navigation controller as root view controller of the window.
    /// - Parameter window: The window to attach to.
    /// - Parameter rootType: The type of the root view controller to use.
    /// - Returns: The navigation controller embeding the view controller.
    @discardableResult func attach<T: UIViewController & Coordinated>(
        to window: UIWindow,
        rootType: T.Type
    ) -> UINavigationController where T.CoordinatorType == Self {
        var viewController = T.instantiate(storyboardName: self.storyboardName)
        viewController.coordinator = self
        let navigationController = UINavigationController(rootViewController: viewController)
        self.navigationController = navigationController
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        return navigationController
    }
    
    /// Show a view controller in the given navigation controller.
    /// - Parameter coordinated: The type of coordinated view controller to use.
    /// - Parameter navigationController: The navigation controller used to push.
    /// - Parameter animated: Is the transition animated (`true` by default)?
    /// - Returns: The view controller created.
    @discardableResult func push<T: UIViewController & Coordinated>(
        _ coordinated: T.Type,
        in navigationController: UINavigationController? = nil,
        animated: Bool = true
    ) -> T where T.CoordinatorType == Self {
        var viewController = T.instantiate(storyboardName: self.storyboardName)
        viewController.coordinator = self
        if let nav = navigationController {
            self.navigationController = nav
        }
        self.navigationController?.pushViewController(
            viewController,
            animated: animated
        )
        return viewController
    }
    
    /// Show a view controller on the given view controller modally.
    /// - Parameter coordinated: The type of coordinated view controller to use.
    /// - Parameter presenter: The view controller used to present.
    /// - Parameter animated: Is the transition animated (`true` by default)?
    /// - Parameter modalStyle: The modal presentation style.
    /// - Parameter then: The completion closure.
    /// - Returns: The view controller created.
    @discardableResult func present<T: UIViewController & Coordinated>(
        _ coordinated: T.Type,
        presenter: UIViewController? = nil,
        animated: Bool = true,
        modalStyle: UIModalPresentationStyle = .formSheet,
        then: (() -> Void)? = nil
    ) -> T where T.CoordinatorType == Self {
        var viewController = T.instantiate(storyboardName: self.storyboardName)
        viewController.coordinator = self
        viewController.modalPresentationStyle = modalStyle
        (presenter ?? self.navigationController)?.present(
            viewController, animated:
            animated,
            completion: then
        )
        return viewController
    }
    
    /// Push a view controller with a coordinator.
    /// - Parameter coordinator: The coordinator to be used.
    /// - Parameter coordinated: The type of view controller to use with the coordinator.
    /// - Parameter navigationController: The navigation controller used to push.
    /// - Parameter animated: Is the transition animated (`true` by default)?
    /// - Returns: The view controller created.
    @discardableResult func push<T, U: UIViewController & Coordinated>(
        coordinator: T,
        coordinated: U.Type,
        in navigationController: UINavigationController? = nil,
        animated: Bool = true
    ) -> U where U.CoordinatorType == T {
        var viewController = U.instantiate(storyboardName: coordinator.storyboardName)
        viewController.coordinator = coordinator
        if let nav = navigationController {
            self.navigationController = nav
        }
        self.navigationController?.pushViewController(
            viewController,
            animated: animated
        )
        return viewController
    }
    
    /// Show a view controller on the given view controller modally.
    /// - Parameter coordinator: The coordinator to be used.
    /// - Parameter coordinated: The type of coordinated view controller to use.
    /// - Parameter presenter: The view controller used to present.
    /// - Parameter animated: Is the transition animated (`true` by default)?
    /// - Parameter modalStyle: The modal presentation style.
    /// - Parameter then: The completion closure.
    /// - Returns: The view controller created.
    @discardableResult func present<T, U: UIViewController & Coordinated>(
        coordinator: T,
        coordinated: U.Type,
        presenter: UIViewController? = nil,
        animated: Bool = true,
        modalStyle: UIModalPresentationStyle = .formSheet,
        then: (() -> Void)? = nil
    ) -> U where U.CoordinatorType == T {
        var viewController = U.instantiate(storyboardName: coordinator.storyboardName)
        viewController.coordinator = coordinator
        viewController.modalPresentationStyle = modalStyle
        (presenter ?? self.navigationController)?.present(
            viewController, animated:
            animated,
            completion: then
        )
        return viewController
    }
    
}
