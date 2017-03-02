//
//  ViewController.swift
//  Calculator
//
//  Created by Mark Klamik on 3/1/17.
//  Copyright © 2017 Mark Klamik. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var display: UILabel!
    
    var userInTheMiddleOfTyping: Bool = false
    
    @IBAction func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        if userInTheMiddleOfTyping {
            let textCurrentlyInDisplay = display.text!
            display.text = textCurrentlyInDisplay + digit
        } else {
            display.text = digit
            userInTheMiddleOfTyping = true
        }
        
    }
    
    var displayValue: Double {
        get{
            return Double(display.text!)!
        }
        set{
            display.text = String(newValue)
        }
    }
    
    private var brain: CalculatorBrain = CalculatorBrain()
    
    @IBAction func performOperation(_ sender: UIButton) {
        if userInTheMiddleOfTyping {
            brain.setOperand(displayValue)
            userInTheMiddleOfTyping = false
        }
        
        if let mathamaticalSymbol = sender.currentTitle {
            brain.performOperation(mathamaticalSymbol)
        }
        
        if let result = brain.result {
            displayValue = result
        }
    }
}

