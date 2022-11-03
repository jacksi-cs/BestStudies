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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createTimePicker()
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
        
        self.timeField.text = timeFormatter.string(from: timePicker.countDownDuration)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SessionSegue" {
            let destVC = segue.destination as! SessionViewController
            destVC.isStopwatch = (sessionType.selectedSegmentIndex == 0)
            
            destVC.remainingTime = destVC.isStopwatch! ? nil : timePicker.countDownDuration
        }
    }
}
