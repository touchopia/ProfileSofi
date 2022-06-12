//
//  UIImage+Ext.swift
//  ProfileSofi
//
//  Created by Phil Wright on 6/12/22.
//

import UIKit

public extension UIWindow {
    func screenshot() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.frame.size, self.isOpaque, UIScreen.main.scale)
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

public extension UIImageView {
    func imageFromUrl(url: URL) {
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let data = data {
                DispatchQueue.main.async {
                    self.image = UIImage(data: data)
                }
            } else {
                print("\(error.debugDescription)")
            }
        }.resume()
    }
}
