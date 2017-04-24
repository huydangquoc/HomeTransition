//
//  NotificationView.swift
//  LemonadeHomeTransition
//
//  Created by Dang Quoc Huy on 4/14/17.
//  Copyright © 2017 Dang Quoc Huy. All rights reserved.
//

import UIKit
import Interpolate

class NotificationView: UIViewController {
  // Interpolations
  var isFrom: Bool!
  var index: Int!
  var viewFading: Interpolate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
}

// Interpolations
extension NotificationView: UIAnimateViewController {
  func setupInterpolationsTo() {
    viewFading = Interpolate(from: 0, to: 1, function: BasicInterpolation.easeIn, apply: { [weak self] (alpha) in
      self?.view.alpha = alpha
    })
  }
  func animateTo(progress: CGFloat) {
    viewFading?.progress = progress
  }
  func invalidateTo() {
    viewFading?.invalidate()
  }
  
  func setupInterpolationsFrom() {}
  func animateFrom(progress: CGFloat) {}
  func invalidateFrom() {}
}
