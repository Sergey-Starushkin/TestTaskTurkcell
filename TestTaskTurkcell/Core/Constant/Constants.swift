//
//  Constants.swift
//  TestTaskTurkcell
//
//  Created by Sergey Starushkin on 27.02.21.
//
import UIKit

struct Constants {

    struct Storage {
        static let ModelName = "TestTaskTurkcell"
    }
    
    struct Layout {
        static let CollectionViewEdgeInsets = UIEdgeInsets(top: 20.0,
                                                           left: 20.0,
                                                           bottom: 20.0,
                                                           right: 20.0)
    }
    
    struct Nibs {
        static let BadConnectionView = "BadConnectionView"
        static let LoadingView = "LoadingView"
    }
    struct Controllers {
        static let SplashViewController = "SplashViewController"
        static let ProductViewController = "ProductViewController"
        static let ProductItemViewController = "ProductItemViewController"
    }
}
