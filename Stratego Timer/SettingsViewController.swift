//
//  SettingsViewController.swift
//  Stratego Timer
//
//  Created by Anirudh Natarajan on 7/23/19.
//  Copyright © 2019 Anirudh Natarajan. All rights reserved.
//

import Foundation
import UIKit

class SettingsViewController: UIViewController {
    @IBOutlet weak var turnTimeField: UITextField!
    @IBOutlet weak var bufferTimeField: UITextField!
    @IBOutlet weak var teamSwitch: UISwitch!
    @IBOutlet var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        turnTimeField.text = "\(totalTurnTime)"
        bufferTimeField.text = "\(bufferTime)"
        teamSwitch.isOn = redMove
        teamSwitch.layer.cornerRadius = 16
        errorLabel.isHidden = true
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func backPressed(_ sender: Any) {
        if turnTimeField.text=="" || bufferTimeField.text=="" {
            errorLabel.isHidden = false
        } else {
            totalTurnTime = Int(turnTimeField.text!)!
            bufferTime = Int(bufferTimeField.text!)!
            redMove = teamSwitch.isOn
            
            let defaults = UserDefaults.standard
            defaults.set(turnTimeField.text!, forKey: "turnTime")
            defaults.set(bufferTimeField.text!, forKey: "bufferTime")
            defaults.set(teamSwitch.isOn ? "1":"0", forKey: "first")
            
            self.performSegue(withIdentifier: "saveSettings", sender: self)
        }
    }
}
