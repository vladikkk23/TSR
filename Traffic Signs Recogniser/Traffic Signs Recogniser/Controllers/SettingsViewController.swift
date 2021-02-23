//
//  SettingsViewController.swift
//  Traffic Signs Recogniser
//
//  Created by Vladislav Movileanu on 23.02.2021.
//

import UIKit

class SettingsViewController: UIViewController {
    // MARK: - Properties
    private lazy var notificationsButton: SettingsButtonView = {
        let view = SettingsButtonView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.titleLabel.attributedText = NSAttributedString(string: "Receive Notifications", attributes: [.font : UIFont(name: "Times New Roman Bold", size: 20)!, .foregroundColor : UIColor.systemBlue])
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.backgroundColor = .white
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        return view
    }()
    
    private lazy var warningsButton: SettingsButtonView = {
        let view = SettingsButtonView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.titleLabel.attributedText = NSAttributedString(string: "Play Sound When Sign Spotted", attributes: [.font : UIFont(name: "Times New Roman Bold", size: 20)!, .foregroundColor : UIColor.systemBlue])
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.backgroundColor = .white
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        return view
    }()
    
    private lazy var restoreDefaultsButton: SettingsButtonView = {
        let view = SettingsButtonView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.titleLabel.attributedText = NSAttributedString(string: "Restore Default Settings", attributes: [.font : UIFont(name: "Times New Roman Bold", size: 20)!, .foregroundColor : UIColor.systemBlue])
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.backgroundColor = .white
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
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
        self.view.addSubview(self.notificationsButton)
        self.view.addSubview(self.warningsButton)
        self.view.addSubview(self.restoreDefaultsButton)
        
        // Setup layout constraints
        self.setupLayout()
    }
    
    private func setupLayout() {
        self.setupNotificationsButtonLayout()
        self.setupWarningsButtonLayout()
        self.setupRestoreDefaultsButtonLayout()
    }
    
    private func setupNotificationsButtonLayout() {
        NSLayoutConstraint.activate([
            self.notificationsButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.notificationsButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 50),
            self.notificationsButton.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.05),
            self.notificationsButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.95)
        ])
    }
    
    private func setupWarningsButtonLayout() {
        NSLayoutConstraint.activate([
            self.warningsButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.warningsButton.topAnchor.constraint(equalTo: self.notificationsButton.bottomAnchor, constant: 50),
            self.warningsButton.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.05),
            self.warningsButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.95)
        ])
    }
    
    private func setupRestoreDefaultsButtonLayout() {
        NSLayoutConstraint.activate([
            self.restoreDefaultsButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.restoreDefaultsButton.topAnchor.constraint(equalTo: self.warningsButton.bottomAnchor, constant: 50),
            self.restoreDefaultsButton.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.05),
            self.restoreDefaultsButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.95)
        ])
    }
}
