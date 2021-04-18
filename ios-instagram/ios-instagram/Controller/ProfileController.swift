import UIKit

private let cellIdentifier = "profileCell"
private let headerIdentifier = "profileHeader"

class ProfileController : UICollectionViewController {
    
    //MARK: properties
    private var posts = [Post]() // empty post array
 
    private var user: User
    
    
    //MARK: lifecycle
    init(withUser user:User){
        print("debug: ProfileController is initialized with user data")
        self.user = user
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        checkIfUserIsFollowed()
        fetchUserStats()
        fetchPosts()
        
    }
    
    // MARK: api
    func checkIfUserIsFollowed() {
        UserService.checkIfUserIsFollowed(uid: user.uid) { (isFollowed) in
            self.user.isFollowed = isFollowed
            self.collectionView.reloadData()
        }
    }
    
    func fetchUserStats() {
        UserService.fetchUserStats(uid: user.uid) { (userstats) in
            self.user.stats = userstats
            self.collectionView.reloadData()
        }
    }
    
    func fetchPosts() {
        PostService.fetchPosts(forUser: self.user.uid) { (posts) in
            self.posts = posts
            self.collectionView.reloadData()
        }
    }
    
    // MARK: helpers
    func configureCollectionView(){
        collectionView.backgroundColor = .white
        collectionView.register(ProfileCell.self, forCellWithReuseIdentifier: cellIdentifier)
        collectionView.register(ProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        navigationItem.title = self.user.username
    }
}

// MARK: UICollectionViewDataSource
// how we set up the data source
extension ProfileController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    // tell the collectionview what cell to render
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! ProfileCell
        cell.viewModel = PostViewModel(post: self.posts[indexPath.row])
        return cell 
    }
    
    // tell the collectionview what header to render
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! ProfileHeader
        
        header.profileHeaderViewModel = ProfileHeaderViewModel(user: self.user)
        header.delegate = self
        return header
    }
}

//MARK: UICollectionViewDelegate
// select items in the collection view
extension ProfileController{
    
   // if a post of user is selected
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("debug : selected post is \(posts[indexPath.row].caption)")
        
        let feedCtrl = FeedController(collectionViewLayout: UICollectionViewFlowLayout())
        feedCtrl.post = posts[indexPath.row]
        navigationController?.pushViewController(feedCtrl, animated: true)
        
    }
    
}

//MARK: UICollectionViewDelegateFLowLayout
//determine the sizing for the collection
extension ProfileController: UICollectionViewDelegateFlowLayout{
    
    // define inter spacing between cells
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    // define line spacing between cells
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    // define cell size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width-2) / 3
        return CGSize(width: width, height: width)
    }
    
    //define header size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 240)
    }
}

extension ProfileController: ProfileHeaderDelegate {
    
    func header(_ profileHeader: ProfileHeader, didTapActionBtnFor user: User) {
        
        if user.isCurrentUser {
            print("debug : show edit profile")
        }
        else if user.isFollowed {
            UserService.unFollow(uid: user.uid) { (error) in
                self.user.isFollowed = false
                self.collectionView.reloadData() // update ui
            }
        }else {
            UserService.follow(uid: user.uid) { (error) in
                self.user.isFollowed = true
                self.collectionView.reloadData() // update ui
            }
        }
    }

}
