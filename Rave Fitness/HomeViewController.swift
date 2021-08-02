//
//  HomeViewController.swift
//  Rave Fitness
//
//  Created by liuyang on 7/25/21.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var startButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        Utility.styleFilledButton(startButton)
        // Do any additional setup after loading the view.
    }
}
