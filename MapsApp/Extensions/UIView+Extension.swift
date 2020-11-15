//
//  UIView+Extension.swift
//  MapsApp
//
//  Created by Кирилл Романенко on 15.11.2020.
//

import Foundation
import UIKit

extension UIView {

    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}
