//
//  ScrollableViewController.swift
//  LemonadeHomeTransition
//
//  Created by Dang Quoc Huy on 4/21/17.
//  Copyright © 2017 Dang Quoc Huy. All rights reserved.
//

import UIKit

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
      let vc = storyboard.instantiateViewController(withIdentifier: "NavigationDrawerViewController")
      return vc
      
    case .home:
      let storyboard = UIStoryboard(name: "Main", bundle: nil)
      let vc = storyboard.instantiateViewController(withIdentifier: "HomeViewController")
      return vc
      
    case .notification:
      let storyboard = UIStoryboard(name: "Main", bundle: nil)
      let vc = storyboard.instantiateViewController(withIdentifier: "NotificationViewController")
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
      // Remove views that should not be visible anymore
      if (controllers[i].view.superview != nil && (i < fromIndex || i > toIndex)) {
        //print(NSString(format: "Hiding view controller at index: %i", i))
        controllers[i].willMove(toParentViewController: nil)
        controllers[i].view.removeFromSuperview()
        controllers[i].removeFromParentViewController()
      }
      
      // Add views that are now visible
      if (controllers[i].view.superview == nil && (i >= fromIndex && i <= toIndex)) {
        //print(NSString(format: "Showing view controller at index: %i", i))
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
    let fromIndex = floor(scrollView.bounds.origin.x  / scrollView.bounds.size.width)
    let toIndex = floor((scrollView.bounds.maxX - 1) / scrollView.bounds.size.width)
    let scrollProgress = 2 * (scrollView.contentOffset.x / (scrollView.contentSize.width - scrollView.frame.size.width))
    
    let toProgress = scrollProgress - fromIndex
    let fromProgress = 1 - toProgress
    
    layoutViewController(fromIndex: Int(fromIndex), toIndex: Int(toIndex))
  }
  
  func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    isDragging = true
  }
  
}
