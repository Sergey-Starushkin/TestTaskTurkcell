//
//  DetailedCartItem.swift
//  TestTaskTurkcell
//
//  Created by Sergey Starushkin on 27.02.21.
//

import Foundation
import UIKit

//swiftlint:disable image_name_initialization
struct DetailedProductItem: Equatable {
    var id: String
    var name: String
    var price: Int
    var image: UIImage
    var description: String
    
    static let emptyDetailedItem = DetailedProductItem(id: "",
                                                    name: "",
                                                    price: -1,
                                                    image: UIImage(named: "placeholder")!,
                                                    description: "")
}
