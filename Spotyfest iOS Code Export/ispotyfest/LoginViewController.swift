//
//  ViewController.swift
//  ispotyfest
//
//  Created by Raphael Haase on 2015-09-26.
//  Copyright © 2015 Spotyfest. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
  
  @IBOutlet var emailField: UITextField?

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    // 62 168 229
    self.navigationController!.navigationBar.barTintColor = UIColor(red: 62.0/255.0, green: 168.0/255.0, blue: 229.0/255.0, alpha: 1.0)
    
    self.navigationController!.navigationBar.tintColor = UIColor.whiteColor() // for titles, buttons, etc.
    
    //let navigationTitleFont = UIFont(name: "Avenir", size: 20)!
    //self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: navigationTitleFont]
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func emailChanged(sender: UITextField?) {
    SharedAppDelegate().appState?.person?.email = sender?.text
  }


}

