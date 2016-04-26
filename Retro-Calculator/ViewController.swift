//
//  ViewController.swift
//  Retro-Calculator
//
//  Created by Andrew Smith on 4/25/16.
//  Copyright © 2016 KM187-Testing. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    enum Operation: String {
        case Multiply = "*"
        case Divide = "/"
        case Add = "+"
        case Subtract = "-"
        case Empty = ""
    }
    
    @IBOutlet weak var counterLbl: UILabel!
    
    var btnSound: AVAudioPlayer!
    var clearSound: AVAudioPlayer!
    
    var leftValue = ""
    var rightValue = ""
    var runningValue = ""
    var returnValue = ""
    var currentOperation: Operation = Operation.Empty
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Sounds for the buttons
        let pathBtn = NSBundle.mainBundle().pathForResource("btn", ofType: "mp3")
        let soundUrlBtn = NSURL(fileURLWithPath: pathBtn!)
        
        let pathClear = NSBundle.mainBundle().pathForResource("clear", ofType: "wav")
        let soundUrlClear = NSURL(fileURLWithPath: pathClear!)
        
        do {
            try clearSound = AVAudioPlayer(contentsOfURL: soundUrlClear)
            clearSound.prepareToPlay()
            
            try btnSound = AVAudioPlayer(contentsOfURL: soundUrlBtn)
            btnSound.prepareToPlay()
            
        } catch let err as NSError {
            print(err.debugDescription)
        }
    }
    
    @IBAction func onNumericBtnPressed (btn: UIButton!) {
        playSound(btnSound)
        runningValue += "\(btn.tag)"
        
        counterLbl.text = runningValue
    }
    
    @IBAction func onDividePressed (sender: UIButton!) {
        processOperation(Operation.Divide)
    }
    @IBAction func onMultiplyPressed (sender: UIButton!) {
        processOperation(Operation.Multiply)
    }
    @IBAction func onAdditionPressed (sender: UIButton!) {
        processOperation(Operation.Add)
    }
    @IBAction func onSubtractPressed (sender: UIButton) {
        processOperation(Operation.Subtract)
    }
    @IBAction func onEqualsPressed (sender: UIButton) {
        processOperation(currentOperation)
    }
    @IBAction func onClearPressed (sender: UIButton) {
        playSound(clearSound)
        runningValue = ""
        leftValue = ""
        rightValue = ""
        currentOperation = Operation.Empty
        counterLbl.text = "0"
    }
    
    func processOperation (operation: Operation) {
        playSound(btnSound)
        
        if currentOperation == Operation.Empty {
            currentOperation = operation
            leftValue = runningValue
            runningValue = ""
        }else if runningValue == "" {
            currentOperation = operation
        }else {
            rightValue = runningValue
            runningValue = ""
            if currentOperation == Operation.Add {
                returnValue = "\(Double(leftValue)! + Double(rightValue)!)"
            }else if currentOperation == Operation.Subtract {
                returnValue = "\(Double(leftValue)! - Double(rightValue)!)"
            }else if currentOperation == Operation.Multiply {
                returnValue = "\(Double(leftValue)! * Double(rightValue)!)"
            }else if currentOperation == Operation.Divide {
                returnValue = "\(Double(leftValue)! / Double(rightValue)!)"
            }
            leftValue = returnValue
            counterLbl.text = returnValue
            currentOperation = operation
        }
    }
    
    func playSound (sound: AVAudioPlayer!) {
        if sound.playing {
            sound.stop()
        }
        sound.play()
    }



}

