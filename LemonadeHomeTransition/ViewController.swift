//
//  ViewController.swift
//  LemonadeHomeTransition
//
//  Created by Dang Quoc Huy on 4/14/17.
//  Copyright © 2017 Dang Quoc Huy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  @IBOutlet weak var leftButton: UIButton!
  @IBOutlet weak var rightButton: UIButton!
  @IBOutlet weak var bubblesView: UIView!
  @IBOutlet weak var compassIcon: UIImageView!
  @IBOutlet weak var carouselView: UIImageView!
  
  // Interpolations
  var isFrom: Bool!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }
  
}

// Interpolations
extension ViewController: UIAnimateViewController {
  func setupInterpolationsTo() {}
  func animateTo(progress: CGFloat) {}
  func invalidateTo() {}
  
  func setupInterpolationsFrom() {}
  func animateFrom(progress: CGFloat) {}
  func invalidateFrom() {}
}
