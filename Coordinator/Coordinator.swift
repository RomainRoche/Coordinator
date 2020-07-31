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
    var navigationController: UINavigationController { get set }
    /// A parent coordinator.
    var parent: Coordinator? { get set }
    /// Init.
    init(navigationController: UINavigationController)
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
        self.navigationController.pushViewController(viewController, animated: false)
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
        animated: Bool = true
    ) -> T where T.CoordinatorType == Self {
        var viewController = T.instantiate(storyboardName: self.storyboardName)
        viewController.coordinator = self
        self.navigationController.pushViewController(
            viewController,
            animated: animated
        )
        return viewController
    }
    
    /// Show a view controller on the given view controller modally.
    /// - Parameter coordinated: The type of coordinated view controller to use.
    /// - Parameter animated: Is the transition animated (`true` by default)?
    /// - Parameter modalStyle: The modal presentation style.
    /// - Parameter then: The completion closure.
    /// - Returns: The view controller created.
    @discardableResult func present<T: UIViewController & Coordinated>(
        _ coordinated: T.Type,
        animated: Bool = true,
        modalStyle: UIModalPresentationStyle = .formSheet,
        then: (() -> Void)? = nil
    ) -> T where T.CoordinatorType == Self {
        var viewController = T.instantiate(storyboardName: self.storyboardName)
        viewController.coordinator = self
        viewController.modalPresentationStyle = modalStyle
        self.navigationController.present(
            viewController, animated:
            animated,
            completion: then
        )
        return viewController
    }
    
    /// Push a view controller with a coordinator.
    /// - Parameter coordinator: The coordinator to be used.
    /// - Parameter coordinated: The type of view controller to use with the coordinator.
    /// - Parameter animated: Is the transition animated (`true` by default)?
    /// - Returns: The view controller created.
    @discardableResult func push<T, U: UIViewController & Coordinated>(
        coordinator: T,
        coordinated: U.Type,
        animated: Bool = true
    ) -> U where U.CoordinatorType == T {
        coordinator.navigationController = self.navigationController
        var viewController = U.instantiate(storyboardName: coordinator.storyboardName)
        viewController.coordinator = coordinator
        self.navigationController.pushViewController(
            viewController,
            animated: animated
        )
        return viewController
    }
    
    /// Show a view controller on the given view controller modally.
    /// - Parameter coordinator: The coordinator to be used.
    /// - Parameter coordinated: The type of coordinated view controller to use.
    /// - Parameter animated: Is the transition animated (`true` by default)?
    /// - Parameter modalStyle: The modal presentation style.
    /// - Parameter then: The completion closure.
    /// - Returns: The view controller created.
    @discardableResult func present<T, U: UIViewController & Coordinated>(
        coordinator: T,
        coordinated: U.Type,
        animated: Bool = true,
        modalStyle: UIModalPresentationStyle = .formSheet,
        then: (() -> Void)? = nil
    ) -> U where U.CoordinatorType == T {
        var viewController = U.instantiate(storyboardName: coordinator.storyboardName)
        viewController.coordinator = coordinator
        viewController.modalPresentationStyle = modalStyle
        coordinator.navigationController.pushViewController(viewController, animated: false)
        coordinator.parent = self
        self.navigationController.present(
            coordinator.navigationController,
            animated: animated,
            completion: then
        )
        return viewController
    }
    
    /// Dismiss.
    /// - Parameter animated: Is the dismiss animated?
    /// - Parameter then: The dismiss closure.
    /// - Parameter ok: Did the dismiss occured?
    func dismiss(
        animated: Bool = true,
        then: ((_ ok: Bool) -> Void)? = nil
    ) {
        // if no parent, then(false)
        guard let parentVC = self.navigationController.parent
            , parentVC === self.parent?.navigationController else
        {
            then?(false)
            return
        }
        // do dismiss
        self.parent = nil
        parentVC.dismiss(animated: animated) {
            then?(true)
        }
    }

}
