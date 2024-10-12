//
//  CustomizeView.swift
//  MagicTabBar
//
//  Created by Dhruvik Dhanani on 30/08/20.
//  Copyright © 2020 Dhruvik Dhanani. All rights reserved.
//

import UIKit

class CustomizeView: UIView {
  @IBOutlet weak var leadingOfBottomCollectionView: NSLayoutConstraint!
  @IBOutlet weak var trailingOfBottomCollectionView: NSLayoutConstraint!
  @IBOutlet weak var heightOfUpperView: NSLayoutConstraint!
  @IBOutlet weak var btnDone: UIButton!
  @IBOutlet weak var addMenuCollectionView: UICollectionView!
  @IBOutlet weak var customCollectionView: UICollectionView!
  @IBOutlet weak var btnChangeOrder: UIButton!
  
  var additionalArray:[String] = getAdditionalArray()
  var finalArray:[String] = getFinalArray()
  var doneAction:(([String])->Void)?
  
  override func awakeFromNib() {
    super.awakeFromNib()
    btnDone.cornerRound(radius : 20)
    customCollectionView.delegate = self
    customCollectionView.dataSource = self
    customCollectionView.dragDelegate = self
    customCollectionView.dropDelegate = self
    customCollectionView.dragInteractionEnabled = true
    
    addMenuCollectionView.delegate = self
    addMenuCollectionView.dataSource = self
    addMenuCollectionView.dragDelegate = self
    addMenuCollectionView.dropDelegate = self
    addMenuCollectionView.dragInteractionEnabled = true
    addMenuCollectionView.reorderingCadence = .immediate
    
    addMenuCollectionView.register(UINib(nibName: DragableCollectionViewCell.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: DragableCollectionViewCell.reuseIdentifier)
    customCollectionView.register(UINib(nibName: DragableCollectionViewCell.reuseIdentifier, bundle: nil), forCellWithReuseIdentifier: DragableCollectionViewCell.reuseIdentifier)
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    self.viewWithTag(101010)?.cornerRound(RoundingCorners: [.topRight], radius: 40)
    cornerRound(RoundingCorners: [.topRight,.topLeft], radius: 40)
  }
 
  func reloadData(_ data: [String]) {
    if getFinalArray().count == 0 {
      for i in data {
        if finalArray.count != 4 {
          finalArray.append(i)
        } else {
          additionalArray.append(i)
        }
      }
      setAdditionalArray(additionalArray)
      setFinalArray(finalArray)
      finalArray = getFinalArray()
      additionalArray = getAdditionalArray()
    }
    customCollectionView.reloadData()
    addMenuCollectionView.reloadData()
  }
  
  @IBAction func btnDoneAction(_ sender: UIButton) {
    if finalArray.count > 5 {
      return
    }
    guard let done = self.doneAction else { return }
    done(finalArray)
  }
}


extension CustomizeView: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if collectionView == customCollectionView {
      return getAdditionalArray().count
    } else {
      return getFinalArray().count
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DragableCollectionViewCell.reuseIdentifier, for: indexPath) as! DragableCollectionViewCell
    if collectionView == customCollectionView {
        cell.customImageView.image = UIImage(named: additionalArray[indexPath.row])
    } else {
        cell.customImageView.image = UIImage(named: finalArray[indexPath.row])
    }
    return cell
  }
  
}

extension CustomizeView: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      return CGSize(width: 80, height: 80)
  }
}

extension CustomizeView: UICollectionViewDragDelegate  {
  
  func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
    let item = collectionView == customCollectionView ? self.additionalArray[indexPath.row] : self.finalArray[indexPath.row]
    let itemProvider = NSItemProvider(object: item as NSString)
    let dragItem = UIDragItem(itemProvider: itemProvider)
    dragItem.localObject = item
    return [dragItem]
  }
  
  func collectionView(_ collectionView: UICollectionView, itemsForAddingTo session: UIDragSession, at indexPath: IndexPath, point: CGPoint) -> [UIDragItem]
     {
         let item = collectionView == customCollectionView ? self.additionalArray[indexPath.row] : self.finalArray[indexPath.row]
         let itemProvider = NSItemProvider(object: item as NSString)
         let dragItem = UIDragItem(itemProvider: itemProvider)
         dragItem.localObject = item
         return [dragItem]
     }
}

extension CustomizeView: UICollectionViewDropDelegate {
  func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool
  {
      return session.canLoadObjects(ofClass: NSString.self)
  }
  
