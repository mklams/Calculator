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
    
    @IBOutlet weak var actions: UILabel!
    
    var userInTheMiddleOfTyping: Bool = false
    
    @IBAction func touchDigit(_ sender: UIButton)
    {
        let digit = sender.currentTitle!
        
        if userInTheMiddleOfTyping
        {
            let textCurrentlyInDisplay = display.text!
            
            if !(textCurrentlyInDisplay.contains(".") && digit == ".")
            {
                display.text = textCurrentlyInDisplay + digit
            }
        }
        else
        {
            if digit == "."
            {
                display.text =  "0."
            }
            else
            {
                display.text = digit
            }
            userInTheMiddleOfTyping = true
        }
        
    }
    
    @IBAction func backspace(_ sender: UIButton)
    {
        if userInTheMiddleOfTyping
        {
            let textInDisplay = display.text!
            display.text = textInDisplay.substring(to: (textInDisplay.index(before: textInDisplay.endIndex)))
        }
    }
    
    var displayValue: Double
    {
        get { return Double(display.text!)! }
        
        set { display.text = String(newValue) }
    }
    
    var historyValue: String
    {
        get { return actions.text! }
        
        set
        {
            if !userInTheMiddleOfTyping
            {
                if newValue == ""
                {
                    actions.text = " "
                }
                else if brain.resultIsPending
                {
                    actions.text = newValue + " ..."
                }
                else
                {
                    actions.text = newValue + " ="
                }
            }
        }
    }
    
    private var brain: CalculatorBrain = CalculatorBrain()
    
    @IBAction func performOperation(_ sender: UIButton)
    {
        if userInTheMiddleOfTyping
        {
            brain.setOperand(displayValue)
            userInTheMiddleOfTyping = false
        }
        
        if let mathamaticalSymbol = sender.currentTitle
        {
            brain.performOperation(mathamaticalSymbol)
        }
        
        if let result = brain.result
        {
            displayValue = result
        }
        
        if let operations = brain.description
        {
           historyValue = operations
        }
    }
}

