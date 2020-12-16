//
//  SettingsViewController.swift
//  tip
//
//  Created by Alex Shin on 12/12/20.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var custom1Field: UITextField!
    @IBOutlet weak var custom2Field: UITextField!
    @IBOutlet weak var custom3Field: UITextField!
    @IBOutlet weak var darkmodeSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // retrieve most recent tip percentages to populate custom tip % text fields
        let defaults = UserDefaults.standard
        
        let tip1 = defaults.double(forKey: "custom1")
        let tip2 = defaults.double(forKey: "custom2")
        let tip3 = defaults.double(forKey: "custom3")
        
        custom1Field.text = String(Int(tip1))
        custom2Field.text = String(Int(tip2))
        custom3Field.text = String(Int(tip3))
        
        // enable/disable dark mode by retrieving if darkmode switch was toggled on/off
        if defaults.bool(forKey: "darkMode") == true {
            // set switch to on state
            darkmodeSwitch.setOn(true, animated: true)
            view.overrideUserInterfaceStyle = .dark
        }
        else {
            view.overrideUserInterfaceStyle = .light
        }
    }
    
    @IBAction func onTap(_ sender: Any) {
        // dismiss decimal pad when user taps anywhere else on the screen
        view.endEditing(true)
    }
    
    @IBAction func customField(_ sender: Any) {
        // store changed tip percentages in UserDefaults
        let tip1 = Double(custom1Field.text!)
        let tip2 = Double(custom2Field.text!)
        let tip3 = Double(custom3Field.text!)

        let defaults = UserDefaults.standard
        defaults.set(tip1, forKey: "custom1")
        defaults.set(tip2, forKey: "custom2")
        defaults.set(tip3, forKey: "custom3")
        defaults.synchronize()
    }
    
    @IBAction func toggleDarkmode(_ sender: Any) {
        // check if darkmodeSwitch is on/off and store the information
        var switchStatus = false
        if darkmodeSwitch.isOn {
            switchStatus = true
        }
        else {
            switchStatus = false
        }
        
        let defaults = UserDefaults.standard
        defaults.set(switchStatus, forKey: "darkMode")
        defaults.synchronize()
        
        // immediately enable/disable dark mode by retrieving if darkmode switch is toggled on/off
        if defaults.bool(forKey: "darkMode") == true {
            view.overrideUserInterfaceStyle = .dark
        }
        else {
            view.overrideUserInterfaceStyle = .light
        }
    }
}
