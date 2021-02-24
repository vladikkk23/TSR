//
//  SettingsButtonView.swift
//  Traffic Signs Recogniser
//
//  Created by Vladislav Movileanu on 23.02.2021.
//

import UIKit

class SettingsButtonView: UIView {
    // MARK: - Properties
    lazy var button: UIButton = {
        let btn = UIButton(frame: .zero)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = .clear
        btn.addTarget(self, action: #selector(self.onTap), for: .touchUpInside)
        return btn
    }()
    
    lazy var titleLabel: UILabel = {
        let lbl = UILabel(frame: .zero)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.adjustsFontSizeToFitWidth = true
        lbl.textAlignment = .left
        lbl.backgroundColor = .clear
        return lbl
    }()
    
    lazy var statusSwitch: UISwitch = {
        let btn = UISwitch(frame: .zero)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.tintColor = .lightGray
        btn.onTintColor = .systemBlue
        return btn
    }()
    
    var title: String!
    var status: Bool!
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.draw(frame)
        
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.setupView()
    }
    
    // MARK: - Methods
    private func setupView() {
        self.addSubview(self.titleLabel)
        self.addSubview(self.statusSwitch)
        self.addSubview(self.button)
        
        self.setupLayout()
    }
    
    private func setupLayout() {
        self.setupButtonLayout()
        self.setupTitleLabelLayout()
        self.setupStatusSwitchLayout()
    }
    
    private func setupButtonLayout() {
        NSLayoutConstraint.activate([
            self.button.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.button.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.button.heightAnchor.constraint(equalTo: self.heightAnchor),
            self.button.widthAnchor.constraint(equalTo: self.widthAnchor)
        ])
    }
    
    private func setupTitleLabelLayout() {
        NSLayoutConstraint.activate([
            self.titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            self.titleLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.8),
            self.titleLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.8)
        ])
    }
    
    private func setupStatusSwitchLayout() {
        NSLayoutConstraint.activate([
            self.statusSwitch.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.statusSwitch.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            self.statusSwitch.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.8),
            self.statusSwitch.widthAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.8)
        ])
    }
}

// MARK: - Actions
extension SettingsButtonView {
    @objc func onTap() {
        self.status = self.statusSwitch.isOn
        self.status.toggle()
        self.statusSwitch.isOn = self.status
        
        UserDefaults.standard.setValue(status, forKey: self.title)
    }
}
