//
//  AppDelegate.swift
//  MagicTabBar
//
//  Created by Dhruvik Dhanani on 30/08/20.
//  Copyright © 2020 Dhruvik Dhanani. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

   var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    window = UIWindow(frame: UIScreen.main.bounds)
    navToHome()
    return true
  }
  
  func navToHome()  {
    UITabBar.appearance().tintColor = UIColor.black
    let tab = MagicTabBarViewController.init(nibName: "MagicTabBarViewController", bundle: nil, magicData: magicTab())
    window?.rootViewController = tab
    window?.makeKeyAndVisible()
  }
  
  func magicTab() -> [TabItem] {
    let v1 = HomeViewController(nibName: "HomeViewController", bundle: nil)
    v1.tabController = .Home
    let v2 = HomeViewController(nibName: "HomeViewController", bundle: nil)
    v2.tabController = .Search
    let v3 = HomeViewController(nibName: "HomeViewController", bundle: nil)
    v3.tabController = .Cart
    let v4 = HomeViewController(nibName: "HomeViewController", bundle: nil)
    v4.tabController = .Profile
    let v5 = HomeViewController(nibName: "HomeViewController", bundle: nil)
    v5.tabController = .Menu
    let v6 = HomeViewController(nibName: "HomeViewController", bundle: nil)
    v6.tabController = .Discount
    let v7 = HomeViewController(nibName: "HomeViewController", bundle: nil)
    v7.tabController = .Car
    let v8 = HomeViewController(nibName: "HomeViewController", bundle: nil)
    v8.tabController = .Free
    let v9 = HomeViewController(nibName: "HomeViewController", bundle: nil)
    v9.tabController = .Money
    let v10 = HomeViewController(nibName: "HomeViewController", bundle: nil)
    v10.tabController = .Bag
    let v11 = HomeViewController(nibName: "HomeViewController", bundle: nil)
    v11.tabController = .Payment
    let v12 = HomeViewController(nibName: "HomeViewController", bundle: nil)
    v12.tabController = .Sale
    
    let t1 = TabItem(v1, imageName: "home", selectedImage: nil, tabName: nil)
    let t2 = TabItem(v2, imageName: "search", selectedImage: nil, tabName: nil)
    let t3 = TabItem(v3, imageName: "cart", selectedImage: nil, tabName: nil)
    let t4 = TabItem(v4, imageName: "profile", selectedImage: nil, tabName: nil)
    let t5 = TabItem(v5, imageName: "menu", selectedImage: nil, tabName: nil)
    let t6 = TabItem(v6, imageName: "discount", selectedImage: nil, tabName: nil)
    let t7 = TabItem(v7, imageName: "free", selectedImage: nil, tabName: nil)
    let t8 = TabItem(v8, imageName: "money", selectedImage: nil, tabName: nil)
    let t9 = TabItem(v9, imageName: "bag", selectedImage: nil, tabName: nil)
    let t10 = TabItem(v10, imageName: "payment", selectedImage: nil, tabName: nil)
    let t11 = TabItem(v11, imageName: "sale", selectedImage: nil, tabName: nil)
    let t12 = TabItem(v12, imageName: "car", selectedImage: nil, tabName: nil)
    return [t1,t2,t3,t4,t5,t6,t7,t8,t9,t10,t11,t12]
  }
  
}













