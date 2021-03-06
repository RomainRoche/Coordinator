# Coordinator

The *Coordinator* package proposes an alternative to using *segues* to navigate between screens in iOS apps. The *coordinator* also provides a way to share data and logic between view controllers of the same flow.

This is a very early draft. Don't hesitate to give your feedbacks!

## Use a `Coordinator`

### Implement a `Coordinator`

```
class MyCoordinator: Coordinator {
    
    let storyboardName = "my-storyboard"
    var navigationController = UINavigationController()
    var parent: Coordinator?
    
}
```

### Implement a `Coordinated` view controller

A view controller subclass needs to implement the `Coordinated` protocol to be used with a `Coordinator` implementation.

```
class MyViewController: UIViewController, Coordinated {

    typealias CoordinatorType = MyCoordinator
    var coordinator = MyCoordinator()

}
```

A `Coordinated` view controller will also implement the `Storyboarded` protocol of the framework. This is a shortcut allowing to instantiate a view controller from a storyboard. 

To do so:
* In the `"my-storyboard"` storyboard used by `MyCoordinator` add a View Controller
* Set its class to `MyViewController` in the identity inspector
* Set its **Storyboard ID** to `MyViewController` too

### Operations from a `Coordinated` view controller.

In the following example `MainViewController` and `OtherViewController` both implement `Coordinated` with the same `CoordinatorType` typealias.

```
class MainViewController: Coordinated {

    typealias CoordinatorType = MyCoordinator
    var coordinator = MyCoordinator()
    
    func goToOther() {
        let other = self.coordinator.push(OtherViewController.self)
    }
    
    func presentOther() {
        let other = self.coordinator.present(OtherViewController.self)
    }

}
```
`MainViewController` and `OtherViewController` will then have the same instance of `MyCoordinator` and can then share properties through it.

#### Customizing view controller

When pushing or presenting, the `Coordinated` view controller created is returned, allowing you to set what you need on it.

```
let other = self.coordinator.present(OtherViewController.self)
other.doSetup()
```

**NOTE** The returned view controller can be ignored.
```
// no reference to the returned view controller
self.coordinator.present(OtherViewController.self)
```

### Use another `Coordinator`

A `Coordinator` can **push** another coordinator, or **present** it modally.

#### Push in the same navigation controller

```
class MainViewController: Coordinated {

    typealias CoordinatorType = MyCoordinator
    var coordinator = MyCoordinator()
    
    func goToNextCoordinator() {
        self.coordinator.push(
            coordinator: NextCoordinator(),
            coordinated: NextViewController.self
        )
    }

}
```
#### Present another coordinator

```
class MainViewController: Coordinated {

    typealias CoordinatorType = MyCoordinator
    var coordinator = MyCoordinator()
    
    func presentNextCoordinator() {
        self.coordinator.present(
            coordinator: NextCoordinator(),
            coordinated: NextViewController.self
        )
    }

}
```

The presented coordinator can the be dismissed.

`nextCoordinator.dismiss()`
