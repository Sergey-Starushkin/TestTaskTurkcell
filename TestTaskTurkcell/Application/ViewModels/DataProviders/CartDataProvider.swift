//
//  CartDataProvider.swift
//  TestTaskTurkcell
//
//  Created by Sergey Starushkin on 27.02.21.
//

import Foundation

typealias CartCompletionBlock = (_ response: Products?, _ error: Error?) -> Void
typealias ItemCompletionBlock = (_ response: DetailedProductItemResponse?, _ error: Error?) -> Void

final class CartDataProvider {
    
    private var dataTask: URLSessionDataTask?
    func loadCartList(completion: @escaping CartCompletionBlock) {
        let popularMoviesURL = "https://s3-eu-west-1.amazonaws.com/developer-application-test/cart/list"
        
        guard let url = URL(string: popularMoviesURL) else {return}
        
        // Create URL Session - work on the background
        dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            // Handle Error
            if let error = error {
                completion(nil, error)
                print("DataTask error: \(error.localizedDescription)")
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                // Handle Empty Response
                print("Empty Response")
                return
            }
            print("Response status code: \(response.statusCode)")
            
            guard let data = data else {
                // Handle Empty Data
                print("Empty Data")
                return
            }
            
            do {
                // Parse the data
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(Products.self, from: data)
                // Back to the main thread
                DispatchQueue.main.async {
                    completion(jsonData, nil)
                }
            } catch let error {
                completion(nil, error)
            }
            
        }
        dataTask?.resume()
    }
    func loadItem(_ item: String, completion: @escaping ItemCompletionBlock) {
        var dataTask: URLSessionDataTask?
        let popularMoviesURL = "https://s3-eu-west-1.amazonaws.com/developer-application-test/cart/\(item)/detail"
        
        guard let url = URL(string: popularMoviesURL) else {return}
        
        // Create URL Session - work on the background
        dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            // Handle Error
            if let error = error {
                completion(nil, error)
                print("DataTask error: \(error.localizedDescription)")
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                // Handle Empty Response
                print("Empty Response")
                return
            }
            print("Response status code: \(response.statusCode)")
            
            guard let data = data else {
                // Handle Empty Data
                print("Empty Data")
                return
            }
            
            do {
                // Parse the data
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(DetailedProductItemResponse.self, from: data)
                // Back to the main thread
                DispatchQueue.main.async {
                    completion(jsonData, nil)
                }
            } catch let error {
                completion(nil, error)
            }
            
        }
        dataTask?.resume()
}
    }
