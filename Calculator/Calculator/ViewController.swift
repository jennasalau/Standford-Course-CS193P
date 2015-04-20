//
//  ViewController.swift
//  Calculator
//
//  Created by Jenna Salau on 14/04/2015.
//  Copyright (c) 2015 Jenna Salau. All rights reserved.
//

import UIKit

class HistoryItem
{
    init(){
        operand = ""
        value = 0
    }
    
    var operand : String
    var value : Double
}

class ViewController: UIViewController
{
    /*
    *   Properties
    *   =================================================================
    */
    @IBOutlet weak var display: UILabel!;
    
    @IBOutlet weak var historyLbl: UILabel!;
    
    var userIsInTheMiddleOfTypingANumber = false;
    
    var operandStack = Array<Double>();
    
    var history : String = "";
    
    var displayValue: Double {
        get{
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue;
        }
        set{
            userIsInTheMiddleOfTypingANumber = false;
            display.text = "\(newValue)";
        }
    }
    
    
    /*
    *   Lifecycle
    *   =================================================================
    */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    *   Methods
    *   =================================================================
    */
    
    @IBAction func operate(sender: UIButton) {
        let operation = sender.currentTitle!;
        
        if(userIsInTheMiddleOfTypingANumber)
        {
            enter();
        }
        
        // Build the equastion string first as the operation mutates the operandStack
        var equasion = "\(operandStack) ="
                    .stringByReplacingOccurrencesOfString("[", withString: "", options: nil, range: nil)
                    .stringByReplacingOccurrencesOfString("]", withString: "", options: nil, range: nil)
                    .stringByReplacingOccurrencesOfString(", ", withString: " \(operation) ", options: nil, range: nil)

        
        switch operation{
            case "×":
                performOperation{ $0 * $1};
                break;
            case "÷":
                performOperation{ $1 / $0};
                break;
            case "+":
                performOperation{ $0 + $1};
                break;
            case "−":
                performOperation{ $1 * $0};
                break;
            case "√":
                performCoreOperation{ sqrt($0) };
                break;
            case "sin":
                performCoreOperation{ sin($0) };
                break;
            case "cos":
                performCoreOperation{ cos($0) };
                break;
            default:
                break;
        }
        
        // Reset the history label to the equasion
        historyLbl.text = equasion
        
    }
    
    func performOperation(operation: (Double, Double) -> Double)
    {
        if(operandStack.count >= 2)
        {
            displayValue = operation(operandStack.removeLast(),  operandStack.removeLast());
            enter();
        }
    }
    
    func performCoreOperation(operation: Double -> Double)
    {
        if(operandStack.count >= 1)
        {
            displayValue = operation(operandStack.removeLast());
            enter();
        }
    }
    
    
    func multiply(op1: Double, op2: Double) -> Double{
        return op1 * op2;
    }
    
    
    
    @IBAction func clear()
    {
        // Clear stack
        operandStack.removeAll(keepCapacity: false);
        
        // Clear display
        display.text = "\(0)";
        historyLbl.text = "";
        
        userIsInTheMiddleOfTypingANumber = false
    }
    
    @IBAction func appendDigit(sender: UIButton)
    {
        var digit = sender.currentTitle!
        
        // Validate floating points
        if(digit == "." && display.text!.rangeOfString(".") != nil) { return; }
        
        // Handle PI
        if(digit == "π")
        {
            // Clear the display
            display.text = ""
            
            // Make the digit equal to PI
            digit = "\(M_PI)"
        }
        
        
        if(userIsInTheMiddleOfTypingANumber)
        {
            display.text = display.text! + digit;
        }
        else {
            display.text = digit;
            userIsInTheMiddleOfTypingANumber = true;
        }
    }

    @IBAction func enter()
    {
        userIsInTheMiddleOfTypingANumber = false;
        
        operandStack.append(displayValue);
        
        if(historyLbl.text == nil || historyLbl.text == "")
        {
            historyLbl.text = "\(displayValue)"
        }
        else
        {
            historyLbl.text! += ", \(displayValue)"
        }
    }
    
    
}

