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
    private var takenActions: String?
    
    private enum Operation
    {
        case constant(Double)
        case unaryOperation((Double) -> Double)
        case binaryOperation((Double,Double) -> Double)
        case equals
        case clear
    }
    
    private var operations: Dictionary<String, Operation> = [
        "π" : Operation.constant(Double.pi),
        "e" : Operation.constant(M_E),
        "√" : Operation.unaryOperation(sqrt),
        "cos" : Operation.unaryOperation(cos),
        "sin" : Operation.unaryOperation(sin),
        "tan" : Operation.unaryOperation(tan),
        "ln" : Operation.unaryOperation(log2),
        "±" :  Operation.unaryOperation({ -$0 }),
        "pow" : Operation.binaryOperation(pow),
        "x" : Operation.binaryOperation({ $0 * $1 }),
        "÷" : Operation.binaryOperation({ $0 / $1 }),
        "−" : Operation.binaryOperation({ $0 - $1 }),
        "+" : Operation.binaryOperation({ $0 + $1 }),
        "=" : Operation.equals,
        "c" : Operation.clear
    ]
    
    mutating func performOperation(_ symbol: String)
    {
        if let operation = operations[symbol]
        {
            switch operation {
            case .constant(let value):
                accumulator = value
            case .unaryOperation(let function):
                if accumulator != nil
                {
                    accumulator = function(accumulator!)
                }
            case .binaryOperation(let function):
                if accumulator != nil
                {
                    performPendingBinaryOperation()
                    pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator!)
                    accumulator = nil
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
        accumulator = operand
    }
    
    private mutating func clearCalculator()
    {
        pendingBinaryOperation = nil
        accumulator = 0
        takenActions = nil
    }
    
    private mutating func performPendingBinaryOperation()
    {
        if pendingBinaryOperation != nil
        {
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
        get { return takenActions }
    }
}
