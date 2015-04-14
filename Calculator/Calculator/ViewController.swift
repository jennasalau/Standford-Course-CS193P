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
    @IBOutlet weak var display: UILabel!;
    
    var userIsInTheMiddleOfTypingANumber: Bool = false;
    
    
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
    
    
    @IBAction func appendDigit(sender: UIButton)
    {
        let digit = sender.currentTitle!;
        if(userIsInTheMiddleOfTypingANumber)
        {
            display.text = display.text! + digit;
        }
        else {
            display.text = digit;
            userIsInTheMiddleOfTypingANumber = true;
        }
        
        
        
        //println("digit = \(digit)")
    }

}

