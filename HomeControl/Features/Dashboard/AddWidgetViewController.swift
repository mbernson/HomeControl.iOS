//
//  AddWidgetViewController.swift
//  HomeControl
//
//  Created by Mathijs Bernson on 04/05/16.
//  Copyright © 2016 Duckson. All rights reserved.
//

import UIKit

class AddWidgetViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  @IBAction func cancelButtonPressed(sender: AnyObject) {
    self.dismissViewControllerAnimated(true, completion: nil)
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
