//
//  ImageProvider.swift
//  TestTaskTurkcell
//
//  Created by Sergey Starushkin on 27.02.21.
//

import UIKit

typealias ImageCompletionBlock = (_ response: UIImage?, _ error: Error?) -> Void

final class ImageProvider {
     func getImageDataFrom(url: URL, completion: @escaping ImageCompletionBlock) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            // Handle Error
            if let error = error {
                print("DataTask error: \(error.localizedDescription)")
                completion(nil, error)
            }
            
            guard let data = data else {
                // Handle Empty Data
                print("Empty Data")
                return
            }
            
            DispatchQueue.main.async {
                if let image = UIImage(data: data) {
                    completion(image, nil)
                }
            }
        }.resume()
    }
}

