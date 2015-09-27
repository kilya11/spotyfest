//
//  PeopleViewController
//  ispotyfest
//
//  Created by Raphael Haase on 2015-09-26.
//  Copyright © 2015 Spotyfest. All rights reserved.
//

import UIKit
import CoreData

class PeopleViewController: UIPageViewController {
  
  private var magicDataSource: PeopleViewControllerDataSource?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    magicDataSource = PeopleViewControllerDataSource()
    dataSource = magicDataSource!
    
    let firstViewController = magicDataSource!.viewControllerAtIndex(0)
    if firstViewController != nil {
      self.setViewControllers([firstViewController!], direction: .Forward, animated: false, completion: nil)
    } else {
      // TODO Display nothing to show right now
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
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

class PeopleViewControllerDataSource: NSObject, UIPageViewControllerDataSource {
  
  private func fetchPersons() -> [Person]? {
    let fetchRequest = NSFetchRequest()
    let context = SharedAppDelegate().managedObjectContext
    fetchRequest.entity = NSEntityDescription.entityForName("Person", inManagedObjectContext: context)
    // Sort chronologically beginning with the earliest time.
    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "activeSince", ascending: true)]

    do {
      let result = try context.executeFetchRequest(fetchRequest) as? [Person]
      
      if result != nil {
        return result!
      }
    } catch {
      NSLog("Error fetching persons.")
    }
    return nil
  }
  
  private func viewControllerAtIndex(index: Int) -> PersonViewController? {
    let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main",bundle: nil)
    let newVC = mainStoryboard.instantiateViewControllerWithIdentifier("PersonViewController") as! PersonViewController
    
    let persons = fetchPersons()
    if persons != nil {
      newVC.person = persons![index]
      return newVC
    } else {
      return nil
    }
  }
  
  func pageViewController(_pageViewController: UIPageViewController,
    viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
      let persons = fetchPersons()
      
      if persons != nil {
        let oldPerson = (viewController as! PersonViewController).person
        if oldPerson != nil {
          let oldIndex = persons!.indexOf(oldPerson!)
          
          if oldIndex != nil {
            let newIndex = oldIndex!-1
            if newIndex >= 0 {
              return viewControllerAtIndex(newIndex)
            } else {
              NSLog("No new pageViewController")
              return nil
            }
          } else {
            NSLog("No new pageViewController")
            return nil
          }
        } else {
          NSLog("No new pageViewController")
          return nil
        }
      } else {
        NSLog("No new pageViewController")
        return nil
      }
  }

  
  func pageViewController(_pageViewController: UIPageViewController,
    viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
      let persons = fetchPersons()
      
      if persons != nil {
        let oldPerson = (viewController as! PersonViewController).person
        if oldPerson != nil {
          let oldIndex = persons!.indexOf(oldPerson!)
          
          if oldIndex != nil {
            let newIndex = oldIndex!+1
            if newIndex <= persons!.count-1 {
              return viewControllerAtIndex(newIndex)
            } else {
              NSLog("No new pageViewController")
              return nil
            }
          } else {
            NSLog("No new pageViewController")
            return nil
          }
        } else {
          NSLog("No new pageViewController")
          return nil
        }
      } else {
        NSLog("No new pageViewController")
        return nil
      }
  }
  
  func presentationCountForPageViewController(_ pageViewController: UIPageViewController) -> Int {
    let persons = fetchPersons()
    if persons != nil {
      NSLog("Number of people available: %d.", persons!.count)
      return persons!.count
    } else {
      return 0
    }
  }
  
  func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int
  {
    return 0
  }
  
}