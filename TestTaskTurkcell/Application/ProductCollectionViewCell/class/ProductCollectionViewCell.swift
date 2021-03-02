//
//  CartCollectionViewCell.swift
//  TestTaskTurkcell
//
//  Created by Sergey Starushkin on 27.02.21.
//

import UIKit

final class ProductCollectionViewCell: UICollectionViewCell, SelfConfiguringCell {
    // MARK: - UI
    @IBOutlet private weak var labelsStackView: UIStackView!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var desctiptionLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!

    // MARK: - Open
    func update(name: String, price: String, image: UIImage) {
        desctiptionLabel.text = name
        priceLabel.text = price
        imageView.image = image
    }
}
