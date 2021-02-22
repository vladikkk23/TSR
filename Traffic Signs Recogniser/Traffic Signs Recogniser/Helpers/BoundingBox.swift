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
        shapeLayer.lineWidth = 20
        shapeLayer.isHidden = true
        
        textLayer = CATextLayer()
        textLayer.isHidden = true
        textLayer.alignmentMode = CATextLayerAlignmentMode.left
    }
    
    func addToLayer(_ parent: CALayer) {
        parent.sublayers = nil
        
        parent.addSublayer(shapeLayer)
        shapeLayer.addSublayer(textLayer)
    }
    
    func show(frame: CGRect, label: String, color: CGColor) {
        CATransaction.setDisableActions(true)
        
        
        let path = UIBezierPath(rect: frame)
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = color
        shapeLayer.isHidden = false
        shapeLayer.cornerRadius = 20
        
        textLayer.string = "   \(label)   "
        textLayer.cornerRadius = 10
        textLayer.backgroundColor = color
        textLayer.isHidden = false
        textLayer.masksToBounds = true
        textLayer.contentsScale = UIScreen.main.scale
        textLayer.contentsGravity = .resizeAspect
        
        let attributes = [
            NSAttributedString.Key.font: UIFont(name: "Times New Roman Bold", size: 40)!,
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.strokeColor: UIColor.black
        ]
        
        let textRect = label.boundingRect(with: CGSize(width: 800, height: 200), options: [.truncatesLastVisibleLine], attributes: attributes, context: nil)
        
        let textSize = CGSize(width: frame.width + 20, height: textRect.height)
        let textOrigin = CGPoint(x: frame.origin.x - 10, y: frame.origin.y - textSize.height)
        
        textLayer.frame = CGRect(origin: textOrigin, size: textSize)
    }
    
    func hide() {
        shapeLayer.isHidden = true
        textLayer.isHidden = true
    }
}

