/**
 Copyright © 2018 Visa. All rights reserved.
 */

import UIKit
import VisaCheckoutSDK

class ParentViewController: UIViewController {
    var cart: ChildViewController?
    var checkoutButton = VisaCheckoutButton()
    var launchCheckoutHandle: LaunchHandle?

    override func loadView() {
        super.loadView()

        title = "Standard Button"

        let cart = ChildViewController()
        self.cart = cart

        view.backgroundColor = .blue

        addChildViewController(cart)
        cart.view.frame = view.bounds
        view.addSubview(cart.view)
        cart.didMove(toParentViewController: self)

        initVisaCheckout()
        
        let barItem = UIBarButtonItem(customView: checkoutButton)
        self.toolbarItems = [barItem]
        checkoutButton.heightAnchor.constraint(equalToConstant: 49).isActive = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("PARENT - viewWillAppear")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("PARENT - viewDidDisappear")
    }

    func initVisaCheckout() {
        let profile = Profile(environment: .sandbox, apiKey: <#T##String#>, profileName: nil)
        profile.displayName = "Redacted"
        let amount = CurrencyAmount(double: 23.09)
        let purchaseInfo = PurchaseInfo(total: amount, currency: .usd)
        checkoutButton.onCheckout(
            profile: profile,
            purchaseInfo: purchaseInfo,
            presenting: self,
            onReady: { [weak self] launchHandle in
                self?.launchCheckoutHandle = launchHandle
            }, onButtonTapped: { [weak self] in
                self?.launchVisaCheckout()
            }, completion: resultHandler())
    }

    func resultHandler() -> VisaCheckoutResultHandler {
        return { [weak self] result in
            // Make sure to re-init in your result handler
            self?.initVisaCheckout()
            switch (result.statusCode) {
            case .statusInternalError:
                print("ERROR");
            case .statusNotConfigured:
                print("NOT CONFIGURED");
            case .statusDuplicateCheckoutAttempt:
                print("DUPLICATE CHECKOUT ATTEMPT");
            case .statusUserCancelled:
                NSLog("USER CANCELLED");
            case .statusSuccess:
                print("SUCCESS");
            case .default:
                print("SUCCESS");
            }
        }
    }

    func launchVisaCheckout() {
        guard let launchCheckout = self.launchCheckoutHandle else {
            return
        }
        launchCheckout()
    }
}

class ChildViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .green
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("CHILD - viewWillAppear")
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("CHILD - viewDidDisappear")
    }
}

/* 
 
 When presenting the Visa Checkout Modal this is the observed view lifecycle for the presented view controller: ❌
 
 ```
 PARENT - viewDidDisappear
 CHILD - viewDidDisappear
 PARENT - viewWillAppear
 CHILD - viewWillAppear
 PARENT - viewDidDisappear
 CHILD - viewDidDisappear
```
 
 The latter 4 calls to viewWillAppear/viewDidDisappear should not be a side effect of presenting the modal.
 
 When dismissing the Visa Checkout Modal, the observed view lifecycle is as expected: ✅
 
 ```
 PARENT - viewWillAppear
 CHILD - viewWillAppear
```
 
 */
