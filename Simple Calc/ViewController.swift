//
//  ViewController.swift
//  Simple Calc
//
//  Created by Student User on 10/20/17.
//  Copyright © 2017 Nestor Qin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    // Buttons
    @IBOutlet weak var equalBtn: UIButton!
    @IBOutlet weak var modeSwitch: UISegmentedControl!
    @IBOutlet weak var negationBtn: UIButton!
    @IBOutlet weak var clearBtn: UIButton!

    // Labels
    @IBOutlet weak var resultLabel: UILabel!
    
    // Variables
    var preNum:String = ""
    var nextNum:Bool = true // if the next input is a new number
    var operation:String = ""
    var RPNMode:Int = 0
    var fullValue:String = "0"
    var extraOperations:Bool = false
    var mode:Int = 0    // 0: Transition Mode 1: RPN Mode
    var numbers = [Double]()
    var pressAnyOtherKey:Bool = false
    var pressedNum = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        for view in self.view.subviews as [UIView] {
            // Make all the buttons circle
            if let btn = view as? UIButton {
                btn.layer.cornerRadius = btn.bounds.size.width / 2
            }
        }
        clearBtn.layer.cornerRadius = 8
        negationBtn.layer.cornerRadius = 8
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // When number buttons are touched
    @IBAction func onTouchUp(_ button: UIButton) {
        pressAnyOtherKey = true
        pressedNum = true
        if ((nextNum && button.titleLabel?.text! != "・") ||
            resultLabel.text! == "Error") {
            fullValue = button.titleLabel!.text!
            resultLabel.text = button.titleLabel!.text!
            nextNum = false
        } else if (button.titleLabel!.text! == "・") {
            nextNum = false
            fullValue += "."
            if (fullValue.count > 8) {
                resultLabel.text = ""
                for char in fullValue.suffix(8) {
                    resultLabel.text?.append(char)
                }
            } else {
                resultLabel.text = fullValue
            }
        } else {
            nextNum = false
            fullValue += button.titleLabel!.text!
            if (fullValue.count > 8) {
                resultLabel.text = ""
                for char in fullValue.suffix(8) {
                    resultLabel.text?.append(char)
                }
            } else {
                resultLabel.text = fullValue
            }
        }
    }
    
    @IBAction func calculation(_ sender: UIButton) {
        pressAnyOtherKey = true
        if (mode == 0) {
            if (pressedNum) {
                switch sender.titleLabel!.text! {
                case "+", "-", "x", "/", "%":
                    if (!extraOperations) { // if it's not doing extra operations now
                        if (preNum != "" && operation != "" && fullValue != ""
                            && pressAnyOtherKey) {
                            switch operation {
                            case "+":
                                resultLabel.text = "\(Double(preNum)! + Double(fullValue)!)"
                            case "-":
                                resultLabel.text = "\(Double(preNum)! - Double(fullValue)!)"
                            case "x":
                                resultLabel.text = "\(Double(preNum)! * Double(fullValue)!)"
                            case "/":
                                resultLabel.text = "\(Double(preNum)! / Double(fullValue)!)"
                            case "%":
                                resultLabel.text = "\(Double(preNum)!.truncatingRemainder(dividingBy: Double(resultLabel.text!)!))"
                            default:
                                resultLabel.text = "Error"
                            }
                            if (equalsInt(Double(resultLabel.text!)!)) {
                                fullValue = String(Int(Double(resultLabel.text!)!))
                                resultLabel.text = String(Int(Double(resultLabel.text!)!))
                            } else {
                                fullValue = String(Double(resultLabel.text!)!)
                                resultLabel.text = fullValue
                            }
                        }
                        preNum = fullValue
                        nextNum = true
                        operation = sender.titleLabel!.text!
                    }
                case "Count", "Avg", "Fact":
                    extraOperations = true
                    if (operation == "" || operation == sender.titleLabel!.text!) {
                        numbers.append(Double(fullValue)!)
                        operation = sender.titleLabel!.text!
                        nextNum = true
                    } else {
                        resultLabel.text = "Error"
                    }
                default:
                    resultLabel.text = "Error"
                }
            }
        } else {    // mode == 1
            numbers.append(Double(fullValue)!)
            
            switch sender.titleLabel!.text! {
            case "+":
                var sum = 0.0
                if (numbers.count > 1) {
                    for num in numbers {
                        sum += num
                    }
                }
                if (equalsInt(sum)) {
                    resultLabel.text = "\(Int(Double(sum)))"
                } else {
                    resultLabel.text = "\(Double(sum))"
                }
            case "-":
                var sum = numbers[0]
                if (numbers.count > 1) {
                    for index in 1...(numbers.count - 1) {
                        sum -= numbers[index]
                    }
                }
                if (equalsInt(sum)) {
                    resultLabel.text = "\(Int(Double(sum)))"
                } else {
                    resultLabel.text = "\(Double(sum))"
                }
            case "x":
                var result = 1.0
                if (numbers.count > 1) {
                    for num in numbers {
                        result *= num
                    }
                }
                if (equalsInt(result)) {
                    resultLabel.text = "\(Int(Double(result)))"
                } else {
                    resultLabel.text = "\(Double(result))"
                }
            case "/":
                var result = numbers[0]
                if (numbers.count > 1) {
                    for index in 1...(numbers.count - 1) {
                        result /= numbers[index]
                    }
                }
                if (equalsInt(result)) {
                    resultLabel.text = "\(Int(Double(result)))"
                } else {
                    resultLabel.text = "\(Double(result))"
                }
            case "%":
                var result = numbers[0]
                if (numbers.count > 1) {
                    for index in 1...(numbers.count - 1) {
                        result = result.truncatingRemainder(dividingBy: numbers[index])
                    }
                }
                if (equalsInt(result)) {
                    resultLabel.text = "\(Int(result))"
                } else {
                    resultLabel.text = "\(result)"
                }
            case "Count":
                NSLog("\(numbers)")
                resultLabel.text = "\(numbers.count)"
            case "Avg":
                var sum = 0.0
                for num in numbers {
                    sum += num
                }
                let result = sum / Double(numbers.count)
                if (equalsInt(result)) {
                    resultLabel.text = "\(Int(result))"
                } else {
                    resultLabel.text = "\(result)"
                }
            default:
                resultLabel.text = "Error"
            }
            numbers.removeAll()
            nextNum = true
        }
        pressedNum = false
    }
    
    @IBAction func calcResult(_ sender: UIButton) {
        NSLog("\(preNum) \(operation) \(fullValue)")
        if (mode == 0 && (operation == "") ||
            (["+", "-", "*", "/", "%"].contains(operation) && preNum == "")) {
            resultLabel.text = fullValue
        } else if (mode == 0) {
            let normalCalculations = ["+", "-", "x", "/", "%"]
            if (normalCalculations.contains(operation)
                && preNum != "") {
                switch operation {
                case "+":
                    resultLabel.text = "\(Double(preNum)! + Double(fullValue)!)"
                case "-":
                    resultLabel.text = "\(Double(preNum)! - Double(fullValue)!)"
                case "x":
                    resultLabel.text = "\(Double(preNum)! * Double(fullValue)!)"
                case "/":
                    resultLabel.text = "\(Double(preNum)! / Double(fullValue)!)"
                case "%":
                    resultLabel.text = "\(Double(preNum)!.truncatingRemainder(dividingBy: Double(resultLabel.text!)!))"
                default:
                    resultLabel.text = "Error"
                }
                if (pressAnyOtherKey) {
                    preNum = fullValue
                }
                if (equalsInt(Double(resultLabel.text!)!)) {
                    fullValue = String(Int(Double(resultLabel.text!)!))
                    resultLabel.text = String(Int(Double(resultLabel.text!)!))
                } else {
                    fullValue = String(Double(resultLabel.text!)!)
                    resultLabel.text = fullValue
                }
                preNum = ""
            } else {    // extra operators
                if (pressedNum) {
                    numbers.append(Double(fullValue)!)
                }
                switch operation {
                case "Count":
                    resultLabel.text = "\(numbers.count)"
                case "Avg":
                    var sum:Double = 0.0
                    for num in numbers {
                        sum += num
                    }
                    let result:Double = sum / Double(numbers.count)
                    if (equalsInt(result)) {
                        resultLabel.text = "\(Int(result))"
                    } else {
                        resultLabel.text = "\(result)"
                    }
                default:
                    resultLabel.text = "Error"
                }
                numbers.removeAll()
                operation = ""
            }
            pressAnyOtherKey = false
        } else if (sender.titleLabel!.text == "->") {    // mode == 1
            numbers.append(Double(fullValue)!)
        }
        nextNum = true
        pressedNum = false
        extraOperations = false
    }
    
    @IBAction func clear(_ sender: UIButton) {
        pressAnyOtherKey = true
        resultLabel.text = "0"
        fullValue = "0"
        operation = ""
        numbers.removeAll()
        nextNum = true
    }
    
    @IBAction func factorial(_ sender: UIButton) {
        pressAnyOtherKey = true
        if (isPositiveInt(fullValue)) {
            var result:Int = 1;
            for multiple in 2...Int(fullValue)! {
                result *= multiple
            }
            resultLabel.text = "\(result)"
            nextNum = true
        } else {
            resultLabel.text = "Error"
        }
    }
    
    @IBAction func changeMode(_ sender: UISegmentedControl) {
        mode = sender.selectedSegmentIndex
        NSLog(String(mode))
        resultLabel.text = "0"
        numbers.removeAll()
        preNum = ""
        fullValue = "0"
        operation = ""
        nextNum = true
        if (mode == 1) {
            equalBtn.setTitle("->", for: .normal)
        } else {
            equalBtn.setTitle("=", for: .normal)
        }
    }
    
    @IBAction func negation(_ sender: UIButton) {
        NSLog("\(resultLabel.text!)")
        NSLog("\(fullValue)")
        if (isNum(fullValue) && isNum(resultLabel.text!)) {
            NSLog("\(Double(resultLabel.text!)!)")
            NSLog("\(fullValue)")
            NSLog("\(resultLabel.text!)")
            let temp = -1.0 * Double(resultLabel.text!)!
            fullValue = "\(-1 * Double(fullValue)!)"
            if (equalsInt(temp)) {
                resultLabel.text = "\(Int(temp))"
            } else {
                resultLabel.text = "\(temp)"
            }
        }
    }
    
    
    func isInt(_ str:String) -> Bool {
        return str.range(of: "^-?[0-9]+$", options: .regularExpression) != nil
    }
    
    func isNum(_ str:String) -> Bool {
        return str.range(of: "^-?[0-9]+([\\.][0-9]+)?$", options: .regularExpression) != nil
    }
    
    func isPositiveInt(_ str:String) -> Bool {
        return str.range(of: "^[1-9]+[[0-9]+]?$", options: .regularExpression) != nil
    }
    
    func equalsInt(_ num:Double) -> Bool {
        return Double(Int(num)) == num
    }
}

