//
//  NavigationDrawerViewController.swift
//  LemonadeHomeTransition
//
//  Created by Dang Quoc Huy on 4/14/17.
//  Copyright © 2017 Dang Quoc Huy. All rights reserved.
//

import UIKit
import Interpolate

class NavigationDrawerViewController: UIViewController {
  // Interpolations
  var isFrom: Bool!
  var viewFading: Interpolate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
}

// Interpolations
extension NavigationDrawerViewController: UIAnimateViewController {
  func setupInterpolationsTo() {}
  func animateTo(progress: CGFloat) {}
  func invalidateTo() {}
  
  func setupInterpolationsFrom() {
    viewFading = Interpolate(values: [0, 1], apply: { [weak self] (alpha) in
      self?.view.alpha = alpha
    })
  }
  func animateFrom(progress: CGFloat) {
    viewFading?.progress = progress
  }
  func invalidateFrom() {
    viewFading?.invalidate()
  }
  
}
