//
//  RootViewController.swift
//  TestTaskTurkcell
//
//  Created by Sergey Starushkin on 27.02.21.
//

import UIKit

final class SplashViewController: UIViewController {
    
    // MARK: - UI
    
    @IBOutlet private weak var loadingActivityIndicator: UIActivityIndicatorView!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createNetworkingRequests()
    }
    
}

    // MARK: - Configure
private extension SplashViewController{
    
    private func createNetworkingRequests() {
        loadingActivityIndicator.startAnimating()
        let cartViewModel = ProductViewModel()
        cartViewModel.downloadCartItems()

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.loadingActivityIndicator.stopAnimating()
            AppDelegate.shared.rootViewController.showCartViewController(with: cartViewModel)
        }
    }
    
}
