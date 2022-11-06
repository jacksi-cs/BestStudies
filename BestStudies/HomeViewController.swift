//
//  HomeViewController.swift
//  BestStudies
//
//  Created by Jack Si on 10/17/22.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }

    @IBAction func createButtonPressed(_ sender: Any) {
        SoundManager.shared.playButtonSound(sound: .chillButton)
    }
    @IBAction func joinButtonPressed(_ sender: Any) {
        SoundManager.shared.playButtonSound(sound: .chillButton)
    }
}
