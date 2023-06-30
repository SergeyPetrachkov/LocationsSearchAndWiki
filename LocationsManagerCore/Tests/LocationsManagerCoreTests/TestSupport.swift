//
//  TestSupport.swift
//  
//
//  Created by Sergey Petrachkov on 28.06.2023.
//

import UIKit

final class MockViewController: UIViewController {
    var dismissCalled: Bool = false
    var presentCalled: Bool = false

    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        presentCalled = true
        super.present(viewControllerToPresent, animated: flag, completion: completion)
    }

    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        dismissCalled = true
        super.dismiss(animated: flag, completion: completion)
    }
}

final class MockNavigationViewController: UINavigationController {
    var dismissCalled: Bool = false
    var presentCalled: Bool = false

    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        presentCalled = true
        super.present(viewControllerToPresent, animated: flag, completion: completion)
    }

    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        dismissCalled = true
        super.dismiss(animated: flag, completion: completion)
    }
}
