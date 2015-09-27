//
//  PersonViewController.swift
//  ispotyfest
//
//  Created by Raphael Haase on 2015-09-26.
//  Copyright © 2015 Spotyfest. All rights reserved.
//

import UIKit

class PersonViewController: UIViewController {
  
  var person: Person? {
    
    willSet {
      removeAllObservers()
    }
    
    didSet {
      let options = NSKeyValueObservingOptions([.New])
      person?.addObserver(self, forKeyPath: "name", options: options, context: nil)
      person?.addObserver(self, forKeyPath: "imageID", options: options, context: nil)
      person?.addObserver(self, forKeyPath: "location", options: options, context: nil)
      NSLog("New person for PersonViewController")
      updateAll()
    }
  }
  
  @IBOutlet var imageView: UIImageView?
  @IBOutlet var nameLabel: UILabel?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    updateAll()
  }
  
  private func removeAllObservers() {
    person?.removeObserver(self, forKeyPath: "name")
    person?.removeObserver(self, forKeyPath: "imageID")
    person?.removeObserver(self, forKeyPath: "location")
  }
  
  deinit {
    removeAllObservers()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func likePressed(sender: UIButton?) {
    // TODO
    if person?.imageID == "raphael" {
      NSLog("Raphael has a match!")
      
      let alertController = UIAlertController(title: "Match!", message: "Join Raphael at the Löwenbräu-Zelt at box 2, row 7, table 11. Raphael is expecting you and 1 more friend within the next 15 minutes.", preferredStyle: .Alert)
      
      let OKAction = UIAlertAction(title: "Cool!", style: .Default) { (action) in
        // ...
      }
      alertController.addAction(OKAction)
      
      self.presentViewController(alertController, animated: true) {
        // ...
      }

    }
    
    if person?.imageID == "lisa" {
      NSLog("Lisa has a match!")
      
      let alertController = UIAlertController(title: "Match!", message: "Lisa will join you with 1 more friend within the next 15 minutes.", preferredStyle: .Alert)
      
      let OKAction = UIAlertAction(title: "Cool!", style: .Default) { (action) in
        // ...
      }
      alertController.addAction(OKAction)
      
      self.presentViewController(alertController, animated: true) {
        // ...
      }
      
    }
  }
  
  @IBAction func nextPressed(sender: UIButton?) {
    // TODO
    
  }
  
  private func updateName() {
    NSLog("Updated person name")
    nameLabel?.text = person!.name
  }
  
  private func updateImage() {
    if person?.imageID != nil {
      switch (person!.imageID!) {
      case "raphael":
        let imageName = "dummyprofile.png"
        imageView?.image = UIImage(named: imageName)
      case "lisa":
        let imageName = "dummylisa.jpg"
        imageView?.image = UIImage(named: imageName)
      default:
        NSLog("Invalid imageID, can't show image.")
      }
    } else {
      NSLog("Invalid imageID, can't show image.")
    }
  }
  
  private func updateLocation() {
    // TODO
  }
  
  private func updateAll() {
    updateName()
    updateImage()
    updateLocation()
  }
  
  override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
    if person != nil && object === person! && keyPath != nil {
      switch (keyPath!) {
      case "name":
        updateName()
      case "location":
        updateLocation()
      case "imageID":
        updateImage()
      default:
        break
      }
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
