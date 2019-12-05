//
//  MainViewController.swift
//  TopBarMenuDemo


import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var topBarMenuView: TopBarMenuView!
    @IBOutlet weak var mainCollectionView: UICollectionView!
    
    var titleList = [String]() {
        didSet {
            topBarMenuView.titleList = titleList
        }
    }
    fileprivate var selectIndex: CGFloat = 0
    fileprivate var isTopBarSelect = false
    fileprivate var topBarSelectIndex: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.topBarMenuView.delegate = self
        self.mainCollectionView.dataSource = self
        self.mainCollectionView.delegate = self
        self.mainCollectionView.register(UINib(nibName: MainCollectionViewCell.identifier, bundle: .main), forCellWithReuseIdentifier: MainCollectionViewCell.identifier)
        self.navigationItem.title = "TOPBAR"
        self.titleList = ["red", "green", "colorForBlue", "orange", "lightGray"]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.selectItem(0)
    }
    
    //Update data here
    
    private func setUserInterface() {
        
    }
    
    private func getTopBarCell(item: Int) -> UICollectionViewCell {
        return topBarMenuView.collectionView.dequeueReusableCell(withReuseIdentifier: TopBarMeunCollectionCell.identifier, for: IndexPath(item: item, section: 0))
    }
    
    fileprivate func didSelectTopBar(index: Int) {
        let indexPath = IndexPath(item: index, section: 0)
        mainCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }

    
    func selectItem(_ index: Int){
        let indexPath = IndexPath(item: index, section: 0)
        self.didSelectTopBar(index: index)
        self.topBarMenuView.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        self.topBarMenuView.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
        if let cell = self.topBarMenuView.collectionView.cellForItem(at: indexPath) {
            self.topBarMenuView.bottomBarView.frame.origin.x = cell.frame.origin.x
            self.topBarMenuView.bottomBarView.frame = CGRect(origin: self.topBarMenuView.bottomBarView.frame.origin, size: CGSize(width:  cell.frame.width, height: self.topBarMenuView.bottomBarView.frame.height))
        }
    }
    
}

    // MARK: - UICollectionViewDelegate

extension MainViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView.contentOffset.x > 0, (scrollView.contentOffset.x + UIScreen.main.bounds.width) < scrollView.contentSize.width else { return }
        
        let startX = scrollView.contentOffset.x / UIScreen.main.bounds.width
        let nextIndex = startX >= selectIndex ? selectIndex + 1 : selectIndex - 1
        let startCell = getTopBarCell(item: Int(selectIndex))
        let nextCell = getTopBarCell(item: !isTopBarSelect ? Int(nextIndex) : Int(topBarSelectIndex))
        let proportion = (startX - selectIndex) / ((topBarSelectIndex - selectIndex) > 0 ? (topBarSelectIndex - selectIndex) : (topBarSelectIndex - selectIndex) * -1)  //
        
        let xRation: CGFloat = !isTopBarSelect ? (startX - selectIndex) : proportion
        
        if startCell.frame.origin.x >= nextCell.frame.origin.x {
            let xs = startCell.frame.origin.x - ((nextCell.frame.origin.x - startCell.frame.minX) * xRation)
            topBarMenuView.bottomBarView.frame.origin.x = xs
            topBarMenuView.collectionView.contentOffset.x = topBarMenuView.bottomBarView.frame.maxX - topBarMenuView.collectionView.frame.width/2 - topBarMenuView.bottomBarView.frame.width/2
        } else {
            let xs = startCell.frame.origin.x + ((nextCell.frame.origin.x - startCell.frame.minX) * xRation )
            topBarMenuView.bottomBarView.frame.origin.x = xs
            topBarMenuView.collectionView.contentOffset.x = topBarMenuView.bottomBarView.frame.maxX - topBarMenuView.collectionView.frame.width/2 - topBarMenuView.bottomBarView.frame.width/2
        }
        
        let widthRation = !isTopBarSelect ? ((startX - selectIndex) > 0 ? (startX - selectIndex) : (startX - selectIndex) * -1) : (xRation >= 0 ? xRation : xRation * -1)
        
        if startCell.frame.width > nextCell.frame.width {
            let width = startCell.frame.width - ((startCell.frame.width - nextCell.frame.width) * widthRation)
            topBarMenuView.bottomBarView.frame.size.width = width
            topBarMenuView.centerPoint = width/2
        } else {
            let width = startCell.frame.width + ((nextCell.frame.width - startCell.frame.width) * widthRation)
            topBarMenuView.bottomBarView.frame.size.width = width
            topBarMenuView.centerPoint = width/2
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = scrollView.contentOffset.x / UIScreen.main.bounds.width
        let indexPath = IndexPath(item: Int(index), section: 0)
        
        topBarMenuView.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
        let cell = getTopBarCell(item: Int(index))
        if topBarMenuView.bottomBarView.frame.minX != cell.frame.minX || topBarMenuView.bottomBarView.frame.size.width != cell.frame.width {
            UIView.animate(withDuration: 0.3) { [weak self] in
                self?.topBarMenuView.bottomBarView.frame.origin.x = cell.frame.minX
                self?.topBarMenuView.bottomBarView.frame.size.width = cell.frame.width
                
            }
        }
        selectIndex = index
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        selectIndex = scrollView.contentOffset.x / UIScreen.main.bounds.width
        isTopBarSelect = false
        if topBarSelectIndex != 0 {
            topBarSelectIndex = 0
        }
    }
}

    // MARK: - UICollectionViewDataSource

extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titleList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainCollectionViewCell.identifier, for: indexPath) as! MainCollectionViewCell
        switch indexPath.row {
        case 0:
            cell.customView.backgroundColor = .red
        case 1:
            cell.customView.backgroundColor = .orange
        case 2:
            cell.customView.backgroundColor = .blue
        case 3:
            cell.customView.backgroundColor = .green
        case 4:
            cell.customView.backgroundColor = .lightGray
        default:
            cell.customView.backgroundColor = .purple
        }
        return cell
    }
}

    // MARK: - TopBarMeunDelegate

extension MainViewController: TopBarMeunDelegate {
    func topBarDidSelecrIndex(index: Int) {
        isTopBarSelect = true
        topBarSelectIndex = CGFloat(index)
        didSelectTopBar(index: index)
    }
}
