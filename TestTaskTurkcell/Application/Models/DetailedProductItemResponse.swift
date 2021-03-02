//
//  DetailedCartItem.swift
//  TestTaskTurkcell
//
//  Created by Sergey Starushkin on 27.02.21.
//

import Foundation
import UIKit

struct DetailedProductItemResponse: Equatable, Decodable {
    var id: String = ""
    var name: String = ""
    var price: Int = -1
    var imageUrl: String = ""
    var description: String = ""
    
    fileprivate enum CodingKeys: String, CodingKey {
        case id = "product_id"
        case name = "name"
        case price = "price"
        case imageUrl = "image"
        case description = "description"
    }
    
    init(from decoder: Decoder) throws {
        let detailedCartItemResponseContainer = try decoder.container(keyedBy: CodingKeys.self)
        id = try detailedCartItemResponseContainer.decode(String.self, forKey: .id)
        name = try detailedCartItemResponseContainer.decode(String.self, forKey: .name)
        price = try detailedCartItemResponseContainer.decode(Int.self, forKey: .price)
        imageUrl = try detailedCartItemResponseContainer.decode(String.self, forKey: .imageUrl)
        description = try detailedCartItemResponseContainer.decode(String.self, forKey: .description)
    }
}
