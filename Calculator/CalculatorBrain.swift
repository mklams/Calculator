//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Mark Klamik on 3/1/17.
//  Copyright © 2017 Mark Klamik. All rights reserved.
//

import Foundation

struct CalculatorBrain{
    
    private var accumulator: Double?
    
    func performOperation(_ symbol: String) {
        
    }
    
    mutating func setOperand(_ operand: Double) {
        accumulator = operand
    }
    
    var result: Double? {
        get {
            return accumulator
        }
    }
}
