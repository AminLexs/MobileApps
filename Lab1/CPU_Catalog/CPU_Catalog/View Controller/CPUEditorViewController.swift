//
//  CPUEditorViewController.swift
//  CPU_Catalog
//
//  Created by Admin on 07.03.2021.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseStorage

class CPUEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        NotificationCenter.default.addObserver(self, selector: #selector(self.themeChanged), name: UserDefaults.didChangeNotification, object: nil)
        
    }
    var photosNew: Array<UIImage> = []
   // var photosSaved: Array<UIImage> = []
    
    var photoAdded: Bool!
  //  var savedPhotosChanged: Bool!
    var collectionChanged: Bool!
    var imagePicker = UIImagePickerController()
    var imagePicker2 = UIImagePickerController()
    @IBOutlet weak var modelTextField: UITextField!
    @IBOutlet weak var manufacturerTextField: UITextField!
    @IBOutlet weak var bitsdepthTextField: UITextField!
    @IBOutlet weak var architectureTextField: UITextField!
    @IBOutlet weak var numcoresTextField: UITextField!
    @IBOutlet weak var frequencyTextField: UITextField!
    @IBOutlet weak var urlVideoTextField: UITextField!
    @IBOutlet weak var xTextField: UITextField!
    @IBOutlet weak var yTextField: UITextField!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var addToCollectionButton: UIButton!
    @IBOutlet weak var deleteFromCollectionButton: UIButton!
    
    
    var data: QueryDocumentSnapshot?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setDarkMode()
        setElementsUp()
        setLocalization()
        activityIndicator.alpha=0
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
            avatarImageView.isUserInteractionEnabled = true
            avatarImageView.addGestureRecognizer(tapGestureRecognizer)
        let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(addcollectionTapped(tapGestureRecognizer:)))
        addToCollectionButton.addGestureRecognizer(tapGestureRecognizer2)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        photoAdded=false
        collectionChanged=false
        
        if data==nil{
            print("Error on segue")
        }
        else{
            modelTextField.text=data!.data()["model"] as? String
            manufacturerTextField.text=data!.data()["manufacturer"] as? String
            bitsdepthTextField.text=data!.data()["bitsdepth"] as? String
            architectureTextField.text=data!.data()["architecture"] as? String
            numcoresTextField.text=data!.data()["numcores"] as? String
            frequencyTextField.text=data!.data()["frequency"] as? String
            descriptionTextView.text=data!.data()["description"] as? String
            urlVideoTextField.text=data!.data()["video"] as? String
            let x=data!.data()["latitude"] as? Double
            if x==nil{
                xTextField.text=""
            }else{
                xTextField.text=String(format: "%.4f", x!)
            }
            let y=data!.data()["longitude"] as? Double
            if y==nil{
                yTextField.text=""
            }else{
                yTextField.text=String(format: "%.4f", y!)
            }
            let url=data!.data()["avatar"] as? String
            downloadImage(url!, image: avatarImageView)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier==Constants.Storyboard.photoSegue{
            let destVC=segue.destination as! CPUphotoViewController
            destVC.userID = data!.documentID
            destVC.forEdit = true
        }
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
    
    @objc func addcollectionTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
                    imagePicker2.delegate = self
                    imagePicker2.sourceType = .savedPhotosAlbum
                    imagePicker2.allowsEditing = false
                    present(imagePicker2, animated: true, completion: nil)
                }
    }
    
    @IBAction func postTabbed(_ sender: Any) {
        
        activityIndicator.alpha=1
        activityIndicator.startAnimating()
        
        let error=validateFields()
        if error==nil{
            let model = modelTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let manufacturer = manufacturerTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let bitsdepth = bitsdepthTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let architecture = architectureTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let numcores = numcoresTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let frequency = frequencyTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let desc = descriptionTextView.text!
            let x = Double(xTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines))
            let y = Double(yTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines))
            
           /* if isEditing==false{
                addCharacter(name, stand: stand, age: age, season: season, desc: desc, x: x!, y: y!, images: Array<String?>(), videos: Array<String?>())
            }
            else{*/
                let avatar=data!.data()["avatar"] as! String
                let images=data!.data()["images"] as! String?
                let video=data!.data()["video"] as! String?
            editCPU(model, manufacturer: manufacturer, bitsdepth: bitsdepth, architecture: architecture, numcores:numcores,frequency: frequency, desc: desc, x: x!, y: y!, avatar: avatar, images: images, video: video, documentID: data!.documentID)
          //  }
        }
        else{
            activityIndicator.alpha=0
            activityIndicator.stopAnimating()
            showError(error!, errorLabel: errorLabel)
        }
        
    }
    
    func editCPU(_ model: String,manufacturer: String,bitsdepth: String, architecture: String,numcores: String, frequency: String, desc: String, x: Double, y: Double,avatar: String, images: String?, video: String?,documentID: String){
        if collectionChanged{
            for photo in photosNew{
                uploadUIImage(photo, path: "images/"+documentID+"/")
            }
        }
        if photoAdded{
            uploadFhoto(avatarImageView, path: "images/"){(completion) in
                if completion==nil{
                    showError(LocalizationSystem.sharedInstance.localizedStringForKey(key: "SignUpViewController_avatarError", comment: ""), errorLabel: self.errorLabel)
                    self.activityIndicator.alpha=0
                    self.activityIndicator.stopAnimating()
                }
                else{
                    deleteDocument(avatar)
                    let new_avatar=completion?.absoluteString
                    self.updateCPU(model, manufacturer: manufacturer, bitsdepth: bitsdepth, architecture: architecture, numcores: numcores, frequency: frequency, desc: desc, avatar: new_avatar!, x: x, y: y, documentID: documentID)
                }
                    
            }
        }
        else{
            self.updateCPU(model, manufacturer: manufacturer, bitsdepth: bitsdepth, architecture: architecture, numcores: numcores, frequency: frequency, desc: desc, avatar: avatar, x: x, y: y, documentID: documentID)
        }
       
    }
    
    func updateCPU(_ model: String,manufacturer: String,bitsdepth: String, architecture: String,numcores: String, frequency: String, desc: String, avatar: String, x: Double, y: Double, documentID: String){
        
        let db = Firestore.firestore()
        
        let washingtonRef = db.collection("users").document(documentID)
         let urlvideo = urlVideoTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)

        washingtonRef.updateData([
            "model":model,"manufacturer":manufacturer, "bitsdepth": bitsdepth, "architecture":architecture, "numcores": numcores, "frequency":frequency, "avatar": avatar, "description": desc, "latitude":x,"longitude":y, "video":urlvideo
        ]) { [self] (error) in
            if error != nil {

                showError(LocalizationSystem.sharedInstance.localizedStringForKey(key: "CharacterEditViewController_dataError", comment: ""), errorLabel: errorLabel)
                self.activityIndicator.alpha=0
                activityIndicator.stopAnimating()
            }
            else{
                self.transitionToTable()
            }
        }
    }
    
    func transitionToTable() {
        let tabBarControl = (storyboard?.instantiateViewController(identifier: Constants.Storyboard.tabBarController) as? UITabBarController)!
        view.window?.rootViewController = tabBarControl
        view.window?.makeKeyAndVisible()
        
    }
    
    
    func validateFields()->String?{
        if modelTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)=="" || manufacturerTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)=="" ||
            bitsdepthTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)=="" ||
            architectureTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)=="" ||
            numcoresTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)=="" ||
            frequencyTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)=="" ||
            xTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)=="" ||
            yTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)==""
            {
                return LocalizationSystem.sharedInstance.localizedStringForKey(key: "SignUpViewController_notFullError", comment: "")
            }
        
        let x = Double((xTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines))!)
        let y = Double((yTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines))!)
        if  (x == nil || x! < 0 || x! > 89.3) ||  (y == nil || y! < 0 || y! > 89.3){
            return
                LocalizationSystem.sharedInstance.localizedStringForKey(key: "CharacterEditViewController_coordsNotDouble", comment: "")
        }
            return nil
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.dismiss(animated: true, completion: { () -> Void in
            if self.imagePicker==picker {
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                    self.avatarImageView.image = image
                    self.photoAdded=true
                }
            }else {
                if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                    self.photosNew.append(image)
                    self.collectionChanged=true
                    }
            }
            })
    }
    
    func setDarkMode(){
        if (UserDefaults.standard.bool(forKey: CustomSettings.UserDefaultKeys.DARK.rawValue) == false){
            overrideUserInterfaceStyle = .light
        }
        else{
            overrideUserInterfaceStyle = .dark
        }
    }
    
    func setLocalization(){
        modelTextField.placeholder=LocalizationSystem.sharedInstance.localizedStringForKey(key: "CPUEditorViewController_modelTextField", comment: "")
        manufacturerTextField.placeholder=LocalizationSystem.sharedInstance.localizedStringForKey(key: "CPUEditorViewController_manufacturerTextField", comment: "")
        bitsdepthTextField.placeholder=LocalizationSystem.sharedInstance.localizedStringForKey(key: "CPUEditorViewController_bitsdepthTextField", comment: "")
        architectureTextField.placeholder=LocalizationSystem.sharedInstance.localizedStringForKey(key: "CPUEditorViewController_architectureTextField", comment: "")
        numcoresTextField.placeholder=LocalizationSystem.sharedInstance.localizedStringForKey(key: "CPUEditorViewController_numcoresTextField", comment: "")
        frequencyTextField.placeholder=LocalizationSystem.sharedInstance.localizedStringForKey(key: "CPUEditorViewController_frequencyTextField", comment: "")
        xTextField.placeholder=LocalizationSystem.sharedInstance.localizedStringForKey(key: "CPUEditorViewController_xTextField", comment: "")
        yTextField.placeholder=LocalizationSystem.sharedInstance.localizedStringForKey(key: "CPUEditorViewController_yTextField", comment: "")
        saveButton.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "CPUEditorViewController_saveButton", comment: ""), for: .normal)
        addToCollectionButton.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "CPUEditorViewController_addToCollectionButton", comment: ""), for: .normal)
        deleteFromCollectionButton.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "CPUEditorViewController_deleteFromCollectionButton", comment: ""), for: .normal)
        urlVideoTextField.placeholder=LocalizationSystem.sharedInstance.localizedStringForKey(key: "CPUEditorViewController_urlVideoTextField", comment: "")
    }
    
    func setElementsUp(){
        errorLabel.alpha=0
        
        let color=UserDefaults.standard.string(forKey: CustomSettings.UserDefaultKeys.COLOR.rawValue)!
        let font=UserDefaults.standard.string(forKey: CustomSettings.UserDefaultKeys.STYLE.rawValue)!
        let size=UserDefaults.standard.integer(forKey: CustomSettings.UserDefaultKeys.SIZE.rawValue)
        
        Utilities.styleTextField(modelTextField, colorName: color, fontName: font, fontSize: size)
        Utilities.styleTextField(manufacturerTextField, colorName: color, fontName: font, fontSize: size)
        Utilities.styleTextField(bitsdepthTextField, colorName: color, fontName: font, fontSize: size)
        Utilities.styleTextField(architectureTextField, colorName: color, fontName: font, fontSize: size)
        Utilities.styleTextField(numcoresTextField, colorName: color, fontName: font, fontSize: size)
        Utilities.styleTextField(frequencyTextField, colorName: color, fontName: font, fontSize: size)
        Utilities.styleTextField(xTextField, colorName: color, fontName: font, fontSize: size)
        Utilities.styleTextField(yTextField, colorName: color, fontName: font, fontSize: size)
        Utilities.styleTextField(urlVideoTextField, colorName: color, fontName: font, fontSize: size)
        Utilities.styleButton(saveButton, colorName: color, fontName: font, fontSize: size)
        Utilities.styleButton(addToCollectionButton, colorName: color, fontName: font, fontSize: size)
        Utilities.styleButton(deleteFromCollectionButton, colorName: color, fontName: font, fontSize: size)
        descriptionTextView.font=UIFont(name: font, size: CGFloat(size))
        Utilities.styleImageView(avatarImageView, colorName: color)
    }
    
    @objc func themeChanged(){
        setDarkMode()
        setLocalization()
        setElementsUp()
        
    }
}
