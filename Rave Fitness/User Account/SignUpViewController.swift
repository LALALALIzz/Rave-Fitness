//
//  SignUpViewController.swift
//  Rave Fitness
//
//  Created by liuyang on 7/26/21.
//

import UIKit
import FirebaseAuth
import Firebase

class SignUpViewController: UIViewController {

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements()
        // Do any additional setup after loading the view.
    }
    
    func setUpElements()
    {
        errorLabel.alpha = 0
        
        Utility.styleTextField(firstNameTextField)
        Utility.styleTextField(lastNameTextField)
        Utility.styleTextField(emailTextField)
        Utility.styleTextField(passwordTextField)
        Utility.styleFilledButton(signUpButton)
        Utility.styleFilledButton(cancelButton)
    }
    
    func validateFields() -> String?
    {
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
        lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
        {
            return "All fields should be filled in!"
        }
        
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if Utility.isPasswordValid(password) == false
        {
            return "Password should be at least 8 characters long, and contain letters, numbers and 1 special symbol"
        }
        
        return nil
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
        
        let error = validateFields()
        
        if error != nil{
            showError(error!)
        }
        else{
            
            let firstname = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastname = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                
                if err != nil{
                    self.showError("Failed to create user!")
                }
                else{
                    let db = Firestore.firestore()
                    db.collection("users").document(result!.user.uid).setData([
                        "firstname": firstname,
                        "lastname": lastname,
                    ]) { err in
                        if let err = err {
                            print("Error writing document: \(err)")
                        } 
                    }
                    self.goToHome()
                }
            }
        }
    }
    
    
    func showError(_ message:String){
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    func goToHome()
    {
        let home = storyboard?.instantiateViewController(identifier: "HomeViewController") as? TabBarContoller
        
        view.window?.rootViewController = home
        view.window?.makeKeyAndVisible()
    }
    
}
