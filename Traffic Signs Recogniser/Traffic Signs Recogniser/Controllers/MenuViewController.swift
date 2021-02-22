//
//  ViewController.swift
//  Traffic Signs Recogniser
//
//  Created by vladikkk on 28/01/2021.
//

import UIKit

class MenuViewController: UIViewController {
    // MARK: - Properties
    lazy var cameraButton: UIButton = {
        let btn = UIButton(frame: .zero)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = .systemBlue
        btn.addTarget(self, action: #selector(self.openCamera), for: .touchUpInside)
        return btn
    }()
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = .white
        
        self.view.addSubview(self.cameraButton)
        
        self.setupLayout()
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            self.cameraButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.cameraButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            self.cameraButton.heightAnchor.constraint(equalToConstant: 100),
            self.cameraButton.widthAnchor.constraint(equalToConstant: 200),
        ])
    }
}

// MARK: - Actions
extension MenuViewController {
    @objc private func openCamera() {
        let newVC = CameraViewController()
        
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(newVC, animated: true)
        }
    }
}
