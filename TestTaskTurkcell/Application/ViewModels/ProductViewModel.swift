//
//  CartViewModel.swift
//  TestTaskTurkcell
//
//  Created by Sergey Starushkin on 27.02.21.
//

import Foundation
import UIKit
import CoreData

final class ProductViewModel: BaseViewModel {
    private let coreDataProvider = CoreDataStack()

    weak var delegate: CartViewModelDelegate?
    var product: [NSManagedObject] = []
    var products: [NSManagedObject] = []

    // MARK: - View State
    private(set) var viewState: ViewState = .unknown {
        didSet {
            delegate?.updateUI(for: viewState)
        }
    }
    
    private var cartResponse = Products(products: []) {
        didSet {
            viewState = .loading
            createCartItemsArray(from: cartResponse)
        }
    }

    private(set) var cartItems = [Item]() {
        didSet {
            if cartItems.count == cartResponse.products.count {
                viewState = .loaded
            }
        }
    }
}

    // MARK: - Configure

extension ProductViewModel {
    
    func downloadCartItems() {
        guard isReachable else { return viewState = .badConnection }
        
        coreDataProvider.clearData()
        viewState = .loading
        dataProvider.loadCartList { [weak self] response, error in
            guard let itemResponse = response else {
                self?.viewState = .badResponse
                return
            }
            
            if let error = error {
                self?.viewState = .error(error)
            }
            
            self?.cartResponse = itemResponse
        }
    }
    
    func navigateToCartItemViewController(for indexPath: IndexPath, from viewController: UIViewController, completion: (() -> Void)? = nil) {
        let storyboard = UIStoryboard(name: Constants.Controllers.ProductItemViewController, bundle: nil)
        if let controller = storyboard.instantiateViewController(withIdentifier: Constants.Controllers.ProductItemViewController) as? ProductItemViewController {
            readData()
            controller.item = cartItems[indexPath.item]
            controller.viewModel = ProductItemViewModel()
            viewController.navigationController?.pushViewController(controller, animated: true)
            completion?()
        }
    }
}

// MARK: - Create Array

extension ProductViewModel {
    private func createCartItemsArray(from cart: Products) {
        cartItems = []
        
        cart.products.forEach {
            let responseItem = $0
            guard isReachable else { return viewState = .badConnection }
            
            self.imageProvider.getImageDataFrom(url: URL(string: responseItem.imageUrl)!) { [weak self] image, error in
                guard let image = image else {
                    self?.viewState = .badResponse
                    return
                }
                
                if let error = error {
                    self?.viewState = .error(error)
                }
                
                self?.coreDataProvider.saveProduct(name: responseItem.name, image: image, id: String(responseItem.id), price: String(responseItem.price))
                self?.cartItems.append(Item(id: responseItem.id,
                                            name: responseItem.name,
                                            price: responseItem.price,
                                            image: image))
            }
        }
    }
}


    // MARK: - Reading Data From Core Data
extension ProductViewModel {
    
    func fetchData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Product")
        do {
            products = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }

    func readData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Product")
        do {
            product = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        for i in 0..<product.count {
            let price: String =  product[i].value(forKey: "price") as! String
            let inP = Int(price)
            let id = product[i].value(forKey: "id") as! String
            self.cartItems.append(Item(id: id,
                                       name: product[i].value(forKey: "name") as! String,
                                       price: inP!,
                                       image: product[i].value(forKey: "image") as! UIImage))
        }
        
    }
}

