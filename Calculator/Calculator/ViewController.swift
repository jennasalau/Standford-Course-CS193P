//
//  ViewController.swift
//  Calculator
//
//  Created by Jenna Salau on 14/04/2015.
//  Copyright (c) 2015 Jenna Salau. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    /*
    *   Properties
    *   =================================================================
    */
    
    @IBOutlet
    weak var display: UILabel!;
    
    @IBOutlet
    weak var historyLbl: UILabel!;
    
    private var userIsInTheMiddleOfTypingANumber = false;
    
    var brain = CalculatorBrain()
    
    internal var displayValue: Double {
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
    
    override
    func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override
    func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    *   Methods
    *   =================================================================
    */
    
    @IBAction
    func operate(sender: UIButton) {
        
        if(userIsInTheMiddleOfTypingANumber)
        {
            enter();
        }
        
        if let operation = sender.currentTitle {
            if let result = brain.performOperation(operation){
                displayValue = result
            }
            else
            {
                displayValue = 0
            }
        }
    }
    
    @IBAction
    func clear()
    {
        // Clear stack
        
        
        // Clear display
        display.text = "\(0)";
        historyLbl.text = "";
        
        userIsInTheMiddleOfTypingANumber = false
    }
    
    @IBAction
    func appendDigit(sender: UIButton)
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

    @IBAction
    func enter()
    {
        userIsInTheMiddleOfTypingANumber = false;
        
        if let result = brain.pushOperand(displayValue)
        {
            displayValue = result
        }
        else
        {
            //TODO: Handle nil (ie make displayValue an optional)
            displayValue = 0 //displayValue = nil
        }
        
        
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

