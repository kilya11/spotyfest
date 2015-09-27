//
//  OfferSpotViewController.swift
//  ispotyfest
//
//  Created by Raphael Haase on 2015-09-26.
//  Copyright © 2015 Spotyfest. All rights reserved.
//

import UIKit

class OfferSpotViewController: UIViewController {
  
  @IBOutlet var offerLabel: UILabel?
  @IBOutlet var segmentedControl: UISegmentedControl?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    segmentedControl!.frame = CGRect(x: segmentedControl!.frame.origin.x, y: segmentedControl!.frame.origin.y, width: segmentedControl!.frame.size.width, height: 100)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func sliderChanged(sender: UISlider?) {
    let newValue = Int(sender!.value * 8.0)
    offerLabel!.text = String(format: "I have %d free spots.", newValue)
  }
  
  @IBAction func offerPressed(sender: UIButton?) {
    let alertController = UIAlertController(title: "Offering", message: "Offering your seats for the next 15 minutes.", preferredStyle: .Alert)
    
    let OKAction = UIAlertAction(title: "Cool!", style: .Default) { (action) in
      // ...
    }
    alertController.addAction(OKAction)
    
    self.presentViewController(alertController, animated: true) {
      // ...
    }
  }

  
  /*
  // MARK: - Navigation
  
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
  // Get the new view controller using segue.destinationViewController.
  // Pass the selected object to the new view controller.
  }
  */
  
}
