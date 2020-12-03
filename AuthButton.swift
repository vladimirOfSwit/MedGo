//
//  AuthButton.swift
//  MedGo
//
//  Created by Vladimir Savic on 8/25/20.
//  Copyright © 2020 Vladimir Savic. All rights reserved.
//

import UIKit

class AuthButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)

        setTitleColor(UIColor(white: 1, alpha: 0.5), for: .normal)
        backgroundColor = .mainBlueTint
        layer.cornerRadius = 5
        heightAnchor.constraint(equalToConstant: 50).isActive = true
    
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
