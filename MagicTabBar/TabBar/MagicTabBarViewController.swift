//
//  MagicTabBarViewController.swift
//  MagicTabBar
//
//  Created by Dhruvik Dhanani on 30/08/20.
//  Copyright © 2020 Dhruvik Dhanani. All rights reserved.
//

import UIKit

class MagicTabBarViewController: UITabBarController, UITabBarControllerDelegate {
  
  var magicTab:[TabItem] = [TabItem]()
  
  convenience init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, magicData:[TabItem]) {
    self.init(nibName: nibNameOrNil, bundle: nil)
    self.magicTab = magicData
    self.viewControllers = setTab()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture))
    swipeLeft.direction = .left
    self.tabBar.addGestureRecognizer(swipeLeft)
    delegate = self
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    let bottomPadding = view.safeAreaInsets.bottom
    tabBar.frame.size.height = 80 + bottomPadding
    tabBar.frame.origin.y = view.frame.height - (80 + bottomPadding)
    tabBar.backgroundColor = .white
    tabBar.cornerRound(RoundingCorners: [.topLeft,.topRight], radius: 40)
  }
  
  func setTab() -> [UIViewController] {
    if getFinalArray().count == 0 {
      var vc: [UIViewController] = []
      for tab in magicTab {
        if vc.count != 4 {
          vc.append(tab.storyboardName)
        }
      }
      return vc
    } else {
      var settedVC: [UIViewController] = []
      for tab in getFinalArray() {
        if let tabFinal = magicTab.filter({$0.image==tab}).first {
          settedVC.append(tabFinal.storyboardName)
        }
      }
      return settedVC
    }
  }
  
  @objc func handleSwipeGesture(_ gesture: UISwipeGestureRecognizer) {
    if gesture.direction == .left {
      let custom:CustomizeView = UIView.fromNib()
      custom.frame = CGRect(x: 0, y: tabBar.frame.origin.y, width: screenWidth, height: 80 + view.safeAreaInsets.bottom)
      custom.reloadData(magicTab.map{$0.image})
      self.show(custom)
      UIView.animate(withDuration: 0.5, animations: { [weak self] in
        custom.leadingOfBottomCollectionView.constant = -(0.25 * screenWidth)
        custom.trailingOfBottomCollectionView.constant = 0.25 * screenWidth
        self?.view.layoutIfNeeded()
      }) { [weak self] (_) in
        custom.addMenuCollectionView.contentInset = UIEdgeInsets(top: 0, left: (0.25*screenWidth), bottom: 0, right: 0)
        self?.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn,
                       animations: { [weak self] in
                        custom.frame = CGRect(x: 0, y: screenHeight-(256+self!.view.safeAreaInsets.bottom), width: screenWidth, height: 256 + self!.view.safeAreaInsets.bottom)
                        custom.setHeight(height: 256+self!.view.safeAreaInsets.bottom)
                        custom.viewWithTag(2020)?.alpha = 1
                        custom.heightOfUpperView.constant = 176
                        self?.view.layoutIfNeeded()
        })
      }
      
      /// Done Action
      custom.doneAction = { [weak self] (data) in
        self?.viewControllers = self?.setTab()
        UIView.animate(withDuration: 0.5, animations: { [weak self] in
          custom.viewWithTag(2020)?.alpha = 0
          custom.heightOfUpperView.constant = 0
          self?.view.layoutIfNeeded()
        }) {[weak self] (_) in
          custom.frame = CGRect(x: 0, y: self!.tabBar.frame.origin.y, width: screenWidth, height: 80 + self!.view.safeAreaInsets.bottom)
          custom.setHeight(height: 80 + self!.view.safeAreaInsets.bottom)
          self?.view.layoutIfNeeded()
          UIView.animate(withDuration: 0.5, animations: {[weak self] in
            custom.trailingOfBottomCollectionView.constant = 0
            custom.leadingOfBottomCollectionView.constant = 0
            custom.addMenuCollectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            self?.view.layoutIfNeeded()
          }) { [weak self] (_) in
            self?.dismissView()
          }
        }
      }
      
    }
  }
  
  func show(_ maskView:UIView) {
    if var topController = UIApplication.shared.keyWindowInConnectedScenes?.rootViewController {
      while let presentedViewController = topController.presentedViewController {
        topController = presentedViewController
      }
      topController.view.addSubview(maskView)
    }
  }
  
  func dismissView() {
    if var topController = UIApplication.shared.keyWindowInConnectedScenes?.rootViewController {
      while let presentedViewController = topController.presentedViewController {
        topController = presentedViewController
      }
      if let theMask = topController.view.viewWithTag(666) {
        theMask.removeFromSuperview()
      }
    }
  }
  
}

