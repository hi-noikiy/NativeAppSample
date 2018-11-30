/**
 Copyright © 2018 Visa. All rights reserved.
 */

import UIKit
import VisaCheckoutSDK

class CustomNavigationController: UINavigationController {
    override init(rootViewController: UIViewController) {
        super.init(navigationBarClass: nil, toolbarClass: UIToolbar.self)
        setToolbarHidden(false, animated: false)
        setViewControllers([rootViewController], animated: false)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        VisaCheckoutSDK.configure()

        let vc = ChildViewController()
        let nav = CustomNavigationController(rootViewController: vc)
        nav.pushViewController(ParentViewController(), animated: false)

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = nav
        window?.makeKeyAndVisible()

        return true
    }
}
