//
//  LandingViewController.swift
//  Rave Fitness
//
//  Created by liuyang on 7/26/21.
//

import UIKit

class LandingViewController: UIViewController {

    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements()
        // Do any additional setup after loading the view.
    }
    
    func setUpElements()
    {
        Utility.styleFilledButton(signInButton)
        Utility.styleFilledButton(signUpButton)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func signInTapped(_ sender: Any) {
    }
    
    
    @IBAction func signUpTapped(_ sender: Any) {
    }
}