class TabItem {
  var storyboardName: UIViewController!
  var image: String!
  var selectedImage: UIImage?
  var tabName:String?
  
  init(_ storyboardName: UIViewController, imageName: String, selectedImage: UIImage? = nil , tabName: String?) {
    self.storyboardName = storyboardName
    self.image = imageName
    self.selectedImage = selectedImage
    self.tabName = tabName
    storyboardName.tabBarItem = UITabBarItem(title: tabName, image: UIImage(named: imageName), selectedImage: selectedImage)
  }
}

let FINAL_ARRAY = "FINAL_ARRAY"
let ADDITIONAL_ARRAY = "ADDITIONAL_ARRAY"

extension UIView {
  
  var parentViewController: UIViewController? {
     var parentResponder: UIResponder? = self
     while parentResponder != nil {
       parentResponder = parentResponder!.next
       if let viewController = parentResponder as? UIViewController {
         return viewController
       }
     }
     return nil
   }
  
  func cornerRound(radius: CGFloat) -> Void {
    self.layer.cornerRadius = radius
    self.layer.masksToBounds = true
  }
  
  func cornerRound(RoundingCorners corners: UIRectCorner, radius: CGFloat) -> Void {
    let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
    let mask = CAShapeLayer()
    mask.path = path.cgPath
    self.layer.mask = mask
  }
  
  static var reuseIdentifier: String {
    return String(describing: self)
  }
  
  class func fromNib<T: UIView>() -> T {
    return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
  }
  
  func setX(x:CGFloat) {
    var frame:CGRect = self.frame
    frame.origin.x = x
    self.frame = frame
  }
  
  func setY(y:CGFloat) {
    var frame:CGRect = self.frame
    frame.origin.y = y
    self.frame = frame
  }
  
  func setWidth(width:CGFloat) {
    var frame:CGRect = self.frame
    frame.size.width = width
    self.frame = frame
  }
  
  func setHeight(height:CGFloat) {
    var frame:CGRect = self.frame
    frame.size.height = height
    self.frame = frame
  }
  
}

// Screen width.
public var screenWidth: CGFloat {
  return UIScreen.main.bounds.width
}

// Screen height.
public var screenHeight: CGFloat {
  return UIScreen.main.bounds.height
}

public func setFinalArray(_ array: [String]) {
  UserDefaults.standard.set(array, forKey: FINAL_ARRAY)
  UserDefaults.standard.synchronize()
}

public func getFinalArray() -> [String] {
  return UserDefaults.standard.object(forKey: FINAL_ARRAY) as? [String] ?? []
}

public func setAdditionalArray(_ array: [String]) {
  UserDefaults.standard.set(array, forKey: ADDITIONAL_ARRAY)
  UserDefaults.standard.synchronize()
}

public func getAdditionalArray() -> [String] {
  return UserDefaults.standard.object(forKey: ADDITIONAL_ARRAY) as? [String] ?? []
}

extension UIApplication {
  var keyWindowInConnectedScenes: UIWindow?{
    return windows.first(where: {$0.isKeyWindow})
  }
}


