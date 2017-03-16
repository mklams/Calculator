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
    private var pendingBinaryOperation: PendingBinaryOperation?
    private var displayAccumulator: String?
    
    private enum Operation
    {
        case constant(Double, String)
        case unaryOperation((Double) -> Double, (String) -> String)
        case binaryOperation((Double,Double) -> Double, (String,String) -> String)
        case equals
        case clear
    }
    
    private var operations: Dictionary<String, Operation> = [
        "π" : Operation.constant(Double.pi, "π"),
        "e" : Operation.constant(M_E, "e"),
        "√" : Operation.unaryOperation(sqrt, { "√(\($0))"}),
        "cos" : Operation.unaryOperation(cos, {"cos(\($0))"}),
        "sin" : Operation.unaryOperation(sin, {"sin(\($0))"}),
        "tan" : Operation.unaryOperation(tan, {"tan(\($0)"}),
        "ln" : Operation.unaryOperation(log2, {"ln(\($0))"}),
        "±" :  Operation.unaryOperation({ -$0 }, {"-(\($0))"}),
        "pow" : Operation.binaryOperation(pow, {"\($0) pow \($1)"}),
        "x" : Operation.binaryOperation({ $0 * $1 }, {"\($0) x \($1)"}),
        "÷" : Operation.binaryOperation({ $0 / $1 }, {"\($0) ÷ \($1)"}),
        "−" : Operation.binaryOperation({ $0 - $1 }, {"\($0) - \($1)"}),
        "+" : Operation.binaryOperation({ $0 + $1 }, {"\($0) + \($1)"}),
        "=" : Operation.equals,
        "c" : Operation.clear
    ]
    
    mutating func performOperation(_ symbol: String)
    {
        if let operation = operations[symbol]
        {
            switch operation {
            case .constant(let value, let displayValue):
                accumulator = value
                if pendingBinaryOperation == nil {
                    displayAccumulator = displayValue
                }
            case .unaryOperation(let function, let displayFunction):
                if accumulator != nil
                {
                    accumulator = function(accumulator!)
                    displayAccumulator = displayFunction(displayAccumulator!)
                }
            case .binaryOperation(let function, let displayFunction):
                if accumulator != nil
                {
                    performPendingBinaryOperation()
                    pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator!)
                    accumulator = nil
                    displayAccumulator = displayFunction(displayAccumulator!, "")
                }
            case .equals:
                performPendingBinaryOperation()
            case .clear:
                clearCalculator()
            }
        }
    }
    
    mutating func setOperand(_ operand: Double)
    {
        if pendingBinaryOperation == nil {
            displayAccumulator = String(operand)
        }
        accumulator = operand
    }
    
    private mutating func clearCalculator()
    {
        pendingBinaryOperation = nil
        accumulator = 0
        displayAccumulator = nil
    }
    
    private mutating func performPendingBinaryOperation()
    {
        if pendingBinaryOperation != nil
        {
            displayAccumulator = "\(displayAccumulator!)\(accumulator!)"
            accumulator = pendingBinaryOperation!.perform(with: accumulator!)
            pendingBinaryOperation = nil
        }
    }
    
    private struct PendingBinaryOperation
    {
        let function: (Double, Double) -> Double
        let firstOperand: Double
        
        func perform(with secondOperand: Double) -> Double
        {
            return function(firstOperand, secondOperand)
        }
    }
    
    var result: Double?
    {
        get { return accumulator }
    }
    
    var resultIsPending: Bool
    {
        get { return pendingBinaryOperation != nil }
    }
    
    var description: String?
    {
        get { return displayAccumulator ?? ""}
    }
}
