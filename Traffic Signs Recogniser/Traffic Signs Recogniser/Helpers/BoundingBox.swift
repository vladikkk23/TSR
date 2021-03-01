//
//  BoundingBox.swift
//  Traffic Signs Recogniser
//
//  Created by vladikkk on 28/01/2021.
//

import UIKit

class BoundingBox {
    let shapeLayer: CAShapeLayer
    let textLayer: CATextLayer
    
    init() {
        shapeLayer = CAShapeLayer()
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 10
        shapeLayer.isHidden = true
        
        textLayer = CATextLayer()
        textLayer.isHidden = true
        textLayer.alignmentMode = CATextLayerAlignmentMode.left
    }
    
    func addToLayer(_ parent: CALayer) {        
        parent.addSublayer(shapeLayer)
        shapeLayer.addSublayer(textLayer)
    }
    
    func show(frame: CGRect, label: String, color: CGColor) {
        CATransaction.begin()
        CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
        
        let path = UIBezierPath(rect: frame)
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = color
        shapeLayer.isHidden = false
        shapeLayer.lineCap = .round
        
        let attributedString = NSAttributedString(string: "  \(label)", attributes: [NSAttributedString.Key.font: UIFont(name: "Times New Roman Bold", size: 40)!, NSAttributedString.Key.foregroundColor: UIColor.white.cgColor, NSAttributedString.Key.strokeColor: UIColor.black])
        
        textLayer.string = attributedString
        textLayer.backgroundColor = color
        textLayer.isHidden = false
        textLayer.contentsScale = UIScreen.main.scale
        textLayer.contentsGravity = .left
        
        let textRect = CGRect(x: 0, y: 0, width: 100, height: 50)
        
        let textSize = CGSize(width: frame.width + 10, height: textRect.height)
        let textOrigin = CGPoint(x: frame.origin.x - 5, y: frame.origin.y)
        
        textLayer.frame = CGRect(origin: textOrigin, size: textSize)
        
        CATransaction.commit()
    }
    
    func hide() {
        shapeLayer.isHidden = true
        textLayer.isHidden = true
    }
}

