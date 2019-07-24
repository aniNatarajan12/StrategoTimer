//
//  ViewController.swift
//  Stratego Timer
//
//  Created by Anirudh Natarajan on 7/23/19.
//  Copyright © 2019 Anirudh Natarajan. All rights reserved.
//

import UIKit

class TimerViewController: UIViewController {
    @IBOutlet weak var blueTeamView: UIView!
    @IBOutlet weak var redTeamView: UIView!
    @IBOutlet weak var blueBufferLabel: UILabel!
    @IBOutlet weak var redBufferLabel: UILabel!
    @IBOutlet weak var turnButton: UIButton!
    @IBOutlet weak var turnLabel: UILabel!
    @IBOutlet var resumeButton: UIButton!
    
    @IBOutlet var backgroundView: UIView!
    @IBOutlet var contentView: UIView!
    @IBOutlet var winLabel: UILabel!
    @IBOutlet var detailsLabel: UILabel!
    @IBOutlet var backButton: UIButton!
    
    var blueBufferTime = 0
    var redBufferTime = 0
    var turnTime = 0
    var timer = Timer()
    var buttonState = 0
    var moves = 0
    var startTime = Date.init()
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIApplication.shared.isIdleTimerDisabled = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        blueBufferTime = bufferTime * 60
        redBufferTime = bufferTime * 60
        turnButton.layer.cornerRadius = turnButton.frame.height/2
        turnButton.clipsToBounds = true
        buttonState = 0
        blueBufferLabel.transform = CGAffineTransform(rotationAngle: .pi)
        turnLabel.text = "Click to start game"
        blueBufferLabel.text = showTimeFromSeconds(time: blueBufferTime)
        redBufferLabel.text = showTimeFromSeconds(time: redBufferTime)
        turnTime = totalTurnTime
        toggleTurn()
        
        contentView.layer.cornerRadius = 10
        contentView.isHidden = true
        backgroundView.isHidden = true
        backButton.layer.cornerRadius = 20
        backButton.clipsToBounds = true
        resumeButton.isHidden = true
    }
    
    @IBAction func turnButtonPressed(_ sender: Any) {
        if buttonState == 0 {
            buttonState = 1
            startTime = Date.init()
            turnLabel.text = "\(totalTurnTime)"
            turnTime = totalTurnTime
            timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
        } else if buttonState == 1 {
            moves += 1
            timer.invalidate()
            turnLabel.text = "\(totalTurnTime)"
            turnTime = totalTurnTime
            redMove = !redMove
            toggleTurn()
            timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
        }
    }
    
    func toggleTurn() {
        if redMove {
            turnLabel.textColor = redTeamView.backgroundColor?.withAlphaComponent(1)
            turnLabel.transform = CGAffineTransform(rotationAngle: 0)
        } else {
            turnLabel.textColor = blueTeamView.backgroundColor?.withAlphaComponent(1)
            turnLabel.transform = CGAffineTransform(rotationAngle: .pi)
        }
    }
    
    @objc func updateTimer() {
        turnTime -= 1
        if turnTime < 0 {
            turnLabel.text = "0"
            if redMove {
                redBufferTime -= 1
                redBufferLabel.text = showTimeFromSeconds(time: redBufferTime)
                if redBufferTime <= 0 {
                    buttonState = 2
                    timer.invalidate()
                    
                    contentView.backgroundColor = blueTeamView.backgroundColor?.withAlphaComponent(1)
                    winLabel.textColor = blueBufferLabel.textColor
                    winLabel.text = "Blue Team Wins!"
                    detailsLabel.textColor = blueBufferLabel.textColor
                    backButton.titleLabel?.textColor = blueBufferLabel.textColor
                    winLabel.transform = CGAffineTransform(rotationAngle: .pi)
                    backButton.transform = CGAffineTransform(rotationAngle: .pi)
                    detailsLabel.transform = CGAffineTransform(rotationAngle: .pi)
                    
                    showPopup()
                }
            } else {
                blueBufferTime -= 1
                blueBufferLabel.text = showTimeFromSeconds(time: blueBufferTime)
                if blueBufferTime <= 0 {
                    buttonState = 2
                    timer.invalidate()
                    
                    contentView.backgroundColor = redTeamView.backgroundColor?.withAlphaComponent(1)
                    winLabel.textColor = redBufferLabel.textColor
                    winLabel.text = "Red Team Wins!"
                    detailsLabel.textColor = redBufferLabel.textColor
                    backButton.titleLabel?.textColor = redBufferLabel.textColor
                    winLabel.transform = CGAffineTransform(rotationAngle: 0)
                    backButton.transform = CGAffineTransform(rotationAngle: 0)
                    detailsLabel.transform = CGAffineTransform(rotationAngle: 0)
                    
                    showPopup()
                }
            }
        } else {
            turnLabel.text = "\(turnTime)"
        }
    }
    
    func showTimeFromSeconds(time: Int) -> String {
        let minute = time/60
        let seconds = time - minute*60
        if seconds < 10 {
            return "\(minute):0\(seconds)"
        }
        return "\(minute):\(seconds)"
    }
    
    @IBAction func backPressed(_ sender: Any) {
        dismissPopup()
    }
    
    @IBAction func gameOverPressed(_ sender: Any) {
        buttonState = 2
        timer.invalidate()
        
        contentView.backgroundColor = .lightGray
        winLabel.textColor = .white
        winLabel.text = "Game Over!"
        detailsLabel.textColor = .white
        backButton.titleLabel?.textColor = .lightGray
        
        showPopup()
    }
    
    @IBAction func pausePressed(_ sender: Any) {
        if buttonState == 1 {
            timer.invalidate()
            backgroundView.isHidden = false
            self.backgroundView.alpha = 0.8
            resumeButton.isHidden = false
        }
    }
    
    @IBAction func resumePressed(_ sender: Any) {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
        
        backgroundView.isHidden = true
        resumeButton.isHidden = true
    }
    
    func showPopup() {
        // animate bringing up the popup
        
        backgroundView.alpha = 0
        contentView.center = CGPoint(x: self.view.center.x, y: self.view.frame.height + self.contentView.frame.height)
        
        backgroundView.isHidden = false
        contentView.isHidden = false
        detailsLabel.text = "This game took \(moves) moves and \(Date.init().minutes(from: startTime)) minutes."
        
        UIView.animate(withDuration: 0.5, animations: {
            self.backgroundView.alpha = 0.66
        })
        UIView.animate(withDuration: 0.7, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 9, options: UIView.AnimationOptions(rawValue: 0), animations: {
            self.contentView.center = self.view.center
        }, completion: { (completed) in
            
        })
    }
    
    func dismissPopup(){
        // animate dismissal of popup
        
        UIView.animate(withDuration: 0.33, animations: {
            self.backgroundView.alpha = 0
        }, completion: { (completed) in
            
        })
        UIView.animate(withDuration: 0.33, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 10, options: UIView.AnimationOptions(rawValue: 0), animations: {
            self.contentView.center = CGPoint(x: self.view.center.x, y: self.view.frame.height + self.contentView.frame.height/2)
        }, completion: { (completed) in
            self.backgroundView.isHidden = true
            self.contentView.isHidden = true
            self.performSegue(withIdentifier: "gameOver", sender: self)
        })
    }

}

extension Date {
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
}

