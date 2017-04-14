//
//  ViewController.swift
//  LemonadeHomeTransition
//
//  Created by Dang Quoc Huy on 4/14/17.
//  Copyright © 2017 Dang Quoc Huy. All rights reserved.
//

import UIKit
import Hero

class ViewController: UIViewController {
  @IBOutlet weak var leftButton: UIButton!
  @IBOutlet weak var rightButton: UIButton!
  @IBOutlet weak var bubblesView: UIView!
  @IBOutlet weak var compassIcon: UIImageView!
  @IBOutlet weak var carouselView: UIImageView!

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    // prepare left swipe
    let swipeLeft: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipe))
    swipeLeft.direction = UISwipeGestureRecognizerDirection.left
    view.addGestureRecognizer(swipeLeft)
    // prepare right swipe
    let swipeRight: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipe))
    swipeRight.direction = UISwipeGestureRecognizerDirection.right
    view.addGestureRecognizer(swipeRight)
    
    setupTransition()
  }
  
  func setupTransition() {
    leftButton.heroID = "left"
    leftButton.heroModifiers = [.fade]
    
    rightButton.heroID = "right"
    rightButton.heroModifiers = [.fade]
    
    carouselView.heroID = "carousel"
    carouselView.heroModifiers = [.fade, .scale(0.5)]
    
    bubblesView.heroID = "bubbles"
    
    compassIcon.heroID = "compass"
    
    isHeroEnabled = true
  }
  
  func swipeLeftTransition() {
    bubblesView.heroModifiers = [.fade, .scale(0.5), .translate(CGPoint(x: -UIScreen.main.bounds.width, y: 0))]
    compassIcon.heroModifiers = [.fade, .scale(0.5), .rotate(CGFloat.pi / 2)]
  }
  
  func swipeRightTransition() {
    bubblesView.heroModifiers = [.fade, .scale(0.5), .translate(CGPoint(x: UIScreen.main.bounds.width, y: 0))]
    compassIcon.heroModifiers = [.fade, .scale(0.5), .rotate(-CGFloat.pi / 2)]
  }
  
  func swipe(sender: UISwipeGestureRecognizer) {
    switch sender.direction {
    case UISwipeGestureRecognizerDirection.right:
      swipeRightTransition()
      performSegue(withIdentifier: "notifSegue", sender: nil)
    case UISwipeGestureRecognizerDirection.left:
      swipeLeftTransition()
      performSegue(withIdentifier: "navDrawerSegue", sender: nil)
    default:
      break
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "navDrawerSegue" {
      segue.destination.isHeroEnabled = true
      //segue.destination.heroModalAnimationType = .selectBy(presenting: .push(direction: .left), dismissing: .push(direction: .right))
    } else if segue.identifier == "notifSegue" {
      segue.destination.isHeroEnabled = true
      //segue.destination.heroModalAnimationType = .selectBy(presenting: .push(direction: .right), dismissing: .push(direction: .left))
    }
  }
  
  @IBAction func unwindToHome(s: UIStoryboardSegue) {
    if let navVC = s.source as? NavigationDrawerViewController {
      navVC.hero_dismissViewController()
    } else if let notifVC = s.source as? NotificationView {
      notifVC.hero_dismissViewController()
    }
  }

}

//      let transition: CATransition = CATransition()
//      transition.duration = 0.25
//      transition.type = kCATransitionReveal
//      transition.subtype = kCATransitionFromRight
//      navVC.view.window!.layer.add(transition, forKey: nil)

//        let transition: CATransition = CATransition()
//        transition.duration = 0.25
//        transition.type = kCATransitionReveal
//        transition.subtype = kCATransitionFromLeft
//        notifVC.view.window!.layer.add(transition, forKey: nil)
