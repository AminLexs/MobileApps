//
//  DetailedViewController.swift
//  CPU_Catalog
//
//  Created by Admin on 06.03.2021.
//

import UIKit
import FirebaseFirestore
import FirebaseStorage
import AVKit
import AVFoundation

class DetailedViewController: UIViewController {

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        NotificationCenter.default.addObserver(self, selector: #selector(self.themeChanged), name: UserDefaults.didChangeNotification, object: nil)
        
    }
    
    
    @IBOutlet weak var modelLabel: UILabel!
    @IBOutlet weak var manufacturerLabel: UILabel!
    @IBOutlet weak var architectureLabel: UILabel!
    @IBOutlet weak var bitsdepthLabel: UILabel!
    @IBOutlet weak var numcoresLabel: UILabel!
    @IBOutlet weak var frequencyLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!

    @IBOutlet weak var manufacturerStaticLabel: UILabel!
    @IBOutlet weak var architectureStaticLabel: UILabel!
    @IBOutlet weak var bitsdepthStaticLabel: UILabel!
    @IBOutlet weak var numcoresStaticLabel: UILabel!
    @IBOutlet weak var frequencyStaticLabel: UILabel!
    @IBOutlet weak var descriptionStaticLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var editCPUButton: UIBarButtonItem!
    @IBOutlet weak var videoView: UIImageView!
    @IBOutlet weak var showCollectionButton: UIButton!
    
    
    var data: QueryDocumentSnapshot?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setDarkMode()
        setLocalization()
        setElementsUp()
        
        activityIndicator.alpha=0
        
        if data==nil{
            print("Error on segue")
        }
        else{
            modelLabel.text=data!.data()["model"] as? String
            manufacturerLabel.text=data!.data()["manufacturer"] as? String
            architectureLabel.text=data!.data()["architecture"] as? String
            bitsdepthLabel.text=data!.data()["bitsdepth"] as? String
            numcoresLabel.text=data!.data()["numcores"] as? String
            frequencyLabel.text=data!.data()["frequency"] as? String
            descriptionTextView.text=data!.data()["description"] as? String
            let url=data!.data()["avatar"] as? String
            downloadImage(url!, image: avatarImageView)
            if (data!.data()["video"] as? String)==nil{
                videoView.isHidden=true
            } else { videoView.isHidden=false }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(videoTapped(tapGestureRecognizer:)))
        videoView.isUserInteractionEnabled = true
        videoView.addGestureRecognizer(tapGestureRecognizer)
        
        let ref = Storage.storage().reference()
        let storageReference = ref.child("images/" + data!.documentID)
        storageReference.listAll { (result, error) in
        if let error = error {
            print(error)
        }
            if result.items.count==0{
                self.showCollectionButton.isHidden=true
            }
        }
    }
    
    @objc func videoTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        if let videoURL = URL(string: data!.data()["video"] as! String){
            let player = AVPlayer(url: videoURL)

            let playerViewController = AVPlayerViewController()
            playerViewController.player = player

            self.present(playerViewController, animated: true) {
            playerViewController.player!.play()
          }
        }
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier==Constants.Storyboard.editorSegue{
                let destVC=segue.destination as! CPUEditorViewController
                destVC.data=data
        }
        if segue.identifier==Constants.Storyboard.photoSegue{
            let destVC=segue.destination as! CPUphotoViewController
            destVC.userID = data!.documentID
            destVC.forEdit = false
        }        
    }
    
    func setLocalization(){
        
        manufacturerStaticLabel.text=LocalizationSystem.sharedInstance.localizedStringForKey(key: "DetailedViewController_manufacturerStaticLabel", comment: "")
        architectureStaticLabel.text=LocalizationSystem.sharedInstance.localizedStringForKey(key: "DetailedViewController_architectureStaticLabel", comment: "")
        bitsdepthStaticLabel.text=LocalizationSystem.sharedInstance.localizedStringForKey(key: "DetailedViewController_bitsdepthStaticLabel", comment: "")
        numcoresStaticLabel.text=LocalizationSystem.sharedInstance.localizedStringForKey(key: "DetailedViewController_numcoresStaticLabel", comment: "")
        frequencyStaticLabel.text=LocalizationSystem.sharedInstance.localizedStringForKey(key: "DetailedViewController_frequencyStaticLabel", comment: "")
        descriptionStaticLabel.text=LocalizationSystem.sharedInstance.localizedStringForKey(key: "DetailedViewController_descriptionStaticLabel", comment: "")
        showCollectionButton.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "DetailedViewController_showCollectionButton", comment: ""), for: .normal)
        editCPUButton.title=LocalizationSystem.sharedInstance.localizedStringForKey(key: "DetailedViewController_editCPUButton", comment: "")
    }
    
    public func setElementsUp(){
        let color=UserDefaults.standard.string(forKey: CustomSettings.UserDefaultKeys.COLOR.rawValue)!
        let font=UserDefaults.standard.string(forKey: CustomSettings.UserDefaultKeys.STYLE.rawValue)!
        let size=UserDefaults.standard.integer(forKey: CustomSettings.UserDefaultKeys.SIZE.rawValue)
        Utilities.styleLabel(modelLabel, colorName: color, fontName: font, fontSize: size)
        Utilities.styleLabel(manufacturerLabel, colorName: color, fontName: font, fontSize: size)
        Utilities.styleLabel(architectureLabel, colorName: color, fontName: font, fontSize: size)
        Utilities.styleLabel(bitsdepthLabel, colorName: color, fontName: font, fontSize: size)
        Utilities.styleLabel(numcoresLabel, colorName: color, fontName: font, fontSize: size)
        Utilities.styleLabel(frequencyLabel, colorName: color, fontName: font, fontSize: size)
        Utilities.styleLabel(manufacturerStaticLabel, colorName: color, fontName: font, fontSize: size)
        Utilities.styleLabel(architectureStaticLabel, colorName: color, fontName: font, fontSize: size)
        Utilities.styleLabel(bitsdepthStaticLabel, colorName: color, fontName: font, fontSize: size)
        Utilities.styleLabel(numcoresStaticLabel, colorName: color, fontName: font, fontSize: size)
        Utilities.styleLabel(frequencyStaticLabel, colorName: color, fontName: font, fontSize: size)
        Utilities.styleLabel(descriptionStaticLabel, colorName: color, fontName: font, fontSize: size)
        Utilities.styleButton(showCollectionButton, colorName: color, fontName: font, fontSize: size)
        descriptionTextView.font=UIFont(name: font, size: CGFloat(size))
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
