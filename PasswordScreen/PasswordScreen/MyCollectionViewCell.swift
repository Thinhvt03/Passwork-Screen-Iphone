//
//  MyCollectionViewCell.swift
//  PasswordScreen
//
//  Created by Hoàng Loan on 23/02/2023.
//

import UIKit

class MyCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var numberLabel: UILabel!

    required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            initViews()
        }

    func initViews() {
        selectedBackgroundView = UIView(frame: frame)
        selectedBackgroundView?.backgroundColor = .systemGray2
    }
}
