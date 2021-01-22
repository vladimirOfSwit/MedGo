//
//  LoginController.swift
//  MedGo
//
//  Created by Vladimir Savic on 8/18/20.
//  Copyright © 2020 Vladimir Savic. All rights reserved.
//



import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    //MARK: - Properties
    
    
    private let titleLabel: UILabel = {
        return UIView().createTitleLabel(withName: "MedGo")
    }()
    
    private lazy var emailContainerView: UIView = {
        let view = UIView().containerView(image: #imageLiteral(resourceName: "ic_mail_outline_white_2x"), withTextField: emailTextField)
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return view
    }()
    
    private lazy var passwordContainerView: UIView = {
        let view = UIView().containerView(image: #imageLiteral(resourceName: "ic_lock_outline_white_2x"), withTextField: passwordTextField)
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return view
    }()
    
    
    
    private let emailTextField: UITextField = {
        return UITextField().textField(withPlaceholder: "Email",
                                       isSecureTextEntry: false)
    }()
    
    private let passwordTextField: UITextField = {
        return UITextField().textField(withPlaceholder: "Password",
                                       isSecureTextEntry: true)
    }()
    
    private let loginButton: AuthButton = {
        
        let button = AuthButton(type: .system)
        button.setTitle("Log in", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(handleLogIn), for: .touchUpInside)
        return button
        
    }()
    
    let dontHaveAccountButton: UIButton = {
        
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Don't have an account?  ", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        
        attributedTitle.append(NSAttributedString(string: "Register", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.mainBlueTint]))
        
        button.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        
        return button
    }()
    
    
    
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        
    }
    
    
    
    //MARK: - Selectors
    
    @objc func handleLogIn() {
        
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                print("DEBUG: Failed to sign in the user because of the following error: \(error.localizedDescription)")
              return
            }
            
            let keyWindow = UIApplication.shared.connectedScenes

                    .filter({$0.activationState == .foregroundActive})

                    .map({$0 as? UIWindowScene})

                    .compactMap({$0})

                    .first?.windows

                    .filter({$0.isKeyWindow}).first
            
            
            guard let controller = keyWindow?.rootViewController as? HomeController else { return }
            
            controller.configure()
            self.dismiss(animated: true, completion: nil)
            
        }
        
    }
    
    
    @objc func handleShowSignUp() {
        
        
        let controller = SignUpController()
        navigationController?.pushViewController(controller, animated: true)
        
    }
    
    //MARK: - Helper functions
    
    func configureUI() {
        
        configureNavigationBar()
        
        view.backgroundColor = .backgroundColor
        
        view.addSubview(titleLabel)
        titleLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor)
        titleLabel.centerX(inView: view)
        
        view.addSubview(emailContainerView)
        emailContainerView.anchor(top: titleLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 40, paddingLeft: 16, paddingRight: 16, height: 50)
        
        view.addSubview(passwordContainerView)
        passwordContainerView.anchor(top: emailContainerView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 16, paddingLeft: 16, paddingRight: 16, height: 50)
        
        let stack = UIStackView(arrangedSubviews: [emailContainerView,
                                                   passwordContainerView,
                                                   loginButton])
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = 24
        
        view.addSubview(stack)
        stack.anchor(top: titleLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 40, paddingLeft: 16, paddingRight: 16)
        
        view.addSubview(dontHaveAccountButton)
        dontHaveAccountButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, height: 32)
        dontHaveAccountButton.centerX(inView: view)
        
    }
    
    func configureNavigationBar() {
        
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
        
    }
    
    
}
