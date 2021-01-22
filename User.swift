//
//  User.swift
//  MedGo
//
//  Created by Vladimir Savic on 12/9/20.
//  Copyright © 2020 Vladimir Savic. All rights reserved.
//

import CoreLocation

struct User {
    let fullname: String
    let email: String
    let accountType: Int
    var location: CLLocation?
    let uid: String
    
    init(uid: String, dictionary: [String: Any]) {
        
        self.fullname = dictionary["fullname"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        self.accountType = dictionary["accountType"] as? Int ?? 0
        self.uid = uid
        
        
    }
}
