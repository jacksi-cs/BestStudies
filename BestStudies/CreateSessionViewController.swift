//
//  CreateSessionViewController.swift
//  BestStudies
//
//  Created by Jack Si on 10/17/22.
//

import UIKit

let SECONDS_IN_MINUTE = 60.0

class CreateSessionViewController: UIViewController {
    
    let timePicker = UIDatePicker()

    @IBOutlet weak var sessionType: UISegmentedControl!
    @IBOutlet weak var timeField: UITextField!
    @IBOutlet weak var createSessionButton: UIButton!
    
    var sessionTime: TimeInterval = SECONDS_IN_MINUTE * 30
    
    var connectionManager: ConnectionManager = ConnectionManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "chalk.jpeg")!)
        createTimePicker()
    }
    
    override func viewWillAppear(_ animated: Bool) {        
        sessionType.selectedSegmentTintColor = UIColor(white: 0.5, alpha: 0.5)
        sessionType.backgroundColor = .clear
        sessionType.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Chalkduster", size: 15)!, NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
        
    }
    
    func createToolbar() -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([doneBtn], animated: true)
        
        return toolbar
    }
    
    func createTimePicker() {
        timePicker.preferredDatePickerStyle = .wheels
        timePicker.datePickerMode = .countDownTimer
        timePicker.countDownDuration = sessionTime
        timeField.inputView = timePicker
        timeField.inputAccessoryView = createToolbar()
    }
    
    @objc func donePressed() {
        sessionTime = timePicker.countDownDuration
        
        let timeFormatter = DateComponentsFormatter()
        timeFormatter.unitsStyle = .abbreviated
        timeFormatter.zeroFormattingBehavior = .pad
        timeFormatter.allowedUnits = [.hour, .minute]
        
        SoundManager.shared.playButtonSound(sound: .chillButton)
        self.timeField.text = "Time: \(timeFormatter.string(from: timePicker.countDownDuration)!)"
        self.view.endEditing(true)
    }

    @IBAction func onSessionTypeChanged(_ sender: Any) {
        switch sessionType.selectedSegmentIndex {
        case 0:
            timeField.isHidden = true
            self.view.endEditing(true)
        case 1:
            timeField.isHidden = false
        default:
            print("Default should not be hit in switch statement")
            
        }
    }
    
    @IBAction func createSessionPressed(_ sender: Any) {
        connectionManager.isStopwatch = (sessionType.selectedSegmentIndex == 0)
        connectionManager.remainingTime = connectionManager.isStopwatch! ? nil : timePicker.countDownDuration
        
        connectionManager.host()
        
        performSegue(withIdentifier: "WaitingRoomSegueIdentifier2", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "SessionSegue" {
//            SoundManager.shared.playButtonSound(sound: .buttonNoise)
//            let destVC = segue.destination as! SessionViewController
//
//            destVC.isStopwatch = (sessionType.selectedSegmentIndex == 0)
//            destVC.remainingTime = destVC.isStopwatch! ? nil : timePicker.countDownDuration
//        }
        if segue.identifier == "WaitingRoomSegueIdentifier2" {
            
            SoundManager.shared.playButtonSound(sound: .buttonNoise)
            
            let destVC = segue.destination as! WaitingRoomViewController
            destVC.connectionManager = self.connectionManager
            // TODO: Need to pass on valuable information to waitingroom --> session (isstopwatch, remainingtime, countdownduration, etc.)
        }
    }
}
