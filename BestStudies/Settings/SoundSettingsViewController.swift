// Project: SoundSettingsViewController.swift
// EID: Jac23662
// Course: CS371L


import UIKit

class SoundSettingsViewController: UIViewController {

    @IBOutlet weak var soundOnButton: UISwitch!
    @IBOutlet weak var soundSlider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        soundOnButton.isOn = UserDefaults.standard.bool(forKey: "soundOn")
        soundSlider.value = UserDefaults.standard.float(forKey: "soundVolume")
    }

    @IBAction func soundButtonPressed(_ sender: UISwitch) {
        UserDefaults.standard.set(soundOnButton.isOn, forKey: "soundOn")
    }
    
    @IBAction func soundVolumeChanged(_ sender: Any) {
        UserDefaults.standard.set(soundSlider.value, forKey: "soundVolume")
    }
    
}
