//
//  CartItemViewModel.swift
//  TestTaskTurkcell
//
//  Created by Sergey Starushkin on 27.02.21.
//

import Foundation
import UIKit
import CoreData

final class ProductItemViewModel: BaseViewModel {
    weak var delegate: CartItemViewModelDelegate?
    
    // MARK: - View State
    private(set) var viewState: ViewState = .unknown {
        didSet {
            delegate?.updateUI(for: viewState)
        }
    }
    
    // MARK: - Properties
    private var itemResponse: DetailedProductItemResponse? {
        didSet {
            createItem(from: itemResponse)
        }
    }
    var StoredResults = [NSManagedObject]()

    private(set) var detailedCartItem: DetailedProductItem = DetailedProductItem.emptyDetailedItem {
        didSet {
            viewState = .loaded
        }
    }

}

// MARK: - Download Item

extension ProductItemViewModel {
    
    func downloadDetailedItem(item: String) {
        guard isReachable else { return viewState = .badConnection }
        
        viewState = .loading
        dataProvider.loadItem(item) { [weak self] response, error  in
            guard let itemResponse = response else {
                self?.viewState = .badResponse
                return
            }
            
            if let error = error {
                self?.viewState = .error(error)
            }
            
            self?.itemResponse = itemResponse
        }
    }
    func queryCoreData(id: String){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
          return
        }
        var name: String
        var price: String
        var more: String
        var idr: String
        var image: UIImage
        let managedContext = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ProductDetails")
                let predicate =  NSPredicate(format:"id == %@", argumentArray: ["\(id)"])
                request.predicate = predicate
            do {
                let results =
                    try managedContext.fetch(request)
                for data in results as! [NSManagedObject] {
                        name = data.value(forKey: "name") as! String
                        price = data.value(forKey: "price") as! String
                        idr = data.value(forKey: "id") as! String
                        more = data.value(forKey: "more") as! String
                        image = data.value(forKey: "image") as! UIImage
                    self.detailedCartItem = DetailedProductItem(id: idr,
                                                              name: name,
                                                              price: Int(price) ?? 0,
                                                              image: image,
                                                              description: more)
                      }
                } catch let error as NSError {
                      print(" error executing fetchrequest  ", error)
                }
    }
    
}


// MARK: - Create Item
extension ProductItemViewModel {
    
    private func createItem(from detailedItemResponse: DetailedProductItemResponse?) {
        let coreDataProvider = CoreDataStack()
        guard let response = detailedItemResponse else { return }
        guard isReachable else { return viewState = .badConnection }
        let url = URL(string: response.imageUrl)
        self.imageProvider.getImageDataFrom(url: url!) { [weak self] image, error in
            guard let image = image else {
                self?.viewState = .badResponse
                return
            }
            
            if let error = error {
                self?.viewState = .error(error)
            }
            coreDataProvider.saveProductDetail(name: response.name, image: image, id: String(response.id), price: String(response.price), more: response.description)
            self?.detailedCartItem = DetailedProductItem(id: response.id,
                                                      name: response.name,
                                                      price: response.price,
                                                      image: image,
                                                      description: response.description)
        }
    }
    
}
