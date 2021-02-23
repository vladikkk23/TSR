//
//  MenuView.swift
//  Traffic Signs Recogniser
//
//  Created by Vladislav Movileanu on 23.02.2021.
//

import UIKit

class MenuView: UIView {
    // MARK: - Properties
    lazy var cameraButton: MenuButtonView = {
        let btn = MenuButtonView(frame: .zero)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.button.addTarget(self, action: #selector(self.openCamera), for: .touchUpInside)
        btn.button.setAttributedTitle(NSAttributedString(string: "Open Camera", attributes: [.font : UIFont(name: "Times New Roman Bold", size: 23)!, .foregroundColor : UIColor.white]), for: .normal)
        btn.isUserInteractionEnabled = true
        return btn
    }()
    
    lazy var settingsButton: MenuButtonView = {
        let btn = MenuButtonView(frame: .zero)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.button.addTarget(self, action: #selector(self.openSettings), for: .touchUpInside)
        btn.button.setAttributedTitle(NSAttributedString(string: "Settings", attributes: [.font : UIFont(name: "Times New Roman Bold", size: 23)!, .foregroundColor : UIColor.white]), for: .normal)
        btn.isUserInteractionEnabled = true
        return btn
    }()
    
    lazy var aboutButton: MenuButtonView = {
        let btn = MenuButtonView(frame: .zero)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.button.addTarget(self, action: #selector(self.openAbout), for: .touchUpInside)
        btn.button.setAttributedTitle(NSAttributedString(string: "About", attributes: [.font : UIFont(name: "Times New Roman Bold", size: 23)!, .foregroundColor : UIColor.white]), for: .normal)
        btn.isUserInteractionEnabled = true
        return btn
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
        // Add subviews
        self.addSubview(self.cameraButton)
        self.addSubview(self.settingsButton)
        self.addSubview(self.aboutButton)
        
        // Setup layout constraints
        self.setupLayout()
    }
    
    private func setupLayout() {
        self.setupCameraButtonLayout()
        self.setupSettingsButtonLayout()
        self.setupAboutButtonLayout()
    }
    
    private func setupCameraButtonLayout() {
        NSLayoutConstraint.activate([
            self.cameraButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.cameraButton.topAnchor.constraint(equalTo: self.topAnchor),
            self.cameraButton.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.25),
            self.cameraButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.7)
        ])
    }
    
    private func setupSettingsButtonLayout() {
        NSLayoutConstraint.activate([
            self.settingsButton.centerXAnchor.constraint(equalTo: self.cameraButton.centerXAnchor),
            self.settingsButton.topAnchor.constraint(equalTo: self.cameraButton.bottomAnchor, constant: 30),
            self.settingsButton.heightAnchor.constraint(equalTo: self.cameraButton.heightAnchor),
            self.settingsButton.widthAnchor.constraint(equalTo: self.cameraButton.widthAnchor)
        ])
    }
    
    private func setupAboutButtonLayout() {
        NSLayoutConstraint.activate([
            self.aboutButton.centerXAnchor.constraint(equalTo: self.settingsButton.centerXAnchor),
            self.aboutButton.topAnchor.constraint(equalTo: self.settingsButton.bottomAnchor, constant: 30),
            self.aboutButton.heightAnchor.constraint(equalTo: self.settingsButton.heightAnchor),
            self.aboutButton.widthAnchor.constraint(equalTo: self.settingsButton.widthAnchor)
        ])
    }
}

// MARK: - Actions
extension MenuView {
    @objc private func openCamera() {
        guard let baseVC = self.findViewController() as? MenuViewController else { return }
        
        let newVC = CameraViewController()
        newVC.title = "Camera"
        
        DispatchQueue.main.async {
            baseVC.navigationController?.pushViewController(newVC, animated: true)
        }
    }
    
    @objc private func openSettings() {
        guard let baseVC = self.findViewController() as? MenuViewController else { return }
        
        let newVC = UIViewController()
        newVC.title = "Settings"
        newVC.view.backgroundColor = .darkGray
        
        DispatchQueue.main.async {
            baseVC.navigationController?.pushViewController(newVC, animated: true)
        }
    }
    
    @objc private func openAbout() {
        guard let baseVC = self.findViewController() as? MenuViewController else { return }
        
        let newVC = UIViewController()
        newVC.title = "About"
        newVC.view.backgroundColor = .darkGray
        
        DispatchQueue.main.async {
            baseVC.navigationController?.pushViewController(newVC, animated: true)
        }
    }
}
