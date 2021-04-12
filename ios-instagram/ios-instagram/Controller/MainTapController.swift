import UIKit
import Firebase

class MainTapController: UITabBarController {
    
    //MARK: properties
    private var user: User? {
        didSet {
            guard let user = self.user else {return}
            configureControllers(withUser: user)
        }
    }
    
    // MARK: LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkIfUserIsLoggedIn()
        fetchUser()
    }
    
    // MARK: API
    
    func checkIfUserIsLoggedIn(){
        // check if user is logged in or not
        // if user is not logged in -> show up login controller
        
        print("debug : check if user is not logged in")
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let controller = LoginController()
                controller.delegate = self
                let nav = UINavigationController(rootViewController: controller)
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true, completion: nil)
            }
        }
    }
    
    func fetchUser(){
        print("debug : call fetch user api ")
        UserService.fetchUser { (user) in
            self.user = user
        }
    }
    
    // MARK: Helpers
    
    private func configureControllers(withUser user: User) {
        view.backgroundColor = .systemGray
        
        let collectionViewLayout = UICollectionViewFlowLayout() // UICollectionView must be initialized with a non-nil layout parameter
        let feedCtrl = templateNavigationController(unselectedImage: #imageLiteral(resourceName: "home_unselected"), selectedImage: #imageLiteral(resourceName: "home_selected"), rootViewController: FeedController(collectionViewLayout: collectionViewLayout))
        let searchCtrl = templateNavigationController(unselectedImage: #imageLiteral(resourceName: "search_unselected"), selectedImage: #imageLiteral(resourceName: "search_selected"), rootViewController: SearchController())
        let imageSelectCtrl = templateNavigationController(unselectedImage: #imageLiteral(resourceName: "plus_unselected"), selectedImage: #imageLiteral(resourceName: "plus_unselected"), rootViewController: ImageSelectController())
        let notificationCtrl = templateNavigationController(unselectedImage: #imageLiteral(resourceName: "like_unselected"), selectedImage: #imageLiteral(resourceName: "like_selected"), rootViewController: NotificationController())
        
        let profileCtrl = ProfileController(withUser: user)
        let profile = templateNavigationController(unselectedImage: #imageLiteral(resourceName: "profile_unselected"), selectedImage: #imageLiteral(resourceName: "profile_selected"), rootViewController: profileCtrl)
         
        // UITabBarController properties
        viewControllers = [feedCtrl, searchCtrl, imageSelectCtrl, notificationCtrl, profile]
        tabBar.tintColor = .black
    }
    
    
    private func templateNavigationController(unselectedImage: UIImage, selectedImage: UIImage, rootViewController: UIViewController) -> UINavigationController {
        
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = unselectedImage
        nav.tabBarItem.selectedImage = selectedImage
        nav.navigationBar.tintColor = .black
        return nav
    }
    
    
}

extension MainTapController: AuthenticationDelegate {
    func authenticationDidComplete() {
        print("debug: ahtentication did complete -> fetch user and update in MainTapController")
        fetchUser()
        self.dismiss(animated: true, completion: nil) // dismiss authentication controllers
        
    }
}
