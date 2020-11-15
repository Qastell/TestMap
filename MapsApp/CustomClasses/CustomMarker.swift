//
//  CustomMarker.swift
//  MapsApp
//
//  Created by Кирилл Романенко on 15.11.2020.
//

import Foundation
import UIKit
import GoogleMaps


class CustomMarker: GMSMarker {
    
    private var numberOfVacancy = 0
    private var salary = 0
    
    override init() {
        super.init()
        MapViewController.delegates.add(self)
        tracksViewChanges = true
    }
    
    func postVacancy(number: Int, salary: Int) {
        self.salary = salary
        self.numberOfVacancy = number
    }
    
}

extension CustomMarker: MapViewDelegate {
    func changeImageOfMarker(zoom: Float) {
        if zoom < 13.5 {
            let blueView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            blueView.backgroundColor = #colorLiteral(red: 0.3607843137, green: 0.6745098039, blue: 1, alpha: 1)
            blueView.layer.cornerRadius = blueView.frame.width/2
            blueView.layer.borderColor = UIColor.black.cgColor
            blueView.layer.borderWidth = 1
            
            icon = blueView.asImage()
        } else if zoom > 13.5, zoom <= 15 {
            if numberOfVacancy == 0 || numberOfVacancy == 1 {
                icon = UIImage(named: "pin")
            } else {
                let image = textToImage(drawText: "\(numberOfVacancy)",
                                        inImage: UIImage(named: "pinWithNumber")!,
                                        font: UIFont.boldSystemFont(ofSize: 15))
                icon = image
            }
        } else if zoom > 15 {
            if numberOfVacancy == 0 || numberOfVacancy == 1{
                let image = textToImage(drawText: "\(salary) тыс.",
                                        inImage: UIImage(named: "table")!,
                                        font: UIFont.boldSystemFont(ofSize: 15))
                icon = image
            } else {
                let image = textToImage(drawText: "\(numberOfVacancy) от \(salary) тыс.",
                                        inImage: UIImage(named: "bigTable")!,
                                        font: UIFont.boldSystemFont(ofSize: 14))
                icon = image
            }
        }
    }
    
    

    private func textToImage(drawText text: String, inImage image: UIImage, font: UIFont) -> UIImage {
        
        UIGraphicsBeginImageContext(image.size)
        image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        
        let textStyle = NSMutableParagraphStyle()
        textStyle.alignment = NSTextAlignment.center
        let textColor = UIColor.white
        let attributes=[
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.paragraphStyle: textStyle,
            NSAttributedString.Key.foregroundColor: textColor]
        
        let textH = font.lineHeight
        let textY = (image.size.height-textH)/2-(textH/4)-3
        let textRect = CGRect(x: 0, y: textY, width: image.size.width, height: textH)
        text.draw(in: textRect.integral, withAttributes: attributes)
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return UIImage() }
        UIGraphicsEndImageContext()
        return result
    }
}
