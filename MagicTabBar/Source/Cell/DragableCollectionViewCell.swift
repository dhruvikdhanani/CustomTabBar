//
//  DragableCollectionViewCell.swift
//  MagicTabBar
//
//  Created by Dhruvik Dhanani on 30/08/20.
//  Copyright © 2020 Dhruvik Dhanani. All rights reserved.
//

import UIKit

class DragableCollectionViewCell: UICollectionViewCell {

  @IBOutlet weak var customImageView: UIImageView!
  override func awakeFromNib() {
    super.awakeFromNib()
    cornerRound(radius: 16)
  }

}
