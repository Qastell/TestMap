//
//  MapClusterIconGenerator.swift
//  MapsApp
//
//  Created by Кирилл Романенко on 14.11.2020.
//

import Foundation
import GoogleMapsUtils

class MapClusterIconGenerator: GMUDefaultClusterIconGenerator {
    

    override func icon(forSize size: UInt) -> UIImage {
        let mutableSize = 40+Double(size)*0.1
        
        let whiteBigView = UIView(frame: CGRect(x: 0, y: 0, width: mutableSize, height: mutableSize))
        whiteBigView.backgroundColor = .white
        whiteBigView.layer.cornerRadius = whiteBigView.frame.width/2
        
        let blueView = UIView(frame: CGRect(x: 0, y: 0, width: mutableSize*0.97, height: mutableSize*0.97))
        blueView.backgroundColor = #colorLiteral(red: 0.3611436546, green: 0.6756275439, blue: 1, alpha: 1)
        blueView.center = whiteBigView.center
        blueView.layer.cornerRadius = blueView.frame.width/2
        
        let whiteSmallview = UIView(frame: CGRect(x: 0, y: 0, width: mutableSize*0.80, height: mutableSize*0.80))
        whiteSmallview.center = whiteBigView.center
        whiteSmallview.backgroundColor = .white
        whiteSmallview.layer.cornerRadius = whiteSmallview.frame.width/2
        
        whiteBigView.addSubview(blueView)
        whiteBigView.addSubview(whiteSmallview)
        
        let image = textToImage(drawText: String(size) as NSString,
                                inImage: whiteBigView.asImage(),
                                font: UIFont.systemFont(ofSize: 14))
        return image
    }

    private func textToImage(drawText text: NSString, inImage image: UIImage, font: UIFont) -> UIImage {

        UIGraphicsBeginImageContext(image.size)
        image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))

        let textStyle = NSMutableParagraphStyle()
        textStyle.alignment = NSTextAlignment.center
        let textColor = UIColor.black
        let attributes=[
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.paragraphStyle: textStyle,
            NSAttributedString.Key.foregroundColor: textColor]

        let textH = font.lineHeight
        let textY = (image.size.height-textH)/2
        let textRect = CGRect(x: 0, y: textY, width: image.size.width, height: textH)
        text.draw(in: textRect.integral, withAttributes: attributes)
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return UIImage() }
        UIGraphicsEndImageContext()
        return result
    }

}


