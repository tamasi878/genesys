//
//  ImageService.swift
//  MessageFlow
//
//  Created by Tamási Móni on 2023. 02. 15..
//

import UIKit

final class ImageService {
    private let imageCache = NSCache<NSURL, UIImage>()
    
    func download(from uri: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: uri) else { return }
        
        if let image = imageCache.object(forKey: url as NSURL) {
            completion(image)
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else { return }
            
            if let image = UIImage(data: data) {
                self?.imageCache.setObject(image, forKey: url as NSURL)
                completion(image)
            }
        }
    }
}
