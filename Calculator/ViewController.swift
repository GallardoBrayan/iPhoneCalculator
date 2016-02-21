//
//  ViewController.swift
//  Calculator
//
//  Created by Brayan Gallardo on 12/14/15.
//  Copyright © 2015 Brayan Gallardo. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    @IBOutlet weak var Display: UILabel!
    @IBOutlet weak var history: UILabel!
    private let defaultDisplayText = "0"
    
    var userIsInTheMiddleOfTypingANumber = false
    

    
    // Adds digits and also "."
    @IBAction func appendDigit(sender: UIButton) {
        history.text = history.text!.stringByReplacingOccurrencesOfString(" = ", withString: "")
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTypingANumber {
            if (digit == ".") && Display.text!.rangeOfString(".") != nil {
                return
            } else {
               Display.text = Display.text! + digit
            }
        } else {
            Display.text = digit
            userIsInTheMiddleOfTypingANumber = true
        }
    }

    
    @IBAction func clear(sender: UIButton) {
        userIsInTheMiddleOfTypingANumber = false
        operandStack = [Double]()
        history.text = " "
        Display.text = defaultDisplayText
    }
    

    
    @IBAction func plusMinus(sender: AnyObject) {
        if displayValue != nil && userIsInTheMiddleOfTypingANumber{
            Display.text = "\(displayValue! * -1)"
        } else {
            addHistory("+/-")
            performOperation { -$0 }
        }
    }
    
    // Backspace button
    @IBAction func backspace(sender: UIButton) {
        if Display.text!.characters.count > 1 {
            if userIsInTheMiddleOfTypingANumber {
            history.text = history.text! + " \(sender.currentTitle!) "
            Display.text = String(Display.text!.characters.dropLast())
            }
        } else {
            userIsInTheMiddleOfTypingANumber = false
            Display.text = "0"
        }
    }

    
    // Operators
    @IBAction func operate(sender: UIButton) {
        let operation = sender.currentTitle!
        if userIsInTheMiddleOfTypingANumber {
            addHistory(Display.text!)
            enter()
        }
        addHistory(" \(operation) ")
        addHistory(" = ")
        switch operation {
        case "×": performOperation { $0 * $1 }
        case "÷": performOperation { $1 / $0 }
        case "+": performOperation { $0 + $1 }
        case "−": performOperation { $1 - $0 }
        case "√": performOperation { sqrt($0) }
        case "sin": performOperation { sin($0) }
        case "cos": performOperation { cos($0) }
        case "π": displayValue = M_PI; enter()
        default: break
        }
    }
    
    private func performOperation(operation: Double -> Double) {
        if operandStack.count >= 1 {
            displayValue = operation(operandStack.removeLast())
            enter()
        }
    }
    
    private func performOperation(operation: (Double, Double) -> Double) {
        if operandStack.count >= 2 {
            displayValue = operation(operandStack.removeLast(), operandStack.removeLast())
            enter()
        }
    }

    var operandStack = [Double]()
    
    var displayValue: Double? {
        get {
            if let displayValue = NSNumberFormatter().numberFromString(Display.text!) {
                return displayValue.doubleValue
            } else {
                return nil
            }
        }
        set {
            if newValue != nil {
                Display.text = "\(newValue!)"
            } else {
                Display.text = defaultDisplayText
            }
        }
    }
    
    
    // Adds everything that is pressed on the calculator
    // to the "history" UI label
    func addHistory(value: String) {
        if (value != " = ") && (history.text!.rangeOfString(" = ") != nil) {
            history.text = history.text!.stringByReplacingOccurrencesOfString(" = ", withString: "")
        }
        history.text = history.text! + " " + value + " "
    }
    
    
    // Enter function exclusive to history

    @IBAction func enter(sender: UIButton) {
        addHistory(Display.text!)
        addHistory("⏎")
        enter()
        }
    

    
    // General enter function
    private func enter() {
        userIsInTheMiddleOfTypingANumber = false
        if displayValue != nil {
            operandStack.append(displayValue!)
            print("operandStack = \(operandStack)")
        }
    }
    
    
}

