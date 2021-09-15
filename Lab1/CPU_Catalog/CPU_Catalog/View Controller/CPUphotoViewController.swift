//
//  CPUphotoViewController.swift
//  CPU_Catalog
//
//  Created by Admin on 09.03.2021.
//

import UIKit
import FirebaseStorage

class CPUphotoViewController: UIViewController {
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        NotificationCenter.default.addObserver(self, selector: #selector(self.themeChanged), name: UserDefaults.didChangeNotification, object: nil)
        
    }
    
    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var swipeImageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    @IBOutlet weak var navItem: UINavigationItem!
    
    var swipeRight:UISwipeGestureRecognizer!
    var swipeLeft:UISwipeGestureRecognizer!
    var currentImage = 0
    var forEdit:Bool!
    var userID:String!
    var imageURL:Array<URL>=[]
    var references:Array<StorageReference>=[]
        override func viewDidLoad() {
            super.viewDidLoad()
            setDarkMode()
            if forEdit{
                deleteButton.isEnabled=true
                warningLabel.isHidden=false
                setLocalization()
            }else{
                deleteButton.isEnabled=false
                warningLabel.isHidden=true
                deleteButton.title=""
            }
            let ref = Storage.storage().reference()
            let storageReference = ref.child("images/"+userID)
            storageReference.listAll { (result, error) in
            if let error = error {
                print(error)
            }
                if result.items.count>0 {
                    self.swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture(gesture:)))
                    self.swipeRight.direction = UISwipeGestureRecognizer.Direction.right
                    self.view.addGestureRecognizer(self.swipeRight)

                    self.swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture(gesture:)))
                    self.swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
                    self.view.addGestureRecognizer(self.swipeLeft)
                
            for item in result.items {
                let storageLocation = String(describing: item)
                let gsReference = Storage.storage().reference(forURL: storageLocation)
                self.references.append(item)
                gsReference.downloadURL { url, error in
                if let error = error {
                    print(error)
                } else {
                    if item == result.items.first{
                        self.activityIndicator.alpha=1
                        self.activityIndicator.startAnimating()
                        downloadImageFromURL(url!, image: self.swipeImageView)
                        self.activityIndicator.alpha=0
                        self.activityIndicator.stopAnimating()
                    }
                    self.imageURL.append(url!)
                    }
                }
            }
        }
    }
    }
    
    @objc func themeChanged(){
        setDarkMode()
        setLocalization()
      
    }
    
    func setLocalization(){
        deleteButton.title = LocalizationSystem.sharedInstance.localizedStringForKey(key: "CPUphotoViewController_deleteButton", comment: "")
        warningLabel.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "CPUphotoViewController_warningLabel", comment: "")
    }
    
    func setDarkMode(){
        if (UserDefaults.standard.bool(forKey: CustomSettings.UserDefaultKeys.DARK.rawValue) == false){
            overrideUserInterfaceStyle = .light
        }
        else{
            overrideUserInterfaceStyle = .dark
        }
    }
    
    @IBAction func deleteTapped(_ sender: Any) {
        //        references[currentImage]
        try Storage.storage().reference(forURL: imageURL[currentImage].absoluteString).delete { [self] error in
            if let error = error {
              print(error)
            } else {
              print("Deleted")
                if imageURL.count>0{
                    if currentImage == imageURL.count - 1 {
                        imageURL.remove(at: currentImage)
                        currentImage -= 1
                    }else{imageURL.remove(at: currentImage)}
                    if imageURL.count>0{
                        downloadImageFromURL(imageURL[currentImage], image: swipeImageView)
                    }else{
                        self.view.removeGestureRecognizer(swipeRight)
                        self.view.removeGestureRecognizer(swipeLeft)
                        swipeImageView.image = UIImage(named: "avatar")
                        deleteButton.isEnabled=false
                    }
                }else{
                    self.view.removeGestureRecognizer(swipeRight)
                    self.view.removeGestureRecognizer(swipeLeft)
                    swipeImageView.image = UIImage(named: "avatar")
                    deleteButton.isEnabled=false
                }
            }
          }


    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {

            if let swipeGesture = gesture as? UISwipeGestureRecognizer {
                activityIndicator.alpha=1
                activityIndicator.startAnimating()

                switch swipeGesture.direction {
                case UISwipeGestureRecognizer.Direction.left:
                    if currentImage == imageURL.count - 1 {
                        currentImage = 0

                    }else{
                        currentImage += 1
                    }
 
                    downloadImageFromURL(imageURL[currentImage], image: swipeImageView)
                case UISwipeGestureRecognizer.Direction.right:
                    if currentImage == 0 {
                        currentImage = imageURL.count - 1
                    }else{
                        currentImage -= 1
                    }
                    downloadImageFromURL(imageURL[currentImage], image: swipeImageView)
                default:
                    break
                }
                activityIndicator.alpha=0
                activityIndicator.stopAnimating()
            }
        }
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }

}
