// Project: SoundUITabBarController.swift
// EID: Jac23662
// Course: CS371L


import UIKit

class SoundUITabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        SoundManager.shared.playButtonSound(sound: .chillButton)
    }
}
