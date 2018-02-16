//
//  UIImageView+Extension.swift
//  WeatherAppMVC
//
//  Created by ramchandra on 16/02/18.
//  Copyright © 2018 ramchandra. All rights reserved.
//

import UIKit

var imageCache: [String: UIImage] = [:]

extension UIImageView {
    func setImage(fromUrl url: URL) {
        let imageKey: String = url.lastPathComponent
        if let cacheImage = imageCache[imageKey] {
            DispatchQueue.main.async {
                self.image = cacheImage
            }
        } else {
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else { return }
                print("fileName", response?.suggestedFilename ?? url.lastPathComponent)
                if let newImage = UIImage(data: data) {
                    imageCache[imageKey] = newImage
                    DispatchQueue.main.async {
                        self.image = newImage
                    }
                }
                }.resume()
        }
    }
}
