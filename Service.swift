//
//  Service.swift
//  MedGo
//
//  Created by Vladimir Savic on 9/24/20.
//  Copyright © 2020 Vladimir Savic. All rights reserved.
//

import Firebase

let DB_REF = Database.database().reference()
let DB_USERS = DB_REF.child("users")


struct Service {
    
    static let shared = Service()
    let currentUid = Auth.auth().currentUser?.uid
    
    func fetchUserData() {
        
        print("DEBUG: The current uid is: \(currentUid!)")
        
        DB_USERS.child(currentUid!).observeSingleEvent(of: .value) { (snapshot) in
            
            guard let dictionary = snapshot.value as? [String : Any] else { return }
            
            guard let fullname = dictionary["fullname"] as? String else { return }
            print("DEBUG: This is the full name: \(fullname)")
            
        }

    }
    
}
