//
//  SettingsViewController.swift
//  CPU_Catalog
//
//  Created by Admin on 02.03.2021.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var itemBar: UITabBarItem!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var langLabel: UILabel!
    @IBOutlet weak var colorLabel: UILabel!
    @IBOutlet weak var darkModeLabel: UILabel!
    @IBOutlet weak var changeLanguageButton: UIButton!
    @IBOutlet weak var darkSwitch: UISwitch!
    @IBOutlet weak var languagePicker: UIPickerView!
    @IBOutlet weak var colorThemeButton: UIButton!
    @IBOutlet weak var colorPickerView: UIPickerView!
    
    @IBOutlet weak var fontLabel: UILabel!
    @IBOutlet weak var fontButton: UIButton!
    @IBOutlet weak var fontPickerView: UIPickerView!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var sizeSlider: UISlider!
    var languages : Array<String>?
    var languagesCodes = ["en", "ru"]
    var colors = ["Phantom Blood", "Battle Tendenct", "Stardust Crusaders", "Diamond is Unbreakable", "Golden wind", "Stone Ocean", "Steel Ball Run"]
    var fonts = ["Arial-ItalicMT","Baskerville","ChalkboardSE-Regular"]
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        setLocalization()
        setElementsUp()
        languagePicker.isHidden=true
        colorPickerView.isHidden=true
        fontPickerView.isHidden=true
        sizeSlider.value = Float(UserDefaults.standard.integer(forKey: CustomSettings.UserDefaultKeys.SIZE.rawValue))
        if UserDefaults.standard.bool(forKey: CustomSettings.UserDefaultKeys.DARK.rawValue) == false{
            darkSwitch.setOn(false, animated: true)
            overrideUserInterfaceStyle = .light
        }
        else{
            darkSwitch.setOn(true, animated: true)
            overrideUserInterfaceStyle = .dark
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        languagePicker.delegate=self
        languagePicker.dataSource=self
        colorPickerView.delegate=self
        colorPickerView.dataSource=self
        fontPickerView.delegate=self
        fontPickerView.dataSource=self
    }
    @IBAction func ChangeMode(_ sender: Any) {

        let key = CustomSettings.UserDefaultKeys.DARK.rawValue
        if (UserDefaults.standard.bool(forKey: key) == false){
            UserDefaults.standard.set(true, forKey: key)
            overrideUserInterfaceStyle = .dark
          }
          else{
            UserDefaults.standard.set(false, forKey: key)
            overrideUserInterfaceStyle = .light
          }
    }
   
    @IBAction func changeLangTapped(_ sender: Any) {
        languagePicker.isHidden=false
    }
    @IBAction func changeColorTapped(_ sender: Any) {
        colorPickerView.isHidden=false
    }
    
    @IBAction func changeFontTapped(_ sender: Any) {
        fontPickerView.isHidden=false
    }
    @IBAction func sliderChanged(_ sender: UISlider) {
        UserDefaults.standard.set(sender.value, forKey: CustomSettings.UserDefaultKeys.SIZE.rawValue)
        viewDidLoad()
        viewWillAppear(true)
    }
    
    func setLocalization(){
        languages = [LocalizationSystem.sharedInstance.localizedStringForKey(key: "SettingsViewController_English", comment: ""), LocalizationSystem.sharedInstance.localizedStringForKey(key: "SettingsViewController_Russian", comment: "")]
        titleLabel.text=LocalizationSystem.sharedInstance.localizedStringForKey(key: "SettingsViewController_titleLabel", comment: "")
        langLabel.text=LocalizationSystem.sharedInstance.localizedStringForKey(key: "SettingsViewController_langLabel", comment: "")
        colorLabel.text=LocalizationSystem.sharedInstance.localizedStringForKey(key: "SettingsViewController_colorLabel", comment: "")
        darkModeLabel.text=LocalizationSystem.sharedInstance.localizedStringForKey(key: "SettingsViewController_darkModeLabel", comment: "")
        sizeLabel.text=LocalizationSystem.sharedInstance.localizedStringForKey(key: "SettingsViewController_sizeLabel", comment: "")
        colorThemeButton.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "SettingsViewController_colorThemeButton", comment: ""), for: .normal)
        fontButton.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "SettingsViewController_fontButton", comment: ""), for: .normal)
        fontLabel.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "SettingsViewController_fontLabel", comment: "")
        //itemBar.title = LocalizationSystem.sharedInstance.localizedStringForKey(key: "SettingsViewController_itemBar", comment: "")
        if LocalizationSystem.sharedInstance.getLanguage() == "en" {
            changeLanguageButton.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "SettingsViewController_English", comment: ""), for: .normal)
        } else {
            changeLanguageButton.setTitle(LocalizationSystem.sharedInstance.localizedStringForKey(key: "SettingsViewController_Russian", comment: ""), for: .normal)
        }
        
    }
    
    func setElementsUp(){
        let color=UserDefaults.standard.string(forKey: CustomSettings.UserDefaultKeys.COLOR.rawValue)!
        let font=UserDefaults.standard.string(forKey: CustomSettings.UserDefaultKeys.STYLE.rawValue)!
        let size=UserDefaults.standard.integer(forKey: CustomSettings.UserDefaultKeys.SIZE.rawValue)
        Utilities.styleLabel(titleLabel, colorName: color, fontName: font, fontSize: size)
        Utilities.styleLabel(darkModeLabel, colorName: color, fontName: font, fontSize: size)
        Utilities.styleLabel(langLabel, colorName: color, fontName: font, fontSize: size)
        Utilities.styleLabel(colorLabel, colorName: color, fontName: font, fontSize: size)
        Utilities.styleLabel(sizeLabel, colorName: color, fontName: font, fontSize: size)
        Utilities.styleButton(changeLanguageButton, colorName: color, fontName: font, fontSize: size)
        Utilities.styleButton(colorThemeButton, colorName: color, fontName: font, fontSize: size)
        Utilities.styleButton(fontButton, colorName: color, fontName: font, fontSize: size)
    }
    
}

extension SettingsViewController: UIPickerViewDelegate, UIPickerViewDataSource{
   func numberOfComponents(in pickerView: UIPickerView) -> Int{
            return 1
    }

   func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
    if pickerView==languagePicker{
        return languages!.count
    }else if pickerView==colorPickerView{
        return colors.count
    }else{
        return fonts.count
    }
   }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            self.view.endEditing(true)
        if pickerView==languagePicker{
            return languages![row]
        }else if pickerView==colorPickerView{
            return colors[row]
        } else{
            return fonts[row]
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView==languagePicker{
            LocalizationSystem.sharedInstance.setLanguage(languageCode: languagesCodes[row])
            self.languagePicker.isHidden = true
        }else if pickerView==colorPickerView{
            UserDefaults.standard.set(colors[row], forKey: CustomSettings.UserDefaultKeys.COLOR.rawValue)
            self.colorPickerView.isHidden = true
        }else{
            UserDefaults.standard.set(fonts[row], forKey: CustomSettings.UserDefaultKeys.STYLE.rawValue)
            self.fontPickerView.isHidden = true
        }
 
        viewDidLoad()
        viewWillAppear(true)
    }
}
