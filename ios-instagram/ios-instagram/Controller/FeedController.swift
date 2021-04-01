//
//  FeedController.swift
//  ios-instagram
//
//  Created by yongmin lee on 3/15/21.
//

import UIKit

private let reuseIdentifier = "cell"

class FeedController : UICollectionViewController {
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    // MARK: Helpers
    
    private func configureUI() {
        collectionView.backgroundColor = .white
        
        collectionView.register(FeedCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
}

// MARK: UICollectionViewDataSource
extension FeedController {
    
    // deifine how many cell to create
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    //define each cell in collectionview
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FeedCell
        //cell.backgroundColor = .systemRed
        return cell
    }
}

// MARK: UICollectionViewDelegateFlowLayout
// define sizing each cell
extension FeedController: UICollectionViewDelegateFlowLayout {
    
    // each cell gets the returned size value
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = view.frame.width
        var height = width + 8 + 40 + 8 // profileTopPadding + profileImg + profileBottomPadding
        height += 50 // postImg  size
        height += 80 // commentButton + caption size
        
        
        return CGSize(width: width, height: height)
    }
}
