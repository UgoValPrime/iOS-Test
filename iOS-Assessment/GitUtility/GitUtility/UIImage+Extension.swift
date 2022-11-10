//
//  UIImage+Extension.swift
//  iOS-Assessment
//
//  Created by Ugo Val on 06/11/2022.
//

import UIKit

extension UIImageView {
     
    public var cache: NSCache<NSString, UIImage> { API.cache }
    
    public func downloadImage(from urlString: String) {
       
        let cacheKey = NSString(string: urlString)
        if let image = cache.object(forKey: cacheKey) {
          self.image = image
          return
        }
        guard let url = URL(string: urlString) else { return }
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
          guard let self = self else { return }
          if let _ = error { return }
          guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { return }
          guard let data = data else { return }
          guard let image = UIImage(data: data) else {
              dump("error creating image from data: \(String(describing: error))")
            return
          }
          self.cache.setObject(image, forKey: cacheKey)
          DispatchQueue.main.async { self.image = image }
        }
        task.resume()
      }
    
    
}
