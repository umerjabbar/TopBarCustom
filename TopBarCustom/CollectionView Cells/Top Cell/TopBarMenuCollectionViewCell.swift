//
//  TopBarMenuCollectionViewCell.swift
//  TopBarCustom
//
//  Created by Umer Jabbar on 06/12/2019.
//  Copyright © 2019 Sample. All rights reserved.
//

import UIKit

class TopBarMenuCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    var titleString: String? {
        didSet {
            if titleString == nil { return }
            titleLabel.text = titleString?.uppercased()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override var isSelected: Bool {
        didSet {
            self.titleLabel?.textColor = isSelected ? .systemGray6 : .lightGray
        }
    }

}
