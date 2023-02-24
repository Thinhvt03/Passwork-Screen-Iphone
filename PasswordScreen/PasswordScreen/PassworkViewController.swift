//
//  ViewController.swift
//  PasswordScreen
//
//  Created by Hoàng Loan on 23/02/2023.
//

import UIKit

class PassworkViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var passWorkLabel: UILabel!
    @IBOutlet weak var heightOfCollectionView: NSLayoutConstraint!
    
    // Properties
    var checkPassWork: String! = ""
    let test = "○  ○  ○  ○ "
    let correctPassword = "1111"
    let numberOfItem = 3
    let keyboard = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "x", "0","X"]
    let insetForSection = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        
        passWorkLabel.text = test
        let heightOfRow = collectionView.frame.width / CGFloat(numberOfItem)
        heightOfCollectionView.constant = heightOfRow * CGFloat(keyboard.count/numberOfItem)
        
    }
}
    
// MARK: - DelegateFlowLayout

extension PassworkViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let widthOfItem = collectionView.frame.width / CGFloat(numberOfItem)
        let heightOfItem = collectionView.frame.width / CGFloat(numberOfItem)
        return CGSize(width: widthOfItem, height: heightOfItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return insetForSection
    }
}

// MARK: - DataSourcce and Delegate

extension PassworkViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return keyboard.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let colloctionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! MyCollectionViewCell
        colloctionCell.numberLabel.text = keyboard[indexPath.row]
        colloctionCell.layer.cornerRadius = (collectionView.bounds.width / CGFloat(numberOfItem) / CGFloat(2))
        colloctionCell.numberLabel.font = .systemFont(ofSize: 30, weight: .bold)
        colloctionCell.numberLabel.textColor = .white
        
        return colloctionCell
    }
    // selectItem
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        if indexPath.row == keyboard.count - 1 {
            passWorkLabel.text = test
            checkPassWork.removeAll()
        } else if indexPath.row == keyboard.count - 3 {
            setupxButton()
        } else {
            checkPassWork.append(keyboard[indexPath.row])
            print(checkPassWork ?? "")
            setupcheckPassWork()
        }
    }
   // Setup to check passwork
   private func setupcheckPassWork() {
        switch checkPassWork.count {
        case 1:
            passWorkLabel.text = "●  ○  ○  ○ "
            break
        case 2:
            passWorkLabel.text = "●  ●  ○  ○ "
            break
        case 3:
            passWorkLabel.text = "●  ●  ●  ○ "
            break
        case 4:
            passWorkLabel.text = "●  ●  ●  ●"
            break
        default:
            print("default")
            break
        }
        
        if checkPassWork == correctPassword && checkPassWork.count == 4  {
            let pushHome = HomeViewController()
            present(pushHome, animated: true)
            checkPassWork.removeAll()
            passWorkLabel.text = test
        } else if checkPassWork != correctPassword && checkPassWork.count == 4 {
            checkPassWork.removeAll()
            passWorkLabel.text = test
        } else {
            return
        }
    }
   // Setup for xButton to remove one element
   private func setupxButton() {
        switch checkPassWork.count {
        case 1:
            passWorkLabel.text = "○  ○  ○  ○ "
            checkPassWork.removeLast()
            break
        case 2:
            passWorkLabel.text = "●  ○  ○  ○ "
            checkPassWork.removeLast()
            break
        case 3:
            passWorkLabel.text = "●  ●  ○  ○ "
            checkPassWork.removeLast()
            break
        default:
            print("No elements to delete")
            break
        }
    }
}



