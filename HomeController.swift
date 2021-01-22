//
//  HomeController.swift
//  MedGo
//
//  Created by Vladimir Savic on 8/27/20.
//  Copyright © 2020 Vladimir Savic. All rights reserved.
//

import UIKit
import Firebase
import MapKit

private let reuseIdentifier = "LocationCell"
private let annotationIdentifier = "DriverAnnotation"

class HomeController:UIViewController {
    
    //MARK: - Properties
    
    private let mapView = MKMapView()
    private let locationManager = LocationHandler.shared.locationManager
    private let inputActivationView = LocationInputActivationView()
    private let locationInputView = LocationInputView()
    private let tableView = UITableView()
    
    private var user: User? {
        didSet {locationInputView.user = user}
    }
    
    private final let locationInputViewHeight: CGFloat = 200
    
    private let signOutButton: AuthButton = {
        let button = AuthButton(type: .system)
        button.setTitle("Izloguj me", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
        button.addTarget(self, action: #selector(handleSignOut), for: .touchUpInside)
        return button
    }()
    
    
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        checkIfUserIsLoggedIn()
        fetchUserData()
        fetchDrivers()
        
        
    }
    
    //MARK: - API
    
    func fetchDrivers() {
        
        guard let location = locationManager?.location else { return }
        Service.shared.fetchDrivers(location: location) { (driver) in
            
            guard let coordinate = driver.location?.coordinate else { return }
            
            let annotation = DriverAnnotation(uid: driver.uid, coordinate: coordinate)
            
            var driverIsVisible: Bool {
                
                self.mapView.annotations.contains { annotation -> Bool in
                    
                    guard let driverAnno = annotation as? DriverAnnotation else { return false }
                    
                    if driverAnno.uid == driver.uid {
                        driverAnno.updateAnnotationPosition(withCoordinate: coordinate)
                        return true
                    }
                
                    return false
                }
                
                
            }
            
            if !driverIsVisible {
                
                self.mapView.addAnnotation(annotation)
            }
            
        }
        
    }
    
    func fetchUserData() {
        
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        Service.shared.fetchUserData(uid: currentUid) { user in
            self.user = user
        }
    }
    
    func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser?.uid == nil {
            DispatchQueue.main.async {
                let nav = UINavigationController(rootViewController: LoginViewController())
                self.present(nav, animated: true, completion: nil)
            }
            
        } else {
            print("DEBUG: User is logged in...")
            configure()
            
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            DispatchQueue.main.async {
                let nav = UINavigationController(rootViewController: LoginViewController())
                self.present(nav, animated: true, completion: nil)
            }
            print("User has been signed out.")
        } catch {
            print("DEBUG: Unable to sign out the user. Error: \(error)")
        }
    }
    
    //MARK: - Helper functions
    
    func configure() {
        
        configureUI()
        enableLocationServices()
        fetchUserData()
        fetchDrivers()
        
    }
    
    
    
    func configureUI() {
        configureMapView()
        
        view.addSubview(inputActivationView)
        inputActivationView.centerX(inView: view)
        inputActivationView.setDimensions(height: 50, width: view.frame.width - 64)
        inputActivationView.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 32)
        inputActivationView.alpha = 0
        
        
        UIView.animate(withDuration: 2) {
            self.inputActivationView.alpha = 1
        }
        
        configureTableView()
        
        
        
        //        view.addSubview(signOutButton)
        //        signOutButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.safeAreaLayoutGuide.rightAnchor,paddingBottom: 15, paddingRight: 15)
        
        inputActivationView.delegate = self
        
        
        
    }
    
    func configureMapView() {
        view.addSubview(mapView)
        mapView.frame = view.frame
        
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        mapView.delegate = self
    }
    
    func configureLocationInputView() {
        
        locationInputView.delegate = self
        
        view.addSubview(locationInputView)
        locationInputView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, height: locationInputViewHeight)
        locationInputView.alpha = 0
        
        UIView.animate(withDuration: 0.5) {
            self.locationInputView.alpha = 1
        } completion: { (_) in
            UIView.animate(withDuration: 0.3) {
                self.tableView.frame.origin.y = self.locationInputViewHeight
            }
        }
        
        
    }
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(LocationCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 60
        let height = view.frame.height - locationInputViewHeight
        tableView.frame = CGRect(x: 0, y: view.frame.height, width: view.frame.width, height: height)
        tableView.tableFooterView = UIView()
        
        view.addSubview(tableView)
        
    }
    
    //MARK: - Selectors
    
    @objc func handleSignOut() {
        
        do {
            try Auth.auth().signOut()
            print("User has been signed out.")
        } catch {
            print("DEBUG: Unable to sign out the user. Error: \(error)")
        }
        
        DispatchQueue.main.async {
            let nav = UINavigationController(rootViewController: LoginViewController())
            self.present(nav, animated: true, completion: nil)
        }
    }
    
}



//MARK: - Map Helper Functions

private extension HomeController {
    
}


//MARK: - MKMapViewDelegate


extension HomeController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if let annotation = annotation as? DriverAnnotation {
            let view = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            view.image = #imageLiteral(resourceName: "chevron-sign-to-right")
            return view
        }
        
        return nil
        
    }
}

//MARK: - LocationServices

extension HomeController {
    
    func enableLocationServices() {
        
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            print("DEBUG: Not determined")
            locationManager?.requestWhenInUseAuthorization()
        case .restricted, .denied:
            break
        case .authorizedAlways:
            print("DEBUG: Authorized always")
            locationManager?.startUpdatingLocation()
            locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        case .authorizedWhenInUse:
            print("DEBUG: Authorized when in use")
            locationManager?.requestAlwaysAuthorization()
        @unknown default:
            break
        }
        
        
    }
    
    
}

//MARK: - LocationInputActivationViewDelegate

extension HomeController: LocationInputActivationViewDelegate  {
    
    
    func presentLocationInputView() {
        inputActivationView.alpha = 0
        configureLocationInputView()
    }
    
    
    //MARK: - LocationInputViewDelegate
    
}

extension HomeController: LocationInputViewDelegate {
    
    func executeSearch(query: String) {
        print("DEBUG: The query is \(query)")
    }
    
    
    func dismissLocationInputView() {
        
        UIView.animate(withDuration: 0.4) {
            self.locationInputView.alpha = 0
            self.tableView.frame.origin.y = self.view.frame.height
        } completion: { _ in
            self.locationInputView.removeFromSuperview()
            UIView.animate(withDuration: 0.2) {
                self.inputActivationView.alpha = 1
            }
        }
        
    }
    
    
    
}

//MARK: - TableViewDelegate and TableViewSource

extension HomeController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Test"
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return section == 0 ? 2 : 5
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! LocationCell
        
        return cell
    }
    
    
}


