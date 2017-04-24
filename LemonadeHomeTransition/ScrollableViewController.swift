//
//  ScrollableViewController.swift
//  LemonadeHomeTransition
//
//  Created by Dang Quoc Huy on 4/21/17.
//  Copyright © 2017 Dang Quoc Huy. All rights reserved.
//

import UIKit

protocol UIAnimateViewController {
  var isFrom: Bool! { get set }
  var index: Int! { get set }
  
  func setupInterpolationsFrom()
  func animateFrom(progress: CGFloat)
  func invalidateFrom()
  
  func setupInterpolationsTo()
  func animateTo(progress: CGFloat)
  func invalidateTo()
}

extension UIAnimateViewController {
  
  final func setupInterpolations(isFrom: Bool) {
    isFrom ? setupInterpolationsFrom() : setupInterpolationsTo()
  }
  
  final mutating func animate(progress: CGFloat, isFrom: Bool) {
    guard progress >= 0 && progress <= 1 else { return }
    
    if self.isFrom == nil {
      setupInterpolations(isFrom: isFrom)
    } else if isFrom != self.isFrom {
      invalidate(isFrom: self.isFrom)
      setupInterpolations(isFrom: isFrom)
    }
    self.isFrom = isFrom
    
    isFrom ? animateFrom(progress: progress) : animateTo(progress: progress)
    
    if progress == 1 {
      invalidate(isFrom: isFrom)
      self.isFrom = nil
    }
  }
  
  final func invalidate(isFrom: Bool) {
    isFrom ? invalidateFrom() : invalidateTo()
  }
  
}

internal enum Page {
  case navigationDrawer
  case home
  case notification
}

class ScrollableViewController: UIViewController {
  private let scrollView = UIScrollView()
  private(set) lazy var controllers: [UIViewController] = {
    return [self.newViewController(page: .navigationDrawer),
            self.newViewController(page: .home),
            self.newViewController(page: .notification)]
  }()
  internal var isDragging = false
  
  private func newViewController(page: Page) -> UIViewController {
    switch page {
    case .navigationDrawer:
      let storyboard = UIStoryboard(name: "Main", bundle: nil)
      let vc = storyboard.instantiateViewController(withIdentifier: "NavigationDrawerViewController") as! NavigationDrawerViewController
      vc.index = 0
      return vc
      
    case .home:
      let storyboard = UIStoryboard(name: "Main", bundle: nil)
      let vc = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! ViewController
      vc.index = 1
      return vc
      
    case .notification:
      let storyboard = UIStoryboard(name: "Main", bundle: nil)
      let vc = storyboard.instantiateViewController(withIdentifier: "NotificationViewController") as! NotificationView
      vc.index = 2
      return vc
    }
  }
  
  override func loadView() {
    self.automaticallyAdjustsScrollViewInsets = false
    scrollView.delegate = self
    scrollView.backgroundColor = UIColor.white
    scrollView.showsHorizontalScrollIndicator = true
    scrollView.decelerationRate = UIScrollViewDecelerationRateFast
    scrollView.isPagingEnabled = true
    self.view = scrollView
    
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Scroll", style: UIBarButtonItemStyle.plain, target: self, action: #selector(ScrollableViewController.didTapBarButton))
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    let width: CGFloat = CGFloat(controllers.count) * self.view.bounds.size.width
    scrollView.contentSize = CGSize(width: width, height: self.view.bounds.size.height)
    // show home view
    goTo(index: 1)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
  }
  
  func didTapBarButton() {
    // Scroll mid-view
    scrollView.setContentOffset(CGPoint(x: 1.5 * self.view.bounds.size.width, y: 0), animated: true)
  }
  
  func goTo(index: Int) {
    guard index >= 0 && index < controllers.count else { return }
    
    scrollView.setContentOffset(CGPoint(x: CGFloat(index) * self.view.bounds.size.width, y: 0), animated: true)
    layoutViewController(fromIndex: index, toIndex: index)
  }
  
  internal func layoutViewController(fromIndex: Int, toIndex: Int) {
    for i in 0 ..< controllers.count {
      // Add views that are now visible
      if (controllers[i].view.superview == nil && (i >= fromIndex && i <= toIndex)) {
        var viewFrame = self.view.bounds
        viewFrame.origin.x = CGFloat(i) * self.view.bounds.size.width
        controllers[i].view.frame = viewFrame        
        self.addChildViewController(controllers[i])
        scrollView.addSubview(controllers[i].view)
        controllers[i].didMove(toParentViewController: self)
      }
    }
  }
  
}

extension ScrollableViewController: UIScrollViewDelegate {
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let fromIndex = Int(floor(scrollView.bounds.origin.x  / scrollView.bounds.size.width))
    let toIndex = Int(floor((scrollView.bounds.maxX - 1) / scrollView.bounds.size.width))
    layoutViewController(fromIndex: Int(fromIndex), toIndex: Int(toIndex))
    
    guard fromIndex >= 0 else { return }
    guard toIndex < controllers.count else { return }
    guard var fromAnimateVC = controllers[fromIndex] as? UIAnimateViewController else { return }
    guard var toAnimateVC = controllers[toIndex] as? UIAnimateViewController else { return }
    
    let scrollProgress = 2 * (scrollView.contentOffset.x / (scrollView.contentSize.width - scrollView.frame.size.width))
    let toProgress = scrollProgress - CGFloat(fromIndex)
    let fromProgress = 1 - toProgress
    
    print(fromIndex, toIndex, fromProgress, toProgress)    
    
    if fromIndex == toIndex {
      fromAnimateVC.animate(progress: fromProgress, isFrom: true)
    } else {
      fromAnimateVC.animate(progress: fromProgress, isFrom: true)
      toAnimateVC.animate(progress: toProgress, isFrom: false)
    }
  }
  
  func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    isDragging = true
  }
  
  func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    isDragging = false
  }
  
}
