//
//  RegisterViewController.swift
//  IMOVE3
//
//  Created by Fhict on 07/12/2017.
//  Copyright © 2017 fontys. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth

class RegisterViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    var ref: DatabaseReference!
    var refHandle:UInt!
    
    @IBOutlet weak var checkPasswordTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    var profileImage:UIImage?
    
    var user: User?
    override func viewDidLoad() {
        super.viewDidLoad()
         ref = Database.database().reference()
        self.nameTextField.delegate = self
        self.passwordTextField.delegate = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
     //MARK: Actions
    @IBAction func HideKeyboard(_ sender: Any) {
        view.endEditing(true)
    }
   
    @IBAction func Register(_ sender: Any) {
        var name = nameTextField.text
        var password = passwordTextField.text
        var img = profileImage
        var level = 1
        var totalScore = 0
        var challenges = 0
        var logedIn = false;
        print(self.profileImage)
        
        if nameTextField.text == "" || passwordTextField.text == ""{
            let alert = UIAlertController(title: "Error", message: "Please enter a name and password", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(defaultAction)
            
            present(alert, animated: true, completion: nil)
            
        if(passwordTextField.text != checkPasswordTextField.text)
        {
            let alert = UIAlertController(title: "Error", message: "Please enter a the same password twice", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(defaultAction)
            
            present(alert, animated: true, completion: nil)
        }
            
            
        } else {
            let nameEmail = nameTextField.text! + "@email.com";
            Auth.auth().createUser(withEmail: nameEmail, password: passwordTextField.text!) { (user, error) in
                
                if error == nil {
                    
                    print("You have successfully registered")
                    
                    let uid = (Auth.auth().currentUser?.uid)!
                    let refImage = Storage.storage().reference().child("Users").child("\(name!).jpg")
                    if let uploadData = UIImageJPEGRepresentation(self.profileImage!, 0.1)
                    {
                        refImage.putData( uploadData , metadata: nil, completion: { (metadata, error) in
                            if error != nil
                            {
                                print(error)
                                return
                            }
                            if let productImageURL = metadata?.downloadURL()?.absoluteString {
                                let value = [
                                    "name" : name,
                                    "level" : level,
                                    "profileImage" : productImageURL,
                                    "totalScore" : totalScore,
                                    "challenges" : challenges
                                    ] as [String : Any]
                                self.ref.child("Users").child(uid).setValue(value)
                            }
                        })
                    }
                    
                    Auth.auth().signIn(withEmail: nameEmail, password: password!) { (user, error) in
                        
                        if error == nil {
                            
                            print("You have successfully logged in")
                            
                            let VC1 = self.storyboard!.instantiateViewController(withIdentifier: "mainTabBarController") as! UITabBarController
                            self.present(VC1, animated:true, completion: nil)
                            
                        } else {
                            let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                            
                            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                            alertController.addAction(defaultAction)
                            
                            self.present(alertController, animated: true, completion: nil)
                        }
                    }
                    
                    
                } else {
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
        
        nameTextField.text = ""
        passwordTextField.text = ""
        checkPasswordTextField.text = ""
        
    }
    
    
    
    
    @IBAction func SetImage(_ sender: UIButton) {
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .photoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
        
    }
    
    
    
   
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        var selectedImage:UIImage?
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage{
            selectedImage = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            selectedImage = originalImage
        }
        
        if let selectedImageFromPicker = selectedImage{
            self.profileImage = selectedImageFromPicker
            print(self.profileImage)
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func Cancel(_ sender: UIBarButtonItem)
    {
        dismiss(animated: true, completion: nil)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (string == "\n") {
            nameTextField.resignFirstResponder()
            passwordTextField.resignFirstResponder()
            return false
        }
        return true
    }

}

extension UIImage {
    func resizeWithPercent(percentage: CGFloat) -> UIImage? {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: size.width * percentage, height: size.height * percentage)))
        imageView.contentMode = .scaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return result
    }
    func resizeWithWidth(width: CGFloat) -> UIImage? {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))))
        imageView.contentMode = .scaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return result
    }
}
