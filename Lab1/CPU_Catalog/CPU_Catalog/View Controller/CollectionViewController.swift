
import UIKit
import Firebase
class CollectionViewController: UIViewController {

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        NotificationCenter.default.addObserver(self, selector: #selector(self.themeChanged), name: UserDefaults.didChangeNotification, object: nil)
        
    }
    var data=Array<QueryDocumentSnapshot>()

    @IBOutlet weak var logoutButton: UIBarButtonItem!
    @IBOutlet weak var moreDetailsButton: UIBarButtonItem!
    @IBOutlet weak var itemBar: UITabBarItem!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setDarkMode()
        setLocalization()
       // setUpElements()
        activityIndicator.alpha=1
        activityIndicator.startAnimating()
        collectionView.backgroundColor = UIColor.clear.withAlphaComponent(0)
         
        loadCPUs(){(completion) in
            if completion==nil{
                print("Error loading characters")
            }
            else{
                self.data=completion!
                self.collectionView.register(CPUCollectionViewCell.nib, forCellWithReuseIdentifier:CPUCollectionViewCell.reuseID)
                self.collectionView.reloadData()
                dataService.shared.data = self.data
                self.collectionView.selectItem(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: UICollectionView.ScrollPosition.top)
                self.activityIndicator.stopAnimating()
                self.activityIndicator.alpha=0
            }
                
        }
        collectionView.delegate = self
        collectionView.dataSource = self
 
    }
    
 /*   override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        setLocalization()

    }*/
    
    
    @IBAction func logOut(_ sender: Any) {
        do{
          try Auth.auth().signOut()
            let logIn = (storyboard?.instantiateViewController(identifier: Constants.Storyboard.navigationViewController) as? UINavigationController)!
            view.window?.rootViewController = logIn
            view.window?.makeKeyAndVisible()
        }catch{
            print(error)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier==Constants.Storyboard.detailedSegue{
            if let indexPath=collectionView.indexPathsForSelectedItems{
                let destVC=segue.destination as! DetailedViewController
                if indexPath.count==1
                {
                    destVC.data=data[indexPath[0].row]
                }else{
                    destVC.data=data[0]
                }
               
            }
        }
        if segue.identifier==Constants.Storyboard.mapSegue{
                let destVC=segue.destination as! MapsViewController
                destVC.data=data
        }
    }
    
    
    @objc func themeChanged(){
        setDarkMode()
        setLocalization()
       // setUpElements()
        let cells = self.collectionView.visibleCells as! Array<CPUCollectionViewCell>
            for cell in cells {
                cell.setLocalization()
                cell.setUpElements()
            }
        self.collectionView.reloadData()
        dataService.shared.data = self.data
    }
    
   /* public func setUpElements(){
        let color=UserDefaults.standard.string(forKey: CustomSettings.UserDefaultKeys.COLOR.rawValue)!
        let font=UserDefaults.standard.string(forKey: CustomSettings.UserDefaultKeys.STYLE.rawValue)!
        let size=UserDefaults.standard.integer(forKey: CustomSettings.UserDefaultKeys.SIZE.rawValue)
       // Utilities.styleButton(logoutButton, colorName: color, fontName: font, fontSize: size)
        //Utilities.styleButton(moreDetailsButton, colorName: color, fontName: font, fontSize: size)
    }*/
    
    func setLocalization(){
        logoutButton.title=LocalizationSystem.sharedInstance.localizedStringForKey(key: "TableViewController_logoutBar", comment: "")
        moreDetailsButton.title=LocalizationSystem.sharedInstance.localizedStringForKey(key: "TableViewController_moreDetailsButton", comment: "")
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


extension CollectionViewController: UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.layer.borderWidth = 3.0
        cell?.layer.borderColor = UIColor.gray.cgColor
        print("Выбрана ячейка: (\(indexPath.section), \(indexPath.item))")
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.layer.borderWidth = 0.0
    }
    func collectionView(_ collectionView: UICollectionView, canEditItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow: CGFloat = 3
        let minimumItemSpacing: CGFloat = 4
        var availableWidth = collectionView.bounds.width - minimumItemSpacing * (itemsPerRow - 1)
        var widthPerItem = availableWidth / itemsPerRow
        if widthPerItem < 100{
            availableWidth = collectionView.bounds.width - minimumItemSpacing
            widthPerItem = availableWidth / 2
        }
        if widthPerItem>200{
            availableWidth = collectionView.bounds.width - minimumItemSpacing * itemsPerRow
            widthPerItem = availableWidth / 4
        }
        let size=UserDefaults.standard.integer(forKey: CustomSettings.UserDefaultKeys.SIZE.rawValue)
        var heightPerItem = 10 * 6 + 5 * 2 + (12 * size + 5) + 9 * 4
        heightPerItem +=  Int(widthPerItem) * 4 / 5 / 2
        return CGSize(width: widthPerItem, height:CGFloat(heightPerItem))
    }
    
  /*  func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        let sectionInsets = UIEdgeInsets(top: 16.0, left: 16.0, bottom: 20.0, right: 16.0)
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }*/
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        let minimumItemSpacing: CGFloat = 4
        return minimumItemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell=collectionView.dequeueReusableCell(withReuseIdentifier: Constants.Storyboard.cellIdentifier, for: indexPath) as! CPUCollectionViewCell
        cell.setLocalization()
        cell.setUpElements()
        cell.modelLabel?.text=data[indexPath.row].data()["model"] as? String
        cell.manufacturerLabel?.text=data[indexPath.row].data()["manufacturer"] as? String
        cell.bitsdepthLabel?.text=data[indexPath.row].data()["bitsdepth"] as? String
        cell.numcoresLabel?.text=data[indexPath.row].data()["numcores"] as? String
        let url=data[indexPath.row].data()["avatar"] as? String
        downloadImage(url!, image: cell.avatarImageView)
        return cell
    }

    
    
}

class CPUCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var modelLabel: UILabel!
    @IBOutlet weak var manufacturerLabel: UILabel!
    @IBOutlet weak var bitsdepthLabel: UILabel!
    @IBOutlet weak var numcoresLabel: UILabel!
   
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var bitsdepthStaticLabel: UILabel!
    @IBOutlet weak var numcoresStaticLabel: UILabel!
    
    static let reuseID = String(describing: CPUCollectionViewCell.self)
       static let nib = UINib(nibName: String(describing: CPUCollectionViewCell.self), bundle: nil)
    
    public func setLocalization(){
        bitsdepthStaticLabel.text=LocalizationSystem.sharedInstance.localizedStringForKey(key: "DetailedViewController_bitsdepthStaticLabel", comment: "")
        numcoresStaticLabel.text=LocalizationSystem.sharedInstance.localizedStringForKey(key: "DetailedViewController_numcoresStaticLabel", comment: "")
        
    }
    
    public func setUpElements(){
        let color=UserDefaults.standard.string(forKey: CustomSettings.UserDefaultKeys.COLOR.rawValue)!
        let font=UserDefaults.standard.string(forKey: CustomSettings.UserDefaultKeys.STYLE.rawValue)!
        let size=UserDefaults.standard.integer(forKey: CustomSettings.UserDefaultKeys.SIZE.rawValue)
        Utilities.styleLabel(modelLabel, colorName: color, fontName: font, fontSize: size+5)
        Utilities.styleLabel(manufacturerLabel, colorName: color, fontName: font, fontSize: size)
        Utilities.styleLabel(bitsdepthLabel, colorName: color, fontName: font, fontSize: size)
        Utilities.styleLabel(numcoresLabel, colorName: color, fontName: font, fontSize: size)
        Utilities.styleLabel(bitsdepthStaticLabel, colorName: color, fontName: font, fontSize: size)
        Utilities.styleLabel(numcoresStaticLabel, colorName: color, fontName: font, fontSize: size)
        
    }
    
}


