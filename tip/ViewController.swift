//
//  ViewController.swift
//  tip
//
//  Created by Alex Shin on 12/12/20.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var tipControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // remember the app state for 10 minutes across app restarts (clears state if idle for 10 minutes and restart app)
        let defaults = UserDefaults.standard
        let lastOpenTime = defaults.object(forKey: "lastOpenTime") as! NSDate
        if NSDate().timeIntervalSince(lastOpenTime as Date) <= 600 {
            billField.text = defaults.string(forKey: "lastBillAmt")
            tipLabel.text = defaults.string(forKey: "lastTipAmt")
            tipControl.selectedSegmentIndex = defaults.integer(forKey: "lastSegCtrl")
            totalLabel.text = defaults.string(forKey: "lastTotalAmt")
        }
        
        // retrieve tip percentages from UserDefaults
        let tip1 = defaults.double(forKey: "custom1")
        let tip2 = defaults.double(forKey: "custom2")
        let tip3 = defaults.double(forKey: "custom3")
        
        // set segmented control titles from retrieved tip percentages
        tipControl.setTitle((String(Int(tip1)) + "%"), forSegmentAt: 0)
        tipControl.setTitle((String(Int(tip2)) + "%"), forSegmentAt: 1)
        tipControl.setTitle((String(Int(tip3)) + "%"), forSegmentAt: 2)
        
        // update the tip and total labels to reflect changed settings immediately
        let bill = Double(billField.text!) ?? 0
        
        var tip = bill
        if tipControl.selectedSegmentIndex == 0 {
            tip *= tip1/100
        }
        else if tipControl.selectedSegmentIndex == 1 {
            tip *= tip2/100
        }
        else {
            tip *= tip3/100
        }
        
        let total = bill + tip
        tipLabel.text = String(format: "$%.2f", tip)
        totalLabel.text = String(format: "$%.2f", total)
        
        // enable/disable dark mode by retrieving if darkmode switch was toggled on/off
        if defaults.bool(forKey: "darkMode") == true {
            view.overrideUserInterfaceStyle = .dark
        }
        else {
            view.overrideUserInterfaceStyle = .light
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // make keypad visible with bill textfield as first responder
        super.viewDidAppear(animated)
        billField.becomeFirstResponder()
    }

    @IBAction func onTap(_ sender: Any) {
        // dismiss decimal pad when user taps anywhere else on the screen
        view.endEditing(true)
    }
    
    @IBAction func calculateTip(_ sender: Any) {
        // get the bill amount
        let bill = Double(billField.text!) ?? 0
        
        // retrieve tip percentages from UserDefaults
        let defaults = UserDefaults.standard
        let tip1 = defaults.double(forKey: "custom1")
        let tip2 = defaults.double(forKey: "custom2")
        let tip3 = defaults.double(forKey: "custom3")
        
        // populate tip percentages accordingly
        let tipPercentages = [tip1/100, tip2/100, tip3/100]
        
        // calculate tip and total
        let tip = bill * tipPercentages[tipControl.selectedSegmentIndex]
        let total = bill + tip
        
        // update the tip and total labels
        tipLabel.text = String(format: "$%.2f", tip)
        totalLabel.text = String(format: "$%.2f", total)
        
        // store bill, tip, selectedSegmentIndex, total, and date for use to preserve app's state for 10 minutes
        defaults.set(billField.text, forKey: "lastBillAmt")
        defaults.set(tipLabel.text, forKey: "lastTipAmt")
        defaults.set(tipControl.selectedSegmentIndex, forKey: "lastSegCtrl")
        defaults.set(totalLabel.text, forKey: "lastTotalAmt")
        defaults.set(NSDate(), forKey: "lastOpenTime")
        defaults.synchronize()
    }
}
