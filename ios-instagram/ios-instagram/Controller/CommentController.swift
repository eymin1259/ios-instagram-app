//
//  CommentController.swift
//  ios-instagram
//
//  Created by yongmin lee on 4/18/21.
//

import UIKit

private let commentCellIdentifier = "commentCellIdentifier"

class  CommentController : UICollectionViewController {
    // MARK: properties
    
    
    // MARK: life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
    }
    
    // MARK: helpers
    
    func configureCollectionView() {
        collectionView.backgroundColor = .white
        navigationItem.title = "Comments"
        
        collectionView.register(CommentCell.self, forCellWithReuseIdentifier: commentCellIdentifier)
    }
    
}

// 2 essential extensions for UICollectionViewController
// - UICollectionViewController Datasource
// - UICollectionViewDelegateFLowLayout

// MARK: UICollectionViewController Datasource
extension CommentController {
    // tell the collectionview how many cell to render
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    // tell the collectionview what cell to render
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: commentCellIdentifier, for: indexPath)
        
        return cell
    }
}

//MARK: UICollectionViewDelegateFLowLayout
//determine the sizing for the collection
extension CommentController: UICollectionViewDelegateFlowLayout{
    
    
    // sizeForItemAt : define cell size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.frame.width, height: 80)
    }
    
    
}
