//
//  ViewController.swift
//  LemonadeHomeTransition
//
//  Created by Dang Quoc Huy on 4/14/17.
//  Copyright © 2017 Dang Quoc Huy. All rights reserved.
//

import UIKit
import Interpolate

class ViewController: UIViewController {
  @IBOutlet weak var leftButton: UIButton!
  @IBOutlet weak var rightButton: UIButton!
  @IBOutlet weak var bubblesView: UIView!
  @IBOutlet weak var compassIcon: UIImageView!
  @IBOutlet weak var carouselView: UIImageView!
  
  // Interpolations
  var isFrom: Bool!
  var index: Int!
  
  var bubblesViewFading: Interpolate?
  var leftButtonFading: Interpolate?
  var rightButtonFading: Interpolate?
  var compassIconFading: Interpolate?
  var carouselViewFading: Interpolate?
  var viewPosition: Interpolate?
  var carouselViewScale: Interpolate?
  var BubblesTransform: Interpolate?
  var compassTransform: Interpolate?
  
  // support
  var carouselRect: CGRect!
  var bubblesOriginalTransform: CGAffineTransform!
  var compassOriginalTransform: CGAffineTransform!
  var viewWidth: CGFloat!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view, typically from a nib.
    carouselRect = carouselView.frame
    bubblesOriginalTransform = bubblesView.transform
    compassOriginalTransform = compassIcon.transform
    viewWidth = view.bounds.size.width
  }
  
}

// Interpolations
extension ViewController: UIAnimateViewController {
  
  func setupInterpolationsTo() {
    commonSetupInterpolations()
    
    let endX = CGFloat(index) * viewWidth
    let startX = endX - viewWidth
    viewPosition = Interpolate(values: [startX, endX], apply: { [weak self] (x) in
      self?.view.frame.origin.x = x
    })
    
    compassTransform = Interpolate(from: CGFloat(0), to: CGFloat(1), apply: { [weak self] (factor) in
      var t = (self?.compassOriginalTransform)!.scaledBy(x: factor, y: factor)
      t = t.rotated(by: CGFloat.pi * -factor)
      self?.compassIcon.transform = t
    })
    
    BubblesTransform = Interpolate(from: CGFloat(0), to: CGFloat(1), function: BasicInterpolation.linear, apply: { [weak self] (scale) in
      var t = (self?.bubblesOriginalTransform)!.scaledBy(x: scale, y: scale)
      var deltaX = (self?.viewWidth)! * (1 - scale) * 2
      t = t.translatedBy(x: deltaX, y: 0)
      self?.bubblesView.transform = t
    })
  }
  
  func setupInterpolationsFrom() {
    commonSetupInterpolations()
    
    let startX = CGFloat(index + 1) * viewWidth
    let endX = startX - viewWidth
    viewPosition = Interpolate(values: [startX, endX], apply: { [weak self] (x) in
      self?.view.frame.origin.x = x
    })
    
    compassTransform = Interpolate(from: CGFloat(0), to: CGFloat(1), apply: { [weak self] (factor) in
      var t = (self?.compassOriginalTransform)!.scaledBy(x: factor, y: factor)
      t = t.rotated(by: CGFloat.pi * factor)
      self?.compassIcon.transform = t
    })
    
    BubblesTransform = Interpolate(from: CGFloat(0), to: CGFloat(1), function: BasicInterpolation.linear, apply: { [weak self] (scale) in
      var t = (self?.bubblesOriginalTransform)!.scaledBy(x: scale, y: scale)
      var deltaX = (self?.viewWidth)! * (1 - scale) * 2
      t = t.translatedBy(x: -deltaX, y: 0)
      self?.bubblesView.transform = t
    })
  }
  
  internal func commonSetupInterpolations() {
    bubblesViewFading = Interpolate(values: [0, 1], apply: { [weak self] (alpha) in
      self?.bubblesView.alpha = alpha
    })
    
    leftButtonFading = Interpolate(values: [0, 1], apply: { [weak self] (alpha) in
      self?.leftButton.alpha = alpha
    })
    
    rightButtonFading = Interpolate(values: [0, 1], apply: { [weak self] (alpha) in
      self?.rightButton.alpha = alpha
    })
    
    carouselViewFading = Interpolate(values: [0, 1], apply: { [weak self] (alpha) in
      self?.carouselView.alpha = alpha
    })
    
    compassIconFading = Interpolate(values: [0, 1], apply: { [weak self] (alpha) in
      self?.compassIcon.alpha = alpha
    })
    
    let fromRect = CGRect(x: carouselRect.origin.x + carouselRect.width / 2, y: carouselRect.origin.y + carouselRect.height / 2, width: 0, height: 0)
    carouselViewScale = Interpolate(from: fromRect, to: carouselRect, function: BasicInterpolation.easeIn, apply: { [weak self] (frame) in
      self?.carouselView.frame = frame
    })
    
  }
  
  func animateTo(progress: CGFloat) {
    commonAnimate(progress: progress)
  }
  
  func animateFrom(progress: CGFloat) {
    commonAnimate(progress: progress)
  }
  
  internal func commonAnimate(progress: CGFloat) {
    // middle of progress
    let progress2 = progress < 0.5 ? 0 : (progress - 0.5) * 2
    leftButtonFading?.progress = progress2
    rightButtonFading?.progress = progress2
    // 8/10 of progress
    let progress3 = progress < 0.2 ? 0 : (progress - 0.2) * 10 / 8
    carouselViewFading?.progress = progress3
    compassIconFading?.progress = progress3
    viewPosition?.progress = progress
    carouselViewScale?.progress = progress3
    bubblesViewFading?.progress = progress3
    BubblesTransform?.progress = progress
    compassTransform?.progress = progress3
  }
  
  func invalidateTo() {
  }
  
  func invalidateFrom() {
  }
}
