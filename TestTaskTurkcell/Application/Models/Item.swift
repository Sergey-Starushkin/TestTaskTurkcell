//
//  CartItem.swift
//  TestTaskTurkcell
//
//  Created by Sergey Starushkin on 27.02.21.
//

import UIKit
import Foundation

//swiftlint:disable image_name_initialization
struct Item: Equatable {
    let id: String
    let name: String
    let price: Int
    let image: UIImage
    
    static let emptyCartItem = Item(id: "",
                                        name: "",
                                        price: -1,
                                        image: UIImage(named: "placeholder")!)
}
