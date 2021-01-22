//
//  DriverAnnotation .swift
//  MedGo
//
//  Created by Vladimir Savic on 1/19/21.
//  Copyright © 2021 Vladimir Savic. All rights reserved.
//

import MapKit

class NurseAnnotation: NSObject, MKAnnotation {
    
   dynamic var coordinate: CLLocationCoordinate2D
    var uid: String
    
    init(uid: String, coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
        self.uid = uid 
    }
    
    func updateAnnotationPosition(withCoordinate coordinate: CLLocationCoordinate2D) {
        UIView.animate(withDuration: 0.2) {
            self.coordinate = coordinate
        }
    }
    
}
