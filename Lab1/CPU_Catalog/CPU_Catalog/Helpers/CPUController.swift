

import Foundation
import UIKit
import Firebase
import FirebaseUI
import FirebaseStorage

class dataService{
    static let shared = dataService()
    var data : Array<QueryDocumentSnapshot>?
}

func loadCPUs(completion: @escaping (Array<QueryDocumentSnapshot>?) -> Void){

    let db = Firestore.firestore()
    db.collection("users").getDocuments() { (querySnapshot, err) in
        if let err = err {
            print("Error getting documents: \(err)")
            completion(nil)
        } else {
            completion(querySnapshot!.documents)
        }
    }
}

func deleteCPU(data: QueryDocumentSnapshot){
    let db = Firestore.firestore()
    db.collection("users").document(data.documentID).delete() { err in
        if let err = err {
            print("Error removing document: \(err)")
        } else {
            print("Document successfully removed!")
        }
    }
    deleteDocument(data.data()["avatar"] as! String)
    
}

func downloadImage(_ ref: String, image: UIImageView){
    let reference = Storage.storage().reference(forURL: ref)
    let placeholderImage = UIImage(named: "placeholder.jpg")
    /*reference.getData(maxSize: 10 * 1024 * 1024, completion: { retrievedData, error in
        if error != nil {
            print(error?.localizedDescription)
            return
        }
        let img = UIImage(data: retrievedData!)!
        let size = image.frame.size
        image.image = img.scaleImage(toSize:size )

    })*/
    
    image.sd_setImage(with: reference, placeholderImage: placeholderImage)
   // img.scaleImage(toSize:CGSize(width: 100, height: 100))
}


func downloadImageFromURL(_ ref: URL, image: UIImageView){
    //let reference = Storage.storage().reference(forURL: ref)
    let placeholderImage = UIImage(named: "placeholder.jpg")
    /*reference.getData(maxSize: 10 * 1024 * 1024, completion: { retrievedData, error in
        if error != nil {
            print(error?.localizedDescription)
            return
        }
        let img = UIImage(data: retrievedData!)!
        let size = image.frame.size
        image.image = img.scaleImage(toSize:size )

    })*/
    
    image.sd_setImage(with: ref, placeholderImage: placeholderImage)
   // img.scaleImage(toSize:CGSize(width: 100, height: 100))
}


func downloadUIImage(_ ref: String) -> UIImage? {
    let reference = Storage.storage().reference(forURL: ref)
  //  let placeholderImage = UIImage(named: "placeholder.jpg")
    var img:UIImage=UIImage()
    reference.getData(maxSize: 10 * 1024 * 1024, completion: { retrievedData, error in
        if error != nil {
            return
        }
         img = UIImage(data: retrievedData!)!
       // let size = image.frame.size
        //image.image = img.scaleImage(toSize:size )

    })
    
    return img
    // image.sd_setImage(with: reference, placeholderImage: placeholderImage)
   // img.scaleImage(toSize:CGSize(width: 100, height: 100))
}

func uploadFhoto(_ imageView: UIImageView, path: String, completion:  @escaping (URL?) -> Void){
    
    guard let image=imageView.image,  let data=image.jpegData(compressionQuality: 0.6) else {
        
        print("Error uploading image")
        completion(nil)
        return
    }

    let imageReferance=Storage.storage().reference().child(path+NSUUID().uuidString)
    
    imageReferance.putData(data, metadata: nil){
        (metadata,err) in
        if let error=err{
            print(error)
            return
        }
        imageReferance.downloadURL(completion: {(url,err) in
            if let error=err{
                print(error)
                return
            }
            completion(url)
        })
    }
}

func uploadUIImage(_ image: UIImage, path: String){
    
    guard let data=image.jpegData(compressionQuality: 0.6) else {
        
        print("Error uploading image")
        return
    }

    let imageReferance=Storage.storage().reference().child(path+NSUUID().uuidString)
    
    imageReferance.putData(data, metadata: nil){
        (metadata,err) in
        if let error=err{
            print(error)
            return
        }
    }
}

func deleteDocument(_ ref: String){
    let reference = Storage.storage().reference(forURL: ref)
    reference.delete { error in
      if let error = error {
        print(error)
      } else {
        print("Deleted")
      }
    }
}

func showError(_ message:String, errorLabel: UILabel){
    errorLabel.text=message
    errorLabel.alpha=1
}
