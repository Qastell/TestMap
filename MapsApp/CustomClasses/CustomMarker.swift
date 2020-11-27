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
    
    private var pinIsShowing = false {
        didSet {
            if pinIsShowing == true {
                infoIsShowing = false
                pointIsShowing = false
            }
        }
    }
    
    private var pointIsShowing = false {
        didSet {
            if pointIsShowing == true {
                pinIsShowing = false
                infoIsShowing = false
            }
        }
    }
    
    private var infoIsShowing = false {
        didSet {
            if infoIsShowing == true {
                pinIsShowing = false
                pointIsShowing = false
            }
        }
    }
    
    override init() {
        super.init()
        MapViewController.delegates.add(self)
    }
    
    func postVacancy(number: Int, salary: Int) {
        self.salary = salary
        self.numberOfVacancy = number
    }
    
}

extension CustomMarker: MapViewDelegate {
    func changeImageOfMarker(zoom: Float) {
        
        if zoom < 13.5, pointIsShowing == false {
            pointIsShowing = true

            let blueView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            blueView.backgroundColor = #colorLiteral(red: 0.3607843137, green: 0.6745098039, blue: 1, alpha: 1)
            blueView.layer.cornerRadius = blueView.frame.width/2
            blueView.layer.borderColor = UIColor.black.cgColor
            blueView.layer.borderWidth = 1

            iconView = blueView
        } else if zoom > 13.5, zoom <= 15, pinIsShowing == false {
            pinIsShowing = true

            if numberOfVacancy == 0 || numberOfVacancy == 1 {
                iconView = drawPin()
            } else {
                iconView = drawPinWithNumber(numberOfVacancy)
            }
        } else if zoom > 15, infoIsShowing == false {
            infoIsShowing = true

            if numberOfVacancy == 0 || numberOfVacancy == 1{
                iconView = drawTable(salary: salary)
            } else {
                iconView = drawBigTable(salary: salary, vacancy: numberOfVacancy)
            }
        }
        
    }
    
    func drawBigTable(salary: Int, vacancy: Int) -> UIView {
        let markerView = UIView(frame: CGRect(x: 0, y: 0, width: 110, height: 40))
        let imageView = UIImageView(image: R.image.bigTable())
        imageView.frame = markerView.frame
        imageView.contentMode = .scaleAspectFit
        imageView.center = markerView.center
        
        let label = UILabel()
        let textH = label.font.lineHeight
        label.text = "\(vacancy) от \(salary) тыс."
        label.textAlignment = .center
        label.frame = markerView.frame
        label.center = markerView.center
        label.frame.origin.y = label.frame.origin.y - textH/3
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 12)
        
        markerView.addSubview(imageView)
        markerView.addSubview(label)
        
        return markerView
    }
    
    func drawTable(salary: Int) -> UIView {
        let markerView = UIView(frame: CGRect(x: 0, y: 0, width: 80, height: 40))
        let imageView = UIImageView(image: R.image.table())
        imageView.frame = markerView.frame
        imageView.contentMode = .scaleAspectFit
        imageView.center = markerView.center
        
        let label = UILabel()
        let textH = label.font.lineHeight
        label.text = "\(salary) тыс."
        label.textAlignment = .center
        label.frame = markerView.frame
        label.center = markerView.center
        label.frame.origin.y = label.frame.origin.y - textH/4
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 14)
        
        markerView.addSubview(imageView)
        markerView.addSubview(label)
        
        return markerView
    }
    
    func drawPinWithNumber(_ numberOfVacancy: Int)->UIView {
        let markerView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 40))
        let imageView = UIImageView(image: R.image.pinWithNumber())
        imageView.frame = markerView.frame
        imageView.contentMode = .scaleAspectFit
        imageView.center = markerView.center
        
        let label = UILabel()
        let textH = label.font.lineHeight
        label.text = "\(numberOfVacancy)"
        label.textAlignment = .center
        label.frame = markerView.frame
        label.center = markerView.center
        label.frame.origin.y = label.frame.origin.y - textH/5
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 14)
        
        markerView.addSubview(imageView)
        markerView.addSubview(label)
        
        return markerView
    }
    
    func drawPin() -> UIView {
        let pinView = UIImageView(image: R.image.pin())
        pinView.frame = CGRect(x: 0, y: 0, width: 30, height: 40)
        pinView.contentMode = .scaleAspectFit
        return pinView
    }
}