  func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal
  {
    if collectionView.hasActiveDrag
    {
      return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
    }
    else
    {
      return UICollectionViewDropProposal(operation: .copy, intent: .insertAtDestinationIndexPath)
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator)
  {
    let destinationIndexPath: IndexPath
    if let indexPath = coordinator.destinationIndexPath
    {
      destinationIndexPath = indexPath
    }
    else
    {
      // Get last index path of table view.
      let section = collectionView.numberOfSections - 1
      let row = collectionView.numberOfItems(inSection: section)
      destinationIndexPath = IndexPath(row: row, section: section)
    }
    
    switch coordinator.proposal.operation
    {
    case .move:
      self.reorderItems(coordinator: coordinator, destinationIndexPath:destinationIndexPath, collectionView: collectionView)
      break
      
    case .copy:
      if finalArray.count >= 5 && collectionView == addMenuCollectionView {
        alert("You can not add more than 5 items.")
      }
      else if finalArray.count == 1 && collectionView == customCollectionView {
        alert("You need atleast one menu bar.")
      }
      else {
        self.copyItems(coordinator: coordinator, destinationIndexPath: destinationIndexPath, collectionView: collectionView)
      }
    default:
      return
    }
  }
}

extension CustomizeView {

  //MARK: Private Methods
  
  /// This method moves a cell from source indexPath to destination indexPath within the same collection view. It works for only 1 item. If multiple items selected, no reordering happens.
  ///
  /// - Parameters:
  ///   - coordinator: coordinator obtained from performDropWith: UICollectionViewDropDelegate method
  ///   - destinationIndexPath: indexpath of the collection view where the user drops the element
  ///   - collectionView: collectionView in which reordering needs to be done.
  private func reorderItems(coordinator: UICollectionViewDropCoordinator, destinationIndexPath: IndexPath, collectionView: UICollectionView)
  {
      let items = coordinator.items
      if items.count == 1, let item = items.first, let sourceIndexPath = item.sourceIndexPath
      {
          var dIndexPath = destinationIndexPath
          if dIndexPath.row >= collectionView.numberOfItems(inSection: 0)
          {
              dIndexPath.row = collectionView.numberOfItems(inSection: 0) - 1
          }
          collectionView.performBatchUpdates({
              if collectionView === self.addMenuCollectionView
              {
                  self.finalArray.remove(at: sourceIndexPath.row)
                  self.finalArray.insert(item.dragItem.localObject as! String, at: dIndexPath.row)
              }
              else
              {
                  self.additionalArray.remove(at: sourceIndexPath.row)
                  self.additionalArray.insert(item.dragItem.localObject as! String, at: dIndexPath.row)
              }
              collectionView.deleteItems(at: [sourceIndexPath])
              collectionView.insertItems(at: [dIndexPath])
          })
        setFinalArray(finalArray)
        setAdditionalArray(additionalArray)
          coordinator.drop(items.first!.dragItem, toItemAt: dIndexPath)
      }
  }
  
  /// This method copies a cell from source indexPath in 1st collection view to destination indexPath in 2nd collection view. It works for multiple items.
  ///
  /// - Parameters:
  ///   - coordinator: coordinator obtained from performDropWith: UICollectionViewDropDelegate method
  ///   - destinationIndexPath: indexpath of the collection view where the user drops the element
  ///   - collectionView: collectionView in which reordering needs to be done.
  private func copyItems(coordinator: UICollectionViewDropCoordinator, destinationIndexPath: IndexPath, collectionView: UICollectionView)
  {
    
      collectionView.performBatchUpdates({
          var indexPaths = [IndexPath]()
          for (index, item) in coordinator.items.enumerated()
          {
              let indexPath = IndexPath(row: destinationIndexPath.row + index, section: destinationIndexPath.section)
              if collectionView === self.addMenuCollectionView
              {
                  self.finalArray.insert(item.dragItem.localObject as! String, at: indexPath.row)
                if let index = self.additionalArray.firstIndex(of: item.dragItem.localObject as! String) {
                  self.additionalArray.remove(at: index)
                  customCollectionView.reloadData()
                }
              }
              else
              {
                  self.additionalArray.insert(item.dragItem.localObject as! String, at: indexPath.row)
                if let index = self.finalArray.firstIndex(of: item.dragItem.localObject as! String) {
                  self.finalArray.remove(at: index)
                    addMenuCollectionView.reloadData()
                }
              }
              indexPaths.append(indexPath)
          }
          collectionView.insertItems(at: indexPaths)
        setFinalArray(finalArray)
        setAdditionalArray(additionalArray)
      })
  }
  
  private func alert(_ msg:String) {
    let alert = UIAlertController(title: "This will not look better.", message: nil, preferredStyle: UIAlertController.Style.alert)
    alert.addAction(UIAlertAction(title: "Ok", style: .default))
    self.parentViewController?.present(alert, animated: true)
  }
}
