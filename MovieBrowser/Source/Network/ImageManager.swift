//
//  ImageManager.swift
//  MovieBrowser
//
//  Created by Sanketh on 20/12/21.
//  Copyright © 2021 Lowe's Home Improvement. All rights reserved.
//

import UIKit

struct ImageManager {
    static let shared: ImageManager = ImageManager()
    var cache: NSCache<NSString, UIImage>!
    
    private init() {
        self.cache = NSCache()
    }
    
    func loadImage(at path: String, completionHandler: @escaping (UIImage?) -> ()) {
        let imagePath = EndPoints.posterPath + path
        if let image = self.cache.object(forKey: imagePath as NSString) {
            DispatchQueue.main.async {
                completionHandler(image)
            }
        } else {
            let placeholder = #imageLiteral(resourceName: "placeholder")
            DispatchQueue.main.async {
                completionHandler(placeholder)
            }
            guard let url = URL(string: imagePath) else { return }
            var urlRequest: URLRequest! = URLRequest(url: url)
            urlRequest.httpMethod = "GET"
            
            let downloadTask = URLSession.shared.downloadTask(with: urlRequest, completionHandler: { (location, response, error) in
                do {
                    guard let localFilePath = location else { return }
                    let data = try Data(contentsOf: localFilePath)
                        
                    if let imgage: UIImage = UIImage(data: data) {
                        self.cache.setObject(imgage, forKey: imagePath as NSString)
                        DispatchQueue.main.async {
                            completionHandler(imgage)
                        }
                    } else {
                        DispatchQueue.main.async {
                            completionHandler(placeholder)
                        }
                    }
                } catch {
                    DispatchQueue.main.async {
                        completionHandler(placeholder)
                    }
                }
            })
            downloadTask.resume()
        }
    }
}

