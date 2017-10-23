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
    @IBOutlet weak var divideBtn: UIButton!
    @IBOutlet weak var multipleBtn: UIButton!
    @IBOutlet weak var substractBtn: UIButton!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var countBtn: UIButton!
    @IBOutlet weak var avgBtn: UIButton!
    @IBOutlet weak var factBtn: UIButton!
    @IBOutlet weak var modBtn: UIButton!
    @IBOutlet weak var zeroBtn: UIButton!
    @IBOutlet weak var oneBtn: UIButton!
    @IBOutlet weak var twoBtn: UIButton!
    @IBOutlet weak var threeBtn: UIButton!
    @IBOutlet weak var fourBtn: UIButton!
    @IBOutlet weak var fiveBtn: UIButton!
    @IBOutlet weak var sixBtn: UIButton!
    @IBOutlet weak var sevenBtn: UIButton!
    @IBOutlet weak var eightBtn: UIButton!
    @IBOutlet weak var nineBtn: UIButton!
    @IBOutlet weak var dotBtn: UIButton!
    @IBOutlet weak var equalBtn: UIButton!

    // Labels
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var processLabel: UILabel!
    
    // Mode Switch
    @IBOutlet weak var modeSwitch: UISegmentedControl!
    
    // Button Collection
    @IBOutlet var numBtns: [UIButton]!
    
    // Variables
    var preNum:String = ""
    var nextNum:Bool = true
    var calculation:String = ""
    var RPNMode:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        for view in self.view.subviews as [UIView] {
            // Make all the buttons circle
            if let btn = view as? UIButton {
                btn.layer.cornerRadius = btn.bounds.size.width / 2
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // When number buttons are touched
    @IBAction func onTouchUp(_ button: UIButton) {
        if ((resultLabel.text == "0" || nextNum)
            && button.titleLabel?.text! != "・") {
            resultLabel.text = button.titleLabel!.text!
            nextNum = false
        } else if (button.titleLabel?.text! == "・") {
            nextNum = false
            resultLabel.text! += "."
        } else {
            resultLabel.text! += button.titleLabel!.text!
        }
    }
    
    @IBAction func calculation(_ sender: UIButton) {
        preNum = resultLabel.text!
        nextNum = true
        calculation = (sender.titleLabel?.text)!
    }
    
    @IBAction func calcResult(_ sender: UIButton) {
        let availbleCalculations = ["+", "-", "x", "/", "%"]
        if (availbleCalculations.contains(calculation)
            && preNum != "") {
            switch calculation {
            case "+":
                let result = Double(resultLabel.text!)! + Double(preNum)!
                resultLabel.text = String(result)
            case "-":
                let result = Double(resultLabel.text!)! - Double(preNum)!
                resultLabel.text = String(result)
            case "x":
                let result = Double(resultLabel.text!)! * Double(preNum)!
                resultLabel.text = String(result)
            case "/":
                let result = Double(resultLabel.text!)! / Double(preNum)!
                resultLabel.text = String(result)
            default:    // case "%"
                if (isInt(preNum, resultLabel.text!)) {
                    // if both numbers are integers
                    let result = Int(preNum)! % Int(resultLabel.text!)!
                    resultLabel.text = String(result)
                } else {
                    resultLabel.text = "Error"
                }
            }
        }
        preNum = ""
        nextNum = true
    }
    
    func isInt(_ num1:String, _ num2:String) -> Bool {
        return Int(num1) == Int(Double(num1)!)
            && Int(num2) == Int(Double(num2)!)
    }
}

