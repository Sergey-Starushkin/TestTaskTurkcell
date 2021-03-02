//
//  CartItemViewController.swift
//  TestTaskTurkcell
//
//  Created by Sergey Starushkin on 27.02.21.
//

import UIKit

final class ProductItemViewController: UIViewController {
    
    // MARK: - UI
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    // MARK: - Properties
    
    var viewModel = ProductItemViewModel() {
        didSet {
            viewModel.delegate = self
        }
    }
    var item: Item = Item.emptyCartItem

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTextAlignment()
        viewModel.downloadDetailedItem(item: item.id)
        viewModel.queryCoreData(id: item.id)
    }
    
}

    // MARK: - UpdateUI

extension ProductItemViewController: CartItemViewModelDelegate {
    func updateUI(for state: ProductItemViewModel.ViewState) {
        DispatchQueue.main.async {
            switch state {
            case .loaded:
                self.title = "loaded"
                let detailedItem = self.viewModel.detailedCartItem
                self.imageView.image = detailedItem.image
                self.nameLabel.text = detailedItem.name
                self.descriptionLabel.text = detailedItem.description
                self.priceLabel.text = "\(String(describing: detailedItem.price)) $"
                
            case .badConnection:
                self.title = "bad connection"

            case .loading:
                self.title = "loading"
                self.imageView.image = self.item.image
                self.nameLabel.text = self.item.name
                self.descriptionLabel.text = "Loading..."
                self.priceLabel.text = "\(String(describing: self.item.price)) $"
                
            case .badResponse:
                self.title = "bad response"
                self.imageView.image = self.item.image
                self.nameLabel.text = self.item.name
                self.descriptionLabel.text = "Description was missed"
                self.priceLabel.text = "\(String(describing: self.item.price)) $"

            case .error(let error):
                self.title = error.localizedDescription
                
            default:
                self.title = "unknown state"
            }
        }
    }
        
}

    // MARK: - Configure
private extension ProductItemViewController {
    private func configureTextAlignment() {
        [nameLabel, priceLabel, descriptionLabel].forEach {
            $0?.textAlignment = UIDevice.current.orientation.isLandscape ? .left : .center
        }
    }
}
