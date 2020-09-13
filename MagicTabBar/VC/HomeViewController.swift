//
//  HomeViewController.swift
//  MagicTabBar
//
//  Created by Dhruvik Dhanani on 30/08/20.
//  Copyright © 2020 Dhruvik Dhanani. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

  var tabController: VC_TYPE = .Dummy
  
    override func viewDidLoad() {
        super.viewDidLoad()
      setUPColors()
      let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture))
      swipeRight.direction = .right
      self.view.addGestureRecognizer(swipeRight)

      let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture))
      swipeLeft.direction = .left
      self.view.addGestureRecognizer(swipeLeft)
    }

  func setUPColors() {
    if tabController == .Home {
      self.view.backgroundColor = .orange
    }
    else if tabController == .Search {
      self.view.backgroundColor = .cyan
    }
    else if tabController == .Cart {
      self.view.backgroundColor = .lightText
    }
    else if tabController == .Profile {
      self.view.backgroundColor = .magenta
    }
    else if tabController == . Menu {
      self.view.backgroundColor = .blue
    }
    else if tabController == . Discount {
      self.view.backgroundColor = .brown
    }
    else if tabController == . Car {
      self.view.backgroundColor = .red
    }
    else if tabController == . Free {
      self.view.backgroundColor = .yellow
    }
    else if tabController == . Money {
      self.view.backgroundColor = .systemPink
    }
    else if tabController == . Bag {
      self.view.backgroundColor = .green
    }
    else if tabController == . Payment {
      self.view.backgroundColor = .purple
    }
    else if tabController == . Sale {
      self.view.backgroundColor = .systemTeal
    }
  }

  
   @objc func handleSwipeGesture(_ gesture: UISwipeGestureRecognizer) {
     guard let tabBarController = tabBarController, let viewControllers = tabBarController.viewControllers else { return }
     let tabs = viewControllers.count
     if gesture.direction == .left {
         if (tabBarController.selectedIndex) < tabs {
             tabBarController.selectedIndex += 1
         }
     } else if gesture.direction == .right {
         if (tabBarController.selectedIndex) > 0 {
             tabBarController.selectedIndex -= 1
         }
     }
   }
  
}

public enum VC_TYPE:Int {
  case Dummy = 12
  case Home = 0
  case Search = 1
  case Cart = 2
  case Profile = 3
  case Menu = 4
  case Discount = 5
  case Car = 6
  case Free = 7
  case Money = 8
  case Bag = 9
  case Payment = 10
  case Sale = 11
}
