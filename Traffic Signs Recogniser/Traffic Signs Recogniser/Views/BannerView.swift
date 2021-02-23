//
//  BannerView.swift
//  Traffic Signs Recogniser
//
//  Created by Vladislav Movileanu on 23.02.2021.
//

import UIKit

class BannerView: UIView {
    // MARK: - Properties
    lazy var leftImage: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 15
        imageView.layer.masksToBounds = true
        imageView.image = UIImage(named: "90km")
        return imageView
    }()
    
    lazy var rightImage: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 15
        imageView.layer.masksToBounds = true
        imageView.image = UIImage(named: "50km")
        return imageView
    }()
    
    lazy var centerImage: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 15
        imageView.layer.masksToBounds = true
        imageView.image = UIImage(named: "cross")
        return imageView
    }()
    
    lazy var topImage: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 15
        imageView.layer.masksToBounds = true
        imageView.image = UIImage(named: "30km")
        return imageView
    }()
    
    lazy var lowerImage: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 15
        imageView.layer.masksToBounds = true
        imageView.image = UIImage(named: "70km")
        return imageView
    }()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.setupView()
    }
    
    // MARK: - Methods
    private func setupView() {
        self.addAnimation()

        self.addSubview(self.leftImage)
        self.addSubview(self.rightImage)
        self.addSubview(self.topImage)
        self.addSubview(self.lowerImage)
        
        self.addSubview(self.centerImage)
        
        self.setupLayout()
    }
    
    private func setupLayout() {
        self.setupLeftImageLayout()
        self.setupRightImageLayout()
        self.setupCenterImageLayout()
        self.setupTopImageLayout()
        self.setupLowerImageLayout()
    }
    
    private func setupLeftImageLayout() {
        NSLayoutConstraint.activate([
            self.leftImage.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.leftImage.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.leftImage.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.25),
            self.leftImage.widthAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.25)
        ])
    }
    
    private func setupRightImageLayout() {
        NSLayoutConstraint.activate([
            self.rightImage.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.rightImage.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.rightImage.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.25),
            self.rightImage.widthAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.25)
        ])
    }
    
    private func setupCenterImageLayout() {
        NSLayoutConstraint.activate([
            self.centerImage.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.centerImage.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.centerImage.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.25),
            self.centerImage.widthAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.25)
        ])
    }
    
    private func setupTopImageLayout() {
        NSLayoutConstraint.activate([
            self.topImage.topAnchor.constraint(equalTo: self.topAnchor),
            self.topImage.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.topImage.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.25),
            self.topImage.widthAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.25)
        ])
    }
    
    private func setupLowerImageLayout() {
        NSLayoutConstraint.activate([
            self.lowerImage.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.lowerImage.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.lowerImage.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.25),
            self.lowerImage.widthAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.25)
        ])
    }
    
//    override func draw(_ rect: CGRect) {
//        let bannerGradientLayer = CAGradientLayer()
//        bannerGradientLayer.frame = self.bounds
//        bannerGradientLayer.colors = [UIColor.white.cgColor, UIColor.gray.cgColor, UIColor.darkGray.cgColor]
//        self.layer.addSublayer(bannerGradientLayer)
//    }
    
    private func addAnimation() {
        let orbit = CAKeyframeAnimation(keyPath: "position")
        
        var affineTransform = CGAffineTransform(rotationAngle: 0.0)
        affineTransform = affineTransform.rotated(by: CGFloat(Double.pi))
        
        var circlePath = UIBezierPath(arcCenter: self.center, radius:  CGFloat(0.1), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
        orbit.path = circlePath.cgPath
        orbit.duration = 4
        orbit.isAdditive = true
        orbit.repeatCount = 999
        orbit.calculationMode = CAAnimationCalculationMode.paced
        orbit.rotationMode = CAAnimationRotationMode.rotateAuto
        
        self.layer.add(orbit, forKey: "orbit")
        
        circlePath = UIBezierPath(arcCenter: self.center, radius:  CGFloat(0.1), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: false)
        orbit.path = circlePath.cgPath
        
        self.leftImage.layer.add(orbit, forKey: "orbit")
        self.rightImage.layer.add(orbit, forKey: "orbit")
        self.centerImage.layer.add(orbit, forKey: "orbit")
        self.topImage.layer.add(orbit, forKey: "orbit")
        self.lowerImage.layer.add(orbit, forKey: "orbit")
    }
}

// MARK: - Make circle
@IBDesignable
extension BannerView {
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = self.bounds.size.width / 2
        self.layer.masksToBounds = false
    }
}
