import UIKit
import Firebase

private let reuseIdentifier = "cell"

class FeedController : UICollectionViewController {
    
    //MARK: properties
    var posts = [Post]() // FeedController with posts
    var post : Post? {  // FeedController with a single post
        didSet {
            self.collectionView.reloadData()

        }
    }
    
    // MARK: LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        fetchPosts()
        
        if self.post != nil {  // FeedController with a single post
            chekcIfUserLikePosts()
        }
    }
    
    //MARK : api
    func fetchPosts(){
        guard post == nil else {
            print("debug :  no fetch Posts")
            return
        }
        
        PostService.fetchPosts { (posts) in
            self.posts = posts
            self.chekcIfUserLikePosts()
            self.collectionView.reloadData()
        }
    }
    
    func chekcIfUserLikePosts() {
        if let post = post {
            PostService.chekcIfUserLikePost(post: post) { (didLike) in
                self.post?.didLike = didLike
            }
        }else {
            self.posts.forEach { (post) in
                PostService.chekcIfUserLikePost(post: post) { (didLike) in
                    //print("debug : does user like \(post.caption) ? -> \(didLike)")
                    if let index = self.posts.firstIndex(where: { $0.postId == post.postId }) {
                        self.posts[index].didLike = didLike
                    }
                }
            }
        }
    }
    
    // MARK: Helpers
    
     func configureUI() {
        collectionView.backgroundColor = .white
        
        collectionView.register(FeedCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        if post == nil {
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        }
        
        navigationItem.title = "Feeds"
        
        let refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView.refreshControl = refresher
        
    }
    
    //MARK: actions
    
    @objc func handleRefresh() {
        posts.removeAll()
        collectionView.refreshControl?.endRefreshing()
        self.fetchPosts()
    }
    
    @objc func handleLogout() {
        do {
            try Auth.auth().signOut()
            let controller = LoginController()
            controller.delegate = self.tabBarController as? MainTapController
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
            print("debug : success to logout")
        }catch {
            print("debug : failed to logout")
        }
    }
}

// 2 essential extensions for UICollectionViewController
// - UICollectionViewController Datasource
// - UICollectionViewDelegateFLowLayout


// MARK: UICollectionViewDataSource
extension FeedController {
    
    // deifine how many cell to create
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return post == nil ? posts.count : 1
    }
    
    //define each cell in collectionview
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FeedCell
        cell.delegate = self
        if let post = post {
            cell.postViewModel = PostViewModel(post: post)
        }else {
            cell.postViewModel = PostViewModel(post: self.posts[indexPath.row])
        }
        
        
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

extension FeedController : FeedCellDelegate {

    
    func cell(_ cell: FeedCell, wantsToShowProfileOf uid: String) {
        UserService.fetchUser(withUid: uid) { (user) in
            let controller = ProfileController(withUser: user)
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func cell(_ cell: FeedCell, wantsToShowCommentsOf post: Post) {
        let controller = CommentController(collectionViewLayout: UICollectionViewFlowLayout())
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func cell(_ cell: FeedCell, didLike post: Post) {
        
        cell.postViewModel?.post.didLike.toggle()
        
        // unlike post
        if post.didLike {
            PostService.unlikePost(post: post) { (error) in
                if let error = error {
                    print("debug : failed to unlike post -> \(error.localizedDescription)")
                    return
                }
                
                cell.likeButton.setImage(#imageLiteral(resourceName: "like_unselected"), for: .normal)
                cell.tintColor = .black
                cell.postViewModel?.post.likes = post.likes - 1
            }
        }
        else { // like post
            PostService.likePost(post: post) { (error) in
                if let error = error {
                    print("debug : failed to like post -> \(error.localizedDescription)")
                    return
                }
                
                cell.likeButton.setImage(#imageLiteral(resourceName: "red_like_selected"), for: .normal)
                cell.likeButton.contentVerticalAlignment = .center
                cell.likeButton.contentHorizontalAlignment = .center
                cell.likeButton.imageEdgeInsets = UIEdgeInsets(top: 11, left: 7, bottom: 15, right: 7)
                cell.postViewModel?.post.likes = post.likes + 1

                
                //guard let currentUid = Auth.auth().currentUser?.uid else {return}
                //UserService.fetchUser(withUid: currentUid) { (user) in
                //    NotificationService.uploadNotification(toUid: post.ownerId, fromUser: user, type: .like, post: post)
                //}
                
                // refactoring
                guard let tab = self.tabBarController as? MainTapController else {return}
                guard let user = tab.user else {
                    return
                }
                NotificationService.uploadNotification(toUid: post.ownerId, fromUser: user, type: .like, post: post)
            }
        }
    }
}
