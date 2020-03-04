//
//  Extensions.swift
//  Yelp
//
//  Created by Charles Wang on 3/3/20.
//  Copyright © 2020 Charles Wang. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    func loadImageFrom(url: String?) {
        if let url = url {
            let asURL = URL(string: url)
            URLSession.shared.dataTask(with: asURL!) { (data, response, error) in
                if let data = data {
                    DispatchQueue.main.async {
                        self.image = UIImage(data: data)
                    }
                }
            }.resume()
        }
    }
    func setColor(_ color: UIColor) {
        self.image = self.image?.withRenderingMode(.alwaysTemplate)
        self.tintColor = color
    }
}

extension UIView {
    func makeCircular(filling: UIColor? = nil, opacity: CGFloat = 1.0) {
        self.layer.cornerRadius = self.frame.size.width / 2
        if (filling != nil) {
            self.backgroundColor = filling
        }
        self.alpha = opacity
    }
    func drawOutline(thick: Float, color: UIColor = .white) {
        self.layer.borderWidth = CGFloat(thick)
        self.layer.borderColor = color.cgColor
    }
}
