import UIKit
import Firebase

private let reuseIdentifier = "cell"

class FeedController : UICollectionViewController {
    
    //MARK: properties
    
    
    var posts = [Post]() // empty post array
    var post : Post?
    
    // MARK: LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        fetchPosts()
    }
    
    //MARK : api
    func fetchPosts(){
        guard post == nil else {
            print("debug :  no fetch Posts")
            return
        }
        
        PostService.fetchPosts { (posts) in
            self.posts = posts
            self.collectionView.reloadData()
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

// MARK: UICollectionViewDataSource
extension FeedController {
    
    // deifine how many cell to create
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return post == nil ? posts.count : 1
    }
    
    //define each cell in collectionview
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FeedCell
        
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
