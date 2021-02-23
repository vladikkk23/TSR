//
//  MenuButtonView.swift
//  Traffic Signs Recogniser
//
//  Created by Vladislav Movileanu on 23.02.2021.
//

import UIKit

class MenuButtonView: UIView {
    // MARK: - Properties
    lazy var backgroundView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        view.backgroundColor = .init(red: 0, green: 0, blue: 1, alpha: 0.2)
        return view
    }()
    
    private var backgroundViewWithAnchor: NSLayoutConstraint!
    
    lazy var button: UIButton = {
        let btn = UIButton(frame: .zero)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = .clear
        return btn
    }()
    
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
    override func draw(_ rect: CGRect) {
        self.backgroundColor = .systemBlue
        self.layer.cornerRadius = 20
        self.clipsToBounds = true
    }
    
    private func setupView() {
        // Add subviews
        self.addSubview(self.backgroundView)
        self.addSubview(self.button)
        
        // Setup layout constraints
        self.setupLayout()
        
        // Add animations
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.onTap))
        gesture.numberOfTapsRequired = 1
        self.button.addGestureRecognizer(gesture)
    }
    
    private func setupLayout() {
        self.setupButtonLayout()
        self.setupBackgroundViewLayout()
    }
    
    private func setupButtonLayout() {
        NSLayoutConstraint.activate([
            self.button.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.button.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.button.heightAnchor.constraint(equalTo: self.heightAnchor),
            self.button.widthAnchor.constraint(equalTo: self.widthAnchor)
        ])
    }
    
    private func setupBackgroundViewLayout() {
        self.backgroundViewWithAnchor = self.backgroundView.widthAnchor.constraint(equalToConstant: 2)
        
        NSLayoutConstraint.activate([
            self.backgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.backgroundView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.backgroundView.heightAnchor.constraint(equalTo: self.heightAnchor),
            self.backgroundViewWithAnchor
        ])
    }
    
    @objc func onTap() {
        UIView.animate(withDuration: 1, delay: 0, options: [.curveEaseInOut], animations: self.animate) { (finished) in
            if finished {
                self.resetAnimatedViews()
            }
        }
    }
    
    private func animate() {
        self.backgroundView.isHidden = false
        self.backgroundView.transform = CGAffineTransform(scaleX: self.frame.width, y: 1)
    }
    
    private func resetAnimatedViews() {
        if !(self.backgroundView.frame.size.width < self.frame.size.width) {
            self.backgroundView.isHidden = true
            self.backgroundView.transform = CGAffineTransform(scaleX: 0.1, y: 1)
            self.backgroundViewWithAnchor.isActive = true
        }
    }
}
