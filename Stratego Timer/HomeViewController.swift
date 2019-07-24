//
//  HomeViewController.swift
//  Stratego Timer
//
//  Created by Anirudh Natarajan on 7/23/19.
//  Copyright © 2019 Anirudh Natarajan. All rights reserved.
//

import Foundation
import UIKit

var totalTurnTime = 15
var bufferTime = 5
var redMove = true

class HomeViewController: UIViewController {
    @IBOutlet var beginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        beginButton.layer.cornerRadius = 20
        beginButton.clipsToBounds = true
        
        let defaults = UserDefaults.standard
        if let tt = defaults.string(forKey: "turnTime") {
            totalTurnTime = Int(tt)!
        }
        if let bt = defaults.string(forKey: "bufferTime") {
            bufferTime = Int(bt)!
        }
        if let rm = defaults.string(forKey: "first") {
            redMove = rm=="1"
        }
    }
}
