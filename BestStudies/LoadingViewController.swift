// Project: LoadingViewController.swift
// EID: Jac23662
// Course: CS371L


import UIKit
import FirebaseAuth

class LoadingViewController: UIViewController {

    
    @IBOutlet weak var progressBar: UIProgressView!
    
    let loadingSegue = "LoadingSegue"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        animateProgress()
        Auth.auth().addStateDidChangeListener() { [weak self]
            auth, user in
            if user != nil {
                self!.performSegue(withIdentifier: "homeSegue", sender: nil)
            }
            else {
                self!.performSegue(withIdentifier: self!.loadingSegue, sender: self)
            }
        }
        
    }
    
    func animateProgress() {
        self.progressBar.setProgress(0.0, animated: false)    // reset to zero
        for i in 1...100 {
            let prog = Double(i) * 0.01
            usleep(500)
            self.progressBar.setProgress(Float(prog), animated: true)
                }
    }
    

}
