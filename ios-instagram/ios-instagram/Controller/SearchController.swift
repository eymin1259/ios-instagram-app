import UIKit

private let tableCellIdentifier = "userCell"

class SearchController: UITableViewController {
    
    //MARK: properties
    
    private var users = [User]()
    private var filteredUsers = [User]()
    private var isSearchMode: Bool {
        return uiSearchController.isActive && !uiSearchController.searchBar.text!.isEmpty
    }
    
    private let uiSearchController = UISearchController(searchResultsController: nil)
    
    //MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUiSearchController()
        configureTableUI()
        fetchUsers()
    }
    
    // MARK: api
    func fetchUsers(){
        UserService.fetchUsers { (users) in
            //print("debug : fetchUsers ->\(users)")
            self.users = users
            self.tableView.reloadData()
        }
    }
    
    //MARK: helpers
    func configureTableUI(){
        view.backgroundColor = .white
        
        tableView.register(UserCell.self, forCellReuseIdentifier: tableCellIdentifier)
        tableView.rowHeight = 65

    }
    
    func configureUiSearchController() {
        self.uiSearchController.searchResultsUpdater = self // extension UISearchResultsUpdating
        self.uiSearchController.obscuresBackgroundDuringPresentation = false
        self.uiSearchController.hidesNavigationBarDuringPresentation = false
        self.uiSearchController.searchBar.placeholder = "Search"
        navigationItem.searchController = self.uiSearchController
        definesPresentationContext = false
    }
}

// MARK: UITalbleViewDataSource
extension SearchController {
    
    //define the number of rows in section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearchMode ? filteredUsers.count : users.count
    }
    
    
    //define cell for row
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // dequeueReusableCell <- memory management caching cells
        let userCell = tableView.dequeueReusableCell(withIdentifier: tableCellIdentifier, for: indexPath) as! UserCell
        let user =  isSearchMode ? filteredUsers[indexPath.row] : users[indexPath.row]
        userCell.userViewModel = UserCellViewModel(user: user)
        return userCell // this cell have to be reigistered
    }
}

// didSelectRowAt : get a information of the clicked user
extension SearchController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user =  isSearchMode ? filteredUsers[indexPath.row] : users[indexPath.row]
        let controller = ProfileController(withUser: user)
        navigationController?.pushViewController(controller, animated: true)
    }
}

// MARK: searchResultsUpdater
extension SearchController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        // every time when we text something in UISearchController, this function is called
        guard let searchText = self.uiSearchController.searchBar.text?.lowercased() else {return}
        
        
        self.filteredUsers = users.filter({ $0.username.lowercased().contains(searchText) || $0.fullname.lowercased().contains(searchText) })
        self.tableView.reloadData()
    }
    
    
}
