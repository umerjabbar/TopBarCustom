//
//  TopBarMeunCollectionCell.swift
//  TopBarMenuDemo


import UIKit

class TopBarMeunCollectionCell: UICollectionViewCell {
    
    var titleString: String? {
        didSet {
            if titleString == nil { return }
            titleLabel.text = titleString?.uppercased()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUserInterface()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.titleLabel.textColor = .lightGray
        self.isSelected = false
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
        label.textColor = .lightGray
        return label
    }()
}
