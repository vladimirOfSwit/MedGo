//
//  LocationCell.swift
//  MedGo
//
//  Created by Vladimir Savic on 9/22/20.
//  Copyright © 2020 Vladimir Savic. All rights reserved.
//

import UIKit

class LocationCell: UITableViewCell {
    
    //MARK: - Properties
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "Title of the address"
        return label
    }()
    
    private let addressLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "21. divizije 45, Beograd"
        label.textColor = .lightGray
        return label
    }()
    
    //MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        let stack = UIStackView(arrangedSubviews: [titleLabel, addressLabel])
        
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = 2
        
        addSubview(stack)
        stack.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 12)
        
        
   
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
}
