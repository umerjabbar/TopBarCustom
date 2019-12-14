//
//  MainViewController.swift
//  TopBarMenuDemo


import UIKit

class MainViewController: UIViewController {
    
    
    //topBarMenuView is an outlet of a view containing collectionView in it and a view which indicates the selected index/item
    @IBOutlet weak var topBarMenuView: TopBarMenuView!
    
    //You must know what a collectionView is so I don't need to explain it here but if you need any understanding regarding collectionView you can visit apple documentation
    //mainCollectionView is a collectionView which is being used here as the content holder. We can add whatever view we want to include
    @IBOutlet weak var mainCollectionView: UICollectionView!
    
    //titleList is a just an array of string which is being used here as a number of items in collectionView and describes the item Title
    var titleList = [String]() {
        didSet {
            topBarMenuView.titleList = titleList
        }
    }
    //selectIndex indicates the selected Index of item in mainCollectionView
    fileprivate var selectIndex: CGFloat = 0
    //isTopBarSelect indicates the item in topbar should be selected
    fileprivate var isTopBarSelect = false
    //topBarSelectIndex indicates the selected Index of item in collectionView of topBarMenuView
    fileprivate var topBarSelectIndex: CGFloat = 0
    
    //I don't think that you need to understand what a ViewDidLoad is but if you need any understanding regarding it you can visit apple documentation anytime
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.topBarMenuView.delegate = self //this implements delegate of topBarMenuView
        self.mainCollectionView.dataSource = self //this implements datasource of mainCollectionView
        self.mainCollectionView.delegate = self //this implements delegate of mainCollectionView
        self.mainCollectionView.register(UINib(nibName: MainCollectionViewCell.identifier, bundle: .main), forCellWithReuseIdentifier: MainCollectionViewCell.identifier) //here we are registering a cell so that we can use it later in cell creation
        self.navigationItem.title = "TOPBAR"  //here we are just giving navigation bar a title
        self.titleList = ["red", "green", "colorForBlue", "orange", "lightGray"] //here we are initializing the items and titles
    }
    
    //I don't think that you need to understand what a viewWillAppear is but if you need any understanding regarding it you can visit apple documentation anytime
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.selectItem(0) //here we are selecting the item when a screen appears. You can change 0 to whatever index you want to start with
    }
    // this function returns the top bar cell
    private func getTopBarCell(item: Int) -> UICollectionViewCell {
        return topBarMenuView.collectionView.dequeueReusableCell(withReuseIdentifier: TopBarMeunCollectionCell.identifier, for: IndexPath(item: item, section: 0)) // this deques the cell from the stack and returns on first section with the given row number
    }
    // this function performs the post action of top bar state gets selected
    fileprivate func didSelectTopBar(index: Int) {
        let indexPath = IndexPath(item: index, section: 0) // this stores the the indexPath at given row to indexPath variable
        mainCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true) // this function scrolls to given indexPath on collectionView
    }

    // this function is responsible for any selection on row in collectionView. it gets called whenever any row is intended to be selected
    func selectItem(_ index: Int){
        let indexPath = IndexPath(item: index, section: 0) // this returns the indexPath at given row and stores it in indexPath named variable
        self.didSelectTopBar(index: index) // this function performs the post action of top bar state gets selected
        self.topBarMenuView.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true) // this function scrolls to given indexPath on collectionView
        self.topBarMenuView.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally) // this function selects the given indexPath in collectionView and takes scrollingPosition as parameter to scroll the selected indexPath at desired position.
        if let cell = self.topBarMenuView.collectionView.cellForItem(at: indexPath) { // this line of code checks whether the cell is not empty or out of heap. this happens when the cell is not visible or cell has been removed from the collectionView
            self.topBarMenuView.bottomBarView.frame.origin.x = cell.frame.origin.x // this sets the frame origin x position of topBarMenuView's bottomBarMenu to cell's origin x position.
            self.topBarMenuView.bottomBarView.frame = CGRect(origin: self.topBarMenuView.bottomBarView.frame.origin, size: CGSize(width:  cell.frame.width, height: self.topBarMenuView.bottomBarView.frame.height)) // this sets the width of topBarMenuView's bottomBarMenu to cell's width.
        }
    }
    
}

    // MARK: - UICollectionViewDelegate
extension MainViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout { // this describes an extension of MainViewController which holds a common theme of code
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize { // this is a delegate which gets called evevytime collectionView sets the size of any cell
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height) // this returns the size for cell same as the collectionView
    }
    // this is also a delegate method which gets called everytime collectionView contentOffset changes which means not matter how small the change in content visibilty happens, this delegate method is called to let this class know if it has to do any operation.
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
