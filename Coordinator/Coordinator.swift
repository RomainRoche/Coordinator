//
//  Coordinator.swift
//  Coordinator
//
//  Created by Romain Roche on 30/07/2020.
//  Copyright © 2020 rroche. All rights reserved.
//

import UIKit

public protocol Coordinator: AnyObject {
    /// The name of the storyboard used to instantiate the view controllers.
    var storyboardName: String { get }
    /// The navigation controller used to navigate in the coordinator.
    var navigationController: UINavigationController { get set }
    /// A parent coordinator.
    var parent: Coordinator? { get set }
}

public extension Coordinator {
    
    // MARK: - private
    
    private var presentedViewController: UIViewController {
        var vc: UIViewController = self.navigationController
        while let next = vc.presentedViewController {
            vc = next
        }
        return vc
    }
    
    // MARK: - public
    
    /// Create a coordinated view controller.
    /// - Parameter coordinated: The type of the coordinated view controller.
    /// - Returns: A `Coordinated` view controller.
    func make<T: Coordinated & UIViewController>(
        coordinated: T.Type
    ) -> T where T.CoordinatorType == Self {
        var coordinated = T.instantiate(
            storyboardName: self.storyboardName, in: Bundle(for: Self.self)
        )
        coordinated.coordinator = self
        return coordinated
    }
    
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
    /// - Parameter viewController: The type of coordinated view controller to use.
    /// - Parameter navigationController: The navigation controller used to push.
    /// - Parameter animated: Is the transition animated (`true` by default)?
    /// - Returns: The view controller created.
    @discardableResult func push<T: UIViewController & Coordinated>(
        _ viewController: T,
        animated: Bool = true
    ) -> T where T.CoordinatorType == Self {
        self.navigationController.pushViewController(
            viewController,
            animated: animated
        )
        return viewController
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
    /// - Parameter embedInNavigationController: Embed in a navigation controller.
    /// - Parameter then: The completion closure.
    /// - Returns: The view controller created.
    @discardableResult func present<T: UIViewController & Coordinated>(
        _ coordinated: T.Type,
        animated: Bool = true,
        modalStyle: UIModalPresentationStyle = .formSheet,
        in navigationController: UINavigationController? = nil,
        then: (() -> Void)? = nil
    ) -> T where T.CoordinatorType == Self {
        var viewController = T.instantiate(storyboardName: self.storyboardName)
        viewController.coordinator = self
        viewController.modalPresentationStyle = modalStyle
        if let navigation = navigationController {
            navigation.viewControllers = [viewController]
            navigation.modalPresentationStyle = modalStyle
            self.presentedViewController.present(
                navigation,
                animated: animated,
                completion: then
            )
        } else {
            self.presentedViewController.present(
                viewController,
                animated: animated,
                completion: then
            )
        }
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
    
    /// Present a coordinator over the receiver.
    /// - Parameter coordinator: The coordinator to present.
    /// - Parameter animated: Should the presentation be animated.
    /// - Parameter modalStyle: A modal style, `.formSheet` by default.
    /// - Parameter then: The completion closure.
    func present<T: Coordinator>(
        coordinator: T,
        animated: Bool = true,
        modalStyle: UIModalPresentationStyle = .formSheet,
        then: (() -> Void)? = nil
    ) {
        coordinator.navigationController.modalPresentationStyle = modalStyle
        coordinator.parent = self
        self.presentedViewController.present(
            coordinator.navigationController,
            animated: animated,
            completion: then
        )
    }
    
    /// Show a view controller on the given view controller modally.
    /// - Parameter coordinator: The coordinator to be used.
    /// - Parameter coordinated: The type of coordinated view controller to use.
    /// - Parameter animated: Is the transition animated (`true` by default)?
    /// - Parameter modalStyle: The modal presentation style, `.formSheet` by default.
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
        coordinator.navigationController.pushViewController(viewController, animated: false)
        self.present(coordinator: coordinator, animated: animated, modalStyle: modalStyle, then: then)
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
        // do dismiss
        self.parent = nil
        self.navigationController.dismiss(animated: true) {
            then?(true)
        }
    }
    
    func present<T: Coordinator>(
        coordinator: T,
        viewController: UIViewController,
        animated: Bool = true,
        modalStyle: UIModalPresentationStyle = .formSheet,
        then: (() -> Void)? = nil
    ) {
        viewController.modalPresentationStyle = modalStyle
        coordinator.parent = self
        self.presentedViewController.present(
            viewController,
            animated: animated,
            completion: then
        )
    }

}
