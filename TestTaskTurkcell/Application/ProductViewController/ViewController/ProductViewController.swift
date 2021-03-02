//
//  CartViewController.swift
//  TestTaskTurkcell
//
//  Created by Sergey Starushkin on 27.02.21.
//

import UIKit
import Foundation
import CoreData

final class ProductViewController: UIViewController {
    
    // MARK: - UI
    
    private var refreshControl: UIRefreshControl!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var loadingView: LoadingView!
    @IBOutlet private weak var badConnectionView: BadConnectionView! {
        didSet {
            badConnectionView.delegate = self
        }
    }
    var product: [NSManagedObject] = []
    
    
    // MARK: - Properties
    private var additionalPadding: CGFloat = 0
    var viewModel = ProductViewModel() {
        didSet {
            viewModel.delegate = self
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
          return
        }
        super.viewDidLoad()
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Product")
        do {
          product = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
        }
        setupCollectionView()
        setupRefreshControl()
    }
    
}

// MARK: - UpdateUI
extension ProductViewController: CartViewModelDelegate {
    func updateUI(for state: ProductViewModel.ViewState) {
        DispatchQueue.main.async {
            switch state {
            case .loaded:
                self.title = "loaded"
                self.loadingView.hide()
                self.badConnectionView.hide()
                self.refreshControl.endRefreshing()
                self.collectionView.reloadData()
                
            case .badConnection:
                self.title = "bad connection"
                self.loadingView.hide()
                self.refreshControl.endRefreshing()
                self.badConnectionView.show()
                
            case .loading:
                self.title = "loading"
                self.loadingView.show()
                self.collectionView.reloadData()
                
            case .badResponse:
                self.title = "bad response"
            
            case .error(let error):
                self.title = error.localizedDescription
                
            default:
                self.title = "feed"
                self.collectionView.reloadData()
            }
        }
    }
}

    // MARK: - Update View

extension ProductViewController: BadConnectionViewDelegate {
    func updateView() {
        viewModel.downloadCartItems()
    }
}

// MARK: - CollectionView Delegate
extension ProductViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        
        viewModel.navigateToCartItemViewController(for: indexPath, from: self)
    }
}

// MARK: - CollectionView Data Source
extension ProductViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        
        product.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionViewCell.reuseIdentifier,
                                                            for: indexPath) as? ProductCollectionViewCell else { return UICollectionViewCell() }
        print(product.count)
        let item = product[indexPath.row]
        
        let name = item.value(forKey: "name") as? String
        let price = item.value(forKey: "price") as? String
        let image = item.value(forKey: "image")
        cell.update(name: name ?? "",
                    price: price ?? "",
                    image: image as! UIImage)
        return cell
    }
}

// MARK: - CollectionView Flow Delegate
extension ProductViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let horizontalItemsPerRow: CGFloat = 2
        let verticalItemsPerRow: CGFloat = 2
        let itemsPerRow = UIDevice.current.orientation.isPortrait ? verticalItemsPerRow : horizontalItemsPerRow
        let sectionInsets = Constants.Layout.CollectionViewEdgeInsets
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace - additionalPadding
        let itemWidth = availableWidth / itemsPerRow
        let itemHeight = UIDevice.current.orientation.isPortrait ? view.frame.height / 3 : view.frame.height / 2
        
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        
        Constants.Layout.CollectionViewEdgeInsets
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        Constants.Layout.CollectionViewEdgeInsets.left
    }
}


    // MARK: - Configure

extension ProductViewController {
    
    private func setupCollectionView() {
        
        let nib = UINib(nibName: ProductCollectionViewCell.reuseIdentifier, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: ProductCollectionViewCell.reuseIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()
    }
    
    private func setupRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refreshView), for: .valueChanged)
        collectionView.addSubview(refreshControl)
    }
    
    @objc private func refreshView(sender: UIRefreshControl) {
        viewModel.downloadCartItems()
    }
    
}

    // MARK: - Transition

extension ProductViewController {
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
}
