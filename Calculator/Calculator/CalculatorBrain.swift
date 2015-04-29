//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Jenna Salau on 27/04/2015.
//  Copyright (c) 2015 Jenna Salau. All rights reserved.
//

import Foundation

class CalculatorBrain
{
    /*
    *   Constructors
    *   =================================================================
    */
    
    init(){
        
        func learnOp(op: Op)
        {
            knownOps[op.description] = op
        }
        
        learnOp(Op.BinaryOperation("×"){ $0 * $1})
        learnOp(Op.BinaryOperation("÷"){ $1 / $0})
        learnOp(Op.BinaryOperation("+"){ $0 + $1})
        learnOp(Op.BinaryOperation("−"){ $1 - $0})
        learnOp(Op.UniaryOperation("√"){ sqrt($0) })
        learnOp(Op.UniaryOperation("sin"){ sin($0) })
        learnOp(Op.UniaryOperation("cos"){ cos($0) })
    }
    
    /*
    *   Properties
    *   =================================================================
    */
    
    private enum Op: Printable {
        case Operand(Double)
        case UniaryOperation(String, Double -> Double)
        case BinaryOperation(String, (Double, Double) -> Double)
        
        var description: String {
            get{
                switch self
                {
                    case .Operand(let operand):
                        return "\(operand)"
                    case .UniaryOperation(let symbol, _):
                        return symbol
                    case .BinaryOperation(let symbol, _):
                        return symbol
                }
            }
        }
    }
    
    private var opStack = [Op]()
    
    private var knownOps = [String:Op]()
    
    
    /*
    *   Methods
    *   =================================================================
    */
    
    private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op])
    {
        if(!ops.isEmpty)
        {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            
            switch op {
                case .Operand(let operand):
                    return (operand, remainingOps)
                case .UniaryOperation(_, let operation):
                    let operandEvaluation = evaluate(remainingOps)
                    if let operand = operandEvaluation.result {
                        return (operation(operand), operandEvaluation.remainingOps)
                    }
                case .BinaryOperation(_, let operation):
                    let op1Evaluation = evaluate(remainingOps)
                    if let operand1 = op1Evaluation.result {
                        let op2Evaluation = evaluate(op1Evaluation.remainingOps)
                        if let operand2 = op2Evaluation.result {
                            return (operation(operand1, operand2), op2Evaluation.remainingOps)
                        }
                    }
            }
        }
        
        return (nil, ops)
    }
    
    func evaluate() -> Double? {
        let (result, remainder) = evaluate(opStack)
        return result
    }
    
    func evaluate() -> (Double?, String) {
        let (result, remainder) = evaluate(opStack)
        let equasion = "\(opStack) ="
            .stringByReplacingOccurrencesOfString("[", withString: "")
            .stringByReplacingOccurrencesOfString("]", withString: "")
        
        return (result, equasion)
    }
    
    func pushOperand(operand: Double) -> Double? {
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    func performOperation(symbol: String) -> Double? {
        if let operation = knownOps[symbol] {
            opStack.append(operation)
        }
        
        return evaluate()
    }
    
    func performOperation(symbol: String) -> (Double?, String) {
        if let operation = knownOps[symbol] {
            opStack.append(operation)
        }
        let (result, history) = evaluate()
        return (result, history)
    }
    
}

