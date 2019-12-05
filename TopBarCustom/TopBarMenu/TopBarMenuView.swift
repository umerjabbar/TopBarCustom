//
//  TopBarMenuView.swift
//  TopBarMenuDemo


import UIKit

protocol TopBarMeunDelegate: class {
    func topBarDidSelecrIndex(index: Int)
}

class TopBarMenuView: UIView {
    
    //Use Custom data 
    
    var titleList = [String]() {
        didSet {
            guard !titleList.isEmpty else {
                bottomBarView.isHidden = true
                return
            }
            bottomBarView.isHidden = false
            collectionView.reloadData()
            collectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: .left)
            let width = GlobalClass.getTextframe(text: titleList[0]).width + 45
            bottomBarView.frame = CGRect(x: 0, y: bounds.height - 2, width: width, height: 2)
        }
    }
    
    var delegate: TopBarMeunDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        self.delegate = delegate
        setUsetInterface()
    }
    
    private func setUsetInterface() {
        addSubview(collectionView)
        collectionView.addSubview(bottomBarView)
    }
    
    // MARK: - init Element
    
    var centerPoint : CGFloat = 0
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: bounds, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .clear
        collectionView.register(TopBarMeunCollectionCell.self, forCellWithReuseIdentifier: TopBarMeunCollectionCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInset = UIEdgeInsets(top: 0, left: bounds.width/2, bottom: 0, right: bounds.width/2)
        return collectionView
    }()
    
    lazy private var flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        return layout
    }()
    
    //Use Custom Color for top bar
    
    lazy var bottomBarView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
}

    // MARK: - UICollectionViewDelegate

extension TopBarMenuView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.topBarDidSelecrIndex(index: indexPath.row)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
}

    // MARK: - UICollectionViewDataSource

extension TopBarMenuView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titleList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopBarMeunCollectionCell.identifier, for: indexPath) as! TopBarMeunCollectionCell
        cell.titleString = titleList[indexPath.row]
        return cell
    }
}

    // MARK: - UICollectionViewCdlegateFlowLayout

    //Use Custom Size for top text

extension TopBarMenuView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = GlobalClass.getTextframe(text: titleList[indexPath.row]).width + 45
        return CGSize(width: width, height: bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}





