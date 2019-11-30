//
//  TopBarMeunCollectionCell.swift
//  TopBarMenuDemo


import UIKit

class TopBarMeunCollectionCell: UICollectionViewCell {
    
    var titleType: DemoTestViewModel = .red {
        didSet {
            titleLabel.text = titleType.title.uppercased()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUserInterface()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isSelected: Bool {
        didSet {
            titleLabel.textColor = isSelected ? .systemGray6 : .lightGray
        }
    }
    
    // MARK: - private Method
    
    private func setUserInterface() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        contentView.addSubview(titleLabel)
    }
    
    // MARK: - init Element
    
    //Use Custom font and size for top Bar text
    
    lazy private var titleLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: (bounds.height - 20) / 2, width: bounds.width, height: 20))
        label.textAlignment = .center
//        label.font = UIFont(name: GlobalClass.avenirNext_Regular, size: 10)
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .systemGray6
        return label
    }()
}
