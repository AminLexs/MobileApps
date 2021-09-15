//
//  SignUpViewController.swift
//  CPU_Catalog
//
//  Created by Admin on 02.03.2021.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore

class SignUpViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var manufacturerTextField: UITextField!
    @IBOutlet weak var modelTextField: UITextField!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var bitDepthPickView: UIPickerView!
    @IBOutlet weak var architectureTextField: UITextField!
    @IBOutlet weak var numcoresTextField: UITextField!
    @IBOutlet weak var frequencyTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var bitsdepthLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var signUpButton: UIButton!
    
    let bitdepth = ["x32","x64"]
    var imagePicker = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
        setDarkMode()
        setElementsUp()
        setLocalization()
        bitDepthPickView.dataSource = self
        bitDepthPickView.delegate = self
        activityIndicator.alpha=0
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
            avatarImageView.isUserInteractionEnabled = true
            avatarImageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
                    imagePicker.delegate = self
                    imagePicker.sourceType = .savedPhotosAlbum
                    imagePicker.allowsEditing = false

                    present(imagePicker, animated: true, completion: nil)

                }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.dismiss(animated: true, completion: { () -> Void in
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                self.avatarImageView.image =  image.scaleImage(toSize:CGSize(width: 100, height: 100))
                }
            })
    }
    @IBAction func signUpTapped(_ sender: Any) {
        
        activityIndicator.alpha=1
        activityIndicator.startAnimating()
        
        
        let error = validateFields()
        
        if error != nil {
            activityIndicator.alpha=0
            activityIndicator.stopAnimating()
            showError(error!, errorLabel: errorLabel)
        }
        else {
            let manufacturer = manufacturerTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let model = modelTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let architecture = architectureTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let numcores = numcoresTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let frequency = frequencyTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let bitsdepth = bitdepth[bitDepthPickView.selectedRow(inComponent:0)]
            self.transitionToHome()
               Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                
                if err != nil {
                    
                    showError(LocalizationSystem.sharedInstance.localizedStringForKey(key: "SignUpViewController_authError", comment: ""), errorLabel: self.errorLabel)
                    self.activityIndicator.alpha=0
                    self.activityIndicator.stopAnimating()
                }
                else {
                    
                    uploadFhoto(self.avatarImageView,path: "images/"){ [self](completion) in
                        if completion==nil{
                            
                            showError(LocalizationSystem.sharedInstance.localizedStringForKey(key: "SignUpViewController_authError", comment: ""), errorLabel: self.errorLabel)
                            self.activityIndicator.alpha=0
                            self.activityIndicator.stopAnimating()
                        }
                        else{
                            
                            let url=completion?.absoluteString
                            let db = Firestore.firestore()
                    		
                            db.collection("users").addDocument(data: ["manufacturer":manufacturer, "model":model, "bitsdepth":bitsdepth, "architecture":architecture, "numcores":numcores, "frequency":frequency, "email": email, "avatar": url!, "uid": result!.user.uid ]) { [self] (error) in
                        
                                if error != nil {
                                    
                                    showError(LocalizationSystem.sharedInstance.localizedStringForKey(key: "SignUpViewController_dataError", comment: ""), errorLabel: self.errorLabel)
                                    self.activityIndicator.alpha=0
                                    self.activityIndicator.stopAnimating()
                                }
                            }
                            self.transitionToHome()
                        }
                    }
                
            }
        }
    }
}
    
    func validateFields()->String?{
        if manufacturerTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)=="" ||
            modelTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)=="" ||
            numcoresTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)=="" ||
            frequencyTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)=="" ||
            architectureTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)=="" ||
        emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)=="" ||
        passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)==""
        {
            return LocalizationSystem.sharedInstance.localizedStringForKey(key: "SignUpViewController_notFullError", comment: "")
                //NSLocalizedString( "SignUpViewController_notFullError", comment: "")
        }
        
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if Utilities.isPasswordValid(cleanedPassword)==false{
            return LocalizationSystem.sharedInstance.localizedStringForKey(key: "SignUpViewController_sickPasswordError", comment: "")
                //NSLocalizedString( "SignUpViewController_sickPasswordError", comment: "")
        }
        return nil
    }
    
    func transitionToHome() {
        
        activityIndicator.alpha=0
        activityIndicator.stopAnimating()
        
        let loginViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.loginViewController) as? LoginViewController
        
        view.window?.rootViewController = loginViewController
        view.window?.makeKeyAndVisible()
        
    }
    
    func setLocalization(){
        emailTextField.placeholder=LocalizationSystem.sharedInstance.localizedStringForKey(key: "LoginViewController_emailTextField", comment: "")
        passwordTextField.placeholder=LocalizationSystem.sharedInstance.localizedStringForKey(key: "LoginViewController_passwordTextField", comment: "")
        manufacturerTextField.placeholder=LocalizationSystem.sharedInstance.localizedStringForKey(key: "SignUpViewController_manufacturerTextField", comment: "")
        modelTextField.placeholder=LocalizationSystem.sharedInstance.localizedStringForKey(key: "SignUpViewController_modelTextField", comment: "")
        bitsdepthLabel.text=LocalizationSystem.sharedInstance.localizedStringForKey(key: "SignUpViewController_bitsdepthLabel", comment: "")
        architectureTextField.placeholder=LocalizationSystem.sharedInstance.localizedStringForKey(key: "SignUpViewController_architectureTextField", comment: "")
        numcoresTextField.placeholder=LocalizationSystem.sharedInstance.localizedStringForKey(key: "SignUpViewController_numcoresTextField", comment: "")
        frequencyTextField.placeholder=LocalizationSystem.sharedInstance.localizedStringForKey(key: "SignUpViewController_frequencyTextField", comment: "")
        signUpButton.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "LoginViewController_signUpButton", comment: ""), for: .normal)
    }
    
    func setElementsUp(){
        errorLabel.alpha=0
        let color=UserDefaults.standard.string(forKey: CustomSettings.UserDefaultKeys.COLOR.rawValue)!
        let font=UserDefaults.standard.string(forKey: CustomSettings.UserDefaultKeys.STYLE.rawValue)!
        let size=UserDefaults.standard.integer(forKey: CustomSettings.UserDefaultKeys.SIZE.rawValue)
        Utilities.styleTextField(emailTextField, colorName: color, fontName: font, fontSize: size)
        Utilities.styleTextField(passwordTextField, colorName: color, fontName: font, fontSize: size)
        Utilities.styleTextField(manufacturerTextField, colorName: color, fontName: font, fontSize: size)
        Utilities.styleTextField(modelTextField, colorName: color, fontName: font, fontSize: size)
        Utilities.styleTextField(architectureTextField, colorName: color, fontName: font, fontSize: size)
        Utilities.styleTextField(numcoresTextField, colorName: color, fontName: font, fontSize: size)
        Utilities.styleTextField(frequencyTextField, colorName: color, fontName: font, fontSize: size)
        Utilities.styleButton(signUpButton, colorName: color, fontName: font, fontSize: size)
        Utilities.styleImageView(avatarImageView, colorName: color)
        Utilities.styleLabel(bitsdepthLabel, colorName: color, fontName: font, fontSize: size)
    }
    
    func setDarkMode(){
        if (UserDefaults.standard.bool(forKey: CustomSettings.UserDefaultKeys.DARK.rawValue) == false){
            overrideUserInterfaceStyle = .light
        }
        else{
            overrideUserInterfaceStyle = .dark
        }
    }
    
}

extension UIImage {
    func scaleImage(toSize newSize: CGSize) -> UIImage? {
        var newImage: UIImage?
        let newRect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height).integral
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
        if let context = UIGraphicsGetCurrentContext(), let cgImage = self.cgImage {
            context.interpolationQuality = .high
            let flipVertical = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: newSize.height)
            context.concatenate(flipVertical)
            context.draw(cgImage, in: newRect)
            if let img = context.makeImage() {
                newImage = UIImage(cgImage: img)
            }
            UIGraphicsEndImageContext()
        }
        return newImage
    }
}

extension SignUpViewController: UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView)-> Int {
        return 1
    }
    
    func pickerView(_ pickerView:UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return bitdepth.count
    }
}

extension SignUpViewController: UIPickerViewDelegate{
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return bitdepth[row]
    }
}
