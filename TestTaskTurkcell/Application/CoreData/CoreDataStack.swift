//
//  CoreDataStack.swift
//  TestTaskTurkcell
//
//  Created by Sergey Starushkin on 27.02.21.
//

import Foundation
import UIKit
import CoreData

// TODO: - Implement coredata
final class CoreDataStack {
    
    var product: [NSManagedObject] = []
    // MARK: - Save Product
    func saveProduct(name: String, image: UIImage, id: String, price: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Product", in: managedContext)!
        let person = NSManagedObject(entity: entity, insertInto: managedContext)
        person.setValue(name, forKeyPath: "name")
        person.setValue(image, forKeyPath: "image")
        person.setValue(id, forKeyPath: "id")
        person.setValue(price, forKeyPath: "price")
        if managedContext.hasChanges{
            do {
                try managedContext.save()
                product.append(person)
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
    }
    // MARK: - Clear Product
    func clearData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
          return
        }

        let managedContext = appDelegate.persistentContainer.viewContext
        do{
           try managedContext.execute(NSBatchDeleteRequest(fetchRequest: NSFetchRequest(entityName: "Product")))
            try managedContext.save()
        } catch {}
    }
    // MARK: - Clear Product Details
    func clearDataDetails() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
          return
        }

        let managedContext = appDelegate.persistentContainer.viewContext
        do{
           try managedContext.execute(NSBatchDeleteRequest(fetchRequest: NSFetchRequest(entityName: "ProductDetails")))
            try managedContext.save()
        } catch {}
    }
    // MARK: - Save Product Details
    func saveProductDetail(name: String, image: UIImage, id: String, price: String, more: String) {
      guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
        return
      }

      let managedContext = appDelegate.persistentContainer.viewContext
      let entity = NSEntityDescription.entity(forEntityName: "ProductDetails", in: managedContext)!
      let person = NSManagedObject(entity: entity, insertInto: managedContext)
      person.setValue(name, forKeyPath: "name")
      person.setValue(image, forKeyPath: "image")
      person.setValue(id, forKeyPath: "id")
      person.setValue(price, forKeyPath: "price")
      person.setValue(more, forKeyPath: "more")
        if managedContext.hasChanges{
            do {
                try managedContext.save()
                product.append(person)
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
    }

  }
