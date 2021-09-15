//
//  LoginViewController.swift
//  CPU_Catalog
//
//  Created by Admin on 03.03.2021.
//

import UIKit
import FirebaseAuth
import FirebaseStorage

class LoginViewController: UIViewController {

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        NotificationCenter.default.addObserver(self, selector: #selector(self.themeChanged), name: UserDefaults.didChangeNotification, object: nil)
        
    }
    @IBOutlet weak var settingsBarButton: UIBarButtonItem!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        setDarkMode()
        setLocalization()
        setElementsUp()
    }
    @IBAction func loginTapped(_ sender: Any) {
       // self.transitionToCollection()
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Signing in the user
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            
            if error != nil {
                showError(LocalizationSystem.sharedInstance.localizedStringForKey(key: "LoginViewController_loginError", comment: ""), errorLabel: self.errorLabel)
         //NSLocalizedString("LoginViewController_loginError", comment: ""), errorLabel: self.errorLabel)
            }
            else {
                self.transitionToCollection()
            }
        }
    }
    
    func transitionToCollection() {
        let tabBarControl = (storyboard?.instantiateViewController(identifier: Constants.Storyboard.tabBarController) as? UITabBarController)!
        view.window?.rootViewController = tabBarControl
        view.window?.makeKeyAndVisible()
    }
    
    func setElementsUp(){
        errorLabel.alpha=0
        let color=UserDefaults.standard.string(forKey: CustomSettings.UserDefaultKeys.COLOR.rawValue)!
        let font=UserDefaults.standard.string(forKey: CustomSettings.UserDefaultKeys.STYLE.rawValue)!
        let size=UserDefaults.standard.integer(forKey: CustomSettings.UserDefaultKeys.SIZE.rawValue)
        Utilities.styleButton(loginButton, colorName: color, fontName: font, fontSize: size)
        Utilities.styleButton(signUpButton, colorName: color, fontName: font, fontSize: size)
        Utilities.styleTextField(emailTextField, colorName: color, fontName: font, fontSize: size)
        Utilities.styleTextField(passwordTextField, colorName: color, fontName: font, fontSize: size)
        errorLabel.font = UIFont(name: font, size: CGFloat(size))
    }
    
    
    func setLocalization(){
        loginButton.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "LoginViewController_loginButton", comment: ""), for: .normal)
        signUpButton.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "LoginViewController_signUpButton", comment: ""), for: .normal)
        emailTextField.placeholder = LocalizationSystem.sharedInstance.localizedStringForKey(key: "LoginViewController_emailTextField", comment: "")
        passwordTextField.placeholder=LocalizationSystem.sharedInstance.localizedStringForKey(key: "LoginViewController_passwordTextField", comment: "")
        
    }
    
    func setDarkMode(){
        if (UserDefaults.standard.bool(forKey: CustomSettings.UserDefaultKeys.DARK.rawValue) == false){
            overrideUserInterfaceStyle = .light
        }
        else{
            overrideUserInterfaceStyle = .dark
        }
    }
    
    @objc func themeChanged(){
        setDarkMode()
        setLocalization()
        setElementsUp()
        
    }
    
}
