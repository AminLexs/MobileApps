

import Foundation
import UIKit

class Utilities: UIViewController {
    
    static func styleTextField(_ textfield:UITextField, colorName: String, fontName: String, fontSize: Int) {

        textfield.layer.sublayers?.forEach { if $0.name == "bottomLine"{
            $0.removeFromSuperlayer()
        }
        }
        let bottomLine = CALayer()
        bottomLine.name="bottomLine"
        bottomLine.frame = CGRect(x: 0, y: textfield.frame.height - 2, width: textfield.frame.width, height: 2)
        
        textfield.borderStyle = .none
        
        textfield.backgroundColor = .none
        
        textfield.layer.cornerRadius = 5.0
        
        let util=Utilities()
        bottomLine.backgroundColor = UIColor(named: colorName)?.resolvedColor(with: util.traitCollection).cgColor
        // Add the line to the text field
        textfield.layer.addSublayer(bottomLine)
        textfield.font=UIFont(name: fontName, size: CGFloat(fontSize))
        
    }
    
    static func styleImageView(_ imageView:UIImageView, colorName: String) {
        
        
        imageView.layer.borderWidth = 3
        
        let util=Utilities()
        imageView.layer.borderColor = UIColor(named: colorName)?.resolvedColor(with: util.traitCollection).cgColor
        
        imageView.layer.cornerRadius = 5.0
        
        
    }
    
    static func styleLabel(_ label: UILabel,colorName: String, fontName: String, fontSize: Int) {
        label.textColor=UIColor(named: colorName)
      //  label.font = label.font.withSize(CGFloat(fontSize))
        label.font=UIFont(name: fontName/*"Arial"*/, size: CGFloat(fontSize))
    }
    
    static func styleButton(_ button:UIButton,colorName: String, fontName: String, fontSize: Int) {
        let color = UIColor(named: colorName)
        button.backgroundColor = color//UIColor(named: colorName)
        button.layer.cornerRadius = 25.0
        button.tintColor = UIColor(named: "fonts")
        button.titleLabel!.font=UIFont(name: fontName/*"Arial"*/, size: CGFloat(fontSize))
    }
    

    static func isPasswordValid(_ password : String) -> Bool {
        
        let passwordTest = NSPredicate(format: "SELF MATCHES %@","^(?=.*[a-z])(?=.*[$@$;#!%*?&])[A-Za-z\\d$@$#;!%*?&]{8,}")
                                       //"/(?=.*[0-9])(?=.*[!@#$%^&*])(?=.*[a-z])(?=.*[A-Z])[0-9a-zA-Z!@#$%^&*]{6,}/g") //"^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
    
}
