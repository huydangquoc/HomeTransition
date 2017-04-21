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
  }
  
  override func animate(progress: CGFloat, isFrom: Bool) {
    print("NotificationView, progress: \(progress), direction: \(isFrom ? "left" : "right")")
  }
  
}
