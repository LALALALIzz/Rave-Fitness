//
//  ProfileViewController.swift
//  Rave Fitness
//
//  Created by liuyang on 7/26/21.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore
class ProfileViewController: UIViewController {
    @IBOutlet weak var firstnameLabel: UILabel!
    @IBOutlet weak var lastnameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var passwordResetButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        errorLabel.alpha = 0
        photo.layer.cornerRadius = 60.0
        topView.backgroundColor = UIColor.init(red: 48/255, green: 173/255, blue: 99/255, alpha: 1)
        Utility.styleLabel(firstnameLabel)
        Utility.styleLabel(lastnameLabel)
        Utility.styleLabel(emailLabel)
        Utility.styleFilledButton(passwordResetButton)
        fetchProfile()
        // Do any additional setup after loading the view.
    }
    

    func fetchProfile()
    {
        let myActivityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
        myActivityIndicator.center = view.center
        myActivityIndicator.hidesWhenStopped = false
        myActivityIndicator.startAnimating()
        if Auth.auth().currentUser != nil
        {
            guard let myUid = Auth.auth().currentUser?.uid
            else {return}
            
            let db = Firestore.firestore()
            let docref = db.collection("users").document(myUid)

            docref.getDocument { (document, error) in
                if let document = document, document.exists {
                    let user = FetchedUser(uid:myUid, dictionary: document.data() ?? ["":""])
                    
                    self.firstnameLabel.text = user.firstname
                    self.firstnameLabel.alpha = 1
                    self.lastnameLabel.text = user.lastname
                    self.lastnameLabel.alpha = 1
                    self.emailLabel.text = (Auth.auth().currentUser?.email)!
                    self.emailLabel.alpha = 1
                    self.photo.alpha = 1
                } else {
                    self.showError("Fail to fetch profile!")
                }
            }
        }
        myActivityIndicator.stopAnimating()
    }
    
    
    @IBAction func passwordResetButtonTapped(_ sender: Any) {
        var isError = true
        Auth.auth().sendPasswordReset(withEmail: Auth.auth().currentUser?.email ?? "") { (err) in
            if err != nil {
                self.showError("Failed to send password reset email!")
                isError = false
                print(err?.localizedDescription)
            }
        }
        let alertController = UIAlertController(title: "Password Reset", message: "Password reset email is sent, please check your email box!", preferredStyle: UIAlertController.Style.alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel))
        
        alertController.addAction(UIAlertAction(title: "Resend", style: .default) {_ in
            Auth.auth().sendPasswordReset(withEmail: Auth.auth().currentUser?.email ?? "") { (err) in
                if err != nil {
                    self.showError("Failed to send password reset email!")
                }
                return
            }
        })
        let delay = 1.0
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            if isError == true
            {
                self.errorLabel.alpha = 0
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    func showError(_ message:String)
    {
        errorLabel.text = message
        errorLabel.alpha = 1
    }
}
