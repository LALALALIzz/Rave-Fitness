//
//  SignInViewController.swift
//  Rave Fitness
//
//  Created by liuyang on 7/26/21.
//

import UIKit
import FirebaseAuth
class SignInViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var passwordResetButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements()
        // Do any additional setup after loading the view.
    }
    
    func setUpElements()
    {
        errorLabel.alpha = 0
         
        Utility.styleTextField(emailTextField)
        Utility.styleTextField(passwordTextField)
        Utility.styleFilledButton(signInButton)
        Utility.styleFilledButton(cancelButton)
        Utility.styleUnderlineButton(passwordResetButton)
    }
 
    func validateFields() -> String?
    {
        if emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
        {
            return "All fields should be filled in!"
        }
        return nil
    }

    func showError(_ message:String){
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func signInTapped(_ sender: Any) {
        
        let error = validateFields()
        
        if error != nil{
            showError(error!)
        }
        else{
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                if error != nil
                {
                    self.showError("Fail to sign in!")
                }
                else
                {
                    let home = self.storyboard?.instantiateViewController(identifier: "HomeViewController") as? TabBarContoller
                    
                    self.view.window?.rootViewController = home
                    self.view.window?.makeKeyAndVisible()
                }
            }
        }
        
        
    }
    @IBAction func passwordResetButtonTapped(_ sender: Any) {
        let alertController = UIAlertController(title: "Password Reset",
                                                message: "Please enter your email address used for registration!",
                                                preferredStyle: UIAlertController.Style.alert)
        alertController.addTextField { textField in
            textField.placeholder = "Enter email address"
        }
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        alertController.addAction(UIAlertAction(title: "Submit", style: .default) {_ in
            Auth.auth().sendPasswordReset(withEmail: alertController.textFields?[0].text ?? "") { (err) in
                if(err != nil){
                    self.showError("Failed to send password reset email!")
                }
            }
        })
        
        present(alertController, animated: true, completion: nil)
    }
    
    
}
