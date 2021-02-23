//
//  ViewController.swift
//  Traffic Signs Recogniser
//
//  Created by vladikkk on 28/01/2021.
//

import UIKit

class MenuViewController: UIViewController {
    // MARK: - Properties
    lazy var titleLabel: UILabel = {
        let lbl = UILabel(frame: .zero)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.attributedText = NSAttributedString(string: "TSR - Traffic Signs Recogniser", attributes: [.font : UIFont(name: "Times New Roman Bold", size: 30)!, .foregroundColor : UIColor.systemBlue])
        lbl.textAlignment = .center
        lbl.adjustsFontSizeToFitWidth = true
        return lbl
    }()
    
    private lazy var bannerView: BannerView = {
        let view = BannerView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var menuView: MenuView = {
        let view = MenuView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Add gradient background
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.frame
        gradientLayer.colors = [UIColor.white.cgColor, UIColor.gray.cgColor, UIColor.darkGray.cgColor, UIColor.systemBlue.cgColor]
        view.layer.addSublayer(gradientLayer)
        
        // Add subviews
        self.view.addSubview(self.titleLabel)
        self.view.addSubview(self.bannerView)
        self.view.addSubview(self.menuView)
        
        // Setup layout constraints
        self.setupLayout()
    }
    
    private func setupLayout() {
        self.setupTitleLabelLayout()
        self.setupBannerViewLayout()
        self.setupMenuViewLayout()
    }
    
    private func setupTitleLabelLayout() {
        NSLayoutConstraint.activate([
            self.titleLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.titleLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.titleLabel.heightAnchor.constraint(equalToConstant: 50),
            self.titleLabel.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.9)
        ])
    }
    
    private func setupBannerViewLayout() {
        NSLayoutConstraint.activate([
            self.bannerView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.bannerView.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 25),
            self.bannerView.heightAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.75),
            self.bannerView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.75)
        ])
    }
    
    private func setupMenuViewLayout() {
        NSLayoutConstraint.activate([
            self.menuView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 200),
            self.menuView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.menuView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.3),
            self.menuView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.8)
        ])
    }
}
