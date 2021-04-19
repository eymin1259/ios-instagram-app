import UIKit

private let reuseIdentifier = "NotificationCell"

class NotificationController: UITableViewController {
    
    
    // MARK: properties
    private var notifications = [Notification]()
    
    private var refresher = UIRefreshControl()
    
    // MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    // MARK : helpers
    
    
    func configureUI(){
        
        navigationItem.title = " Notifications"
        
        tableView.register(NotificationCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 80
        
        tableView.separatorStyle = .none
        fetchNotifications()
        
        refresher.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        tableView.refreshControl = refresher
     
    }
    
    
    // MARK: helpers
    @objc func handleRefresh() {
        self.notifications.removeAll()
        self.fetchNotifications()
        self.refresher.endRefreshing()
    }
    
    // MARK: api
    
    func fetchNotifications() {
        NotificationService.fetchNotification { (notifications) in
            self.notifications = notifications
            self.checkIfUserIsFollowed()
            
            
        }
    }
    
    func checkIfUserIsFollowed() {
        self.notifications.forEach { (notification) in
            
            guard notification.type == .follow else {return}
            
            UserService.checkIfUserIsFollowed(uid: notification.uid) { (isFollowed) in
                if let index = self.notifications.firstIndex(where: {$0.id == notification.id}){
                    print("debug : \(isFollowed)")
                    self.notifications[index].userIsFollowed = isFollowed
                    self.tableView.reloadData()
                    
                }
            }
        }
    }
}

// MARK: UITalbleViewDataSource
extension NotificationController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! NotificationCell
        cell.viewModel = NotificationViewModel(notification: self.notifications[indexPath.row])
        cell.delegate = self
        return cell
    }
    
    
}

// MARK:  UITalbleViewDelgate
extension NotificationController {
    
    // when a cell of table is selected, this function will be called
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let uid = notifications[indexPath.row].uid
        
        UserService.fetchUser(withUid: uid) { (user) in
            let controller = ProfileController(withUser: user)
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}

// MARK: NotificationCelldelegate
extension NotificationController : NotificationCelldelegate {
    func cell(_ cell: NotificationCell, wantsToFollow uid: String) {
        UserService.follow(uid: uid) { (_) in
            cell.viewModel?.notification.userIsFollowed.toggle()
        }
        
    }
    
    func cell(_ cell: NotificationCell, wantsToUnFollow uid: String) {
        
        UserService.unFollow(uid: uid) { (_) in
            cell.viewModel?.notification.userIsFollowed.toggle()
        }
    }
    
    func cell(_ cell: NotificationCell, wantsToViewPost postId: String) {
        
        PostService.fetchPost(withPostId: postId) { (post) in
            let controller = FeedController(collectionViewLayout: UICollectionViewFlowLayout())
            controller.post = post
            self.navigationController?.pushViewController(controller , animated: true)
            
        }
    }
    
    
}


