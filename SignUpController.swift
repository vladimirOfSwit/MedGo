//
//  SignUpController.swift
//  MedGo
//
//  Created by Vladimir Savic on 8/24/20.
//  Copyright © 2020 Vladimir Savic. All rights reserved.
//

import UIKit
import Firebase

class SignUpController: UIViewController {
    
    //MARK: - Properties
    
    private let titleLabel: UILabel = {
        return UIView().createTitleLabel(withName: "MedGo")
    }()
    
    private lazy var emailContainerView: UIView = {
        let view = UIView().containerView(image: #imageLiteral(resourceName: "ic_mail_outline_white_2x"), withTextField: emailTextField)
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return view
    }()
    
    private lazy var fullNameContainerView: UIView = {
        let view = UIView().containerView(image: #imageLiteral(resourceName: "ic_person_outline_white_2x"), withTextField: fullNameTextField)
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return view
    }()
    
    private lazy var passwordContainerView: UIView = {
        let view = UIView().containerView(image: #imageLiteral(resourceName: "ic_lock_outline_white_2x"), withTextField: passwordTextField)
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return view
    }()
    
    private lazy var accountContainerView: UIView = {
        let view = UIView().containerView(image: #imageLiteral(resourceName: "ic_account_box_white_2x"), segmentedControl: accountTypeSegmentedControl)
        view.heightAnchor.constraint(equalToConstant: 80).isActive = true
        return view
    }()
    
    
    
    private let emailTextField: UITextField = {
        return UITextField().textField(withPlaceholder: "Email",
                                       isSecureTextEntry: false)
    }()
    
    private let fullNameTextField: UITextField = {
        return UITextField().textField(withPlaceholder: "Ime i prezime",
                                       isSecureTextEntry: false)
    }()
    
    private let passwordTextField: UITextField = {
        return UITextField().textField(withPlaceholder: "Lozinka",
                                       isSecureTextEntry: true)
    }()
    
    private let accountTypeSegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["MedGo radnik", "Korisnik"])
        sc.backgroundColor = .backgroundColor
        sc.tintColor = UIColor(white: 1, alpha: 0.87)
        sc.selectedSegmentIndex = 0
        return sc
    }()
    
    private let signUpButton: AuthButton = {
        
        let button = AuthButton(type: .system)
        button.setTitle("Registruj se", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        return button
        
    }()
    
    let alreadyHaveAccountButton: UIButton = {
        
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Već imaš nalog?  ", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        
        attributedTitle.append(NSAttributedString(string: "Uloguj se", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.mainBlueTint]))
        
        button.addTarget(self, action: #selector(handleShowLogIn), for: .touchUpInside)
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        
        return button
    }()
    
    
    
    
    
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    //MARK: - Selectors
    
    @objc func handleSignUp() {
        
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        guard let fullname = fullNameTextField.text else { return }
        let accountTypeIndex = accountTypeSegmentedControl.selectedSegmentIndex
        
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            
            if let error = error {
                print("DEBUG: Failed to register the user because of the following error: \(error)")
                return
            }
            
            guard let uid = result?.user.uid else { return }
            
            let values = ["email" : email,
                          "fullname" : fullname,
                          "accountType" : accountTypeIndex] as [String : Any]
            
            Database.database().reference().child("users").child(uid).updateChildValues(values) { (error, ref) in
                
                
                let keyWindow = UIApplication.shared.connectedScenes

                        .filter({$0.activationState == .foregroundActive})

                        .map({$0 as? UIWindowScene})

                        .compactMap({$0})

                        .first?.windows

                        .filter({$0.isKeyWindow}).first
                
                
                guard let controller = keyWindow?.rootViewController as? HomeController else { return }
                
                controller.configureUI()
                self.dismiss(animated: true, completion: nil)
                
            }
            
        }
        
    }

    @objc func handleShowLogIn() {
        
        navigationController?.popViewController(animated: true)
    }
    

    //MARK: - Helper functions
    
    func configureUI() {
        
        view.backgroundColor = .backgroundColor
        
        view.addSubview(titleLabel)
        titleLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor)
        titleLabel.centerX(inView: view)
        
        view.addSubview(emailContainerView)
        emailContainerView.anchor(top: titleLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 40, paddingLeft: 16, paddingRight: 16, height: 50)
        
        view.addSubview(passwordContainerView)
        passwordContainerView.anchor(top: emailContainerView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 16, paddingLeft: 16, paddingRight: 16, height: 50)
        
        view.addSubview(fullNameContainerView)
        fullNameContainerView.anchor(top: passwordContainerView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 16, paddingLeft: 16, paddingRight: 16, height: 50)
        
        let stack = UIStackView(arrangedSubviews: [emailContainerView,
                                                   fullNameContainerView,
                                                   passwordContainerView,
                                                   accountContainerView,
                                                   signUpButton,
                                                   alreadyHaveAccountButton])
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.spacing = 24
        
        view.addSubview(stack)
        stack.anchor(top: titleLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 40, paddingLeft: 16, paddingRight: 16)
        
        view.addSubview(alreadyHaveAccountButton)
        alreadyHaveAccountButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, height: 32)
        alreadyHaveAccountButton.centerX(inView: view)
        
        
    }
    
    
}
