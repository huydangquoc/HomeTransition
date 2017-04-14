//
//  NotificationView.swift
//  LemonadeHomeTransition
//
//  Created by Dang Quoc Huy on 4/14/17.
//  Copyright © 2017 Dang Quoc Huy. All rights reserved.
//

import UIKit

class NotificationView: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // my tricky way, this should be control by a flag
    view.heroModifiers = [.fade, .translate(x: 2 * UIScreen.main.bounds.width)]
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destinationViewController.
   // Pass the selected object to the new view controller.
   }
   */
  
}
