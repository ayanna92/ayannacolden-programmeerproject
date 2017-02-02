//
//  UsersViewController.swift
//  programmeerproject
//
//  Created by Ayanna Colden on 10/01/2017.
//  Copyright © 2017 Ayanna Colden. All rights reserved.
//

import UIKit
import Firebase

class UsersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    
    @IBOutlet weak var open: UIBarButtonItem!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let searchController = UISearchController(searchResultsController: nil)

    var userMessages = [UserMessages]()
    var filteredUser = [UserMessages]()
    var isSearching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableview.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectCell(sender:))))
        
        self.hideKeyboard()
        
        navigationItem.title = "M.A.D. Users"
        retrieveUsers()
        
        open.target = self.revealViewController()
        searchBar.delegate = self
        searchDisplayController?.searchResultsDelegate = self;
        
        open.action = #selector(SWRevealViewController.revealToggle(_:))
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }

    func didSelectCell(sender: UITapGestureRecognizer){
        
        // Source: https://www.youtube.com/watch?v=js3gHOuPb28&t=1763s
        
        if let indexPath = tableview.indexPathForRow(at: sender.location(in: self.tableview)) {
            if let _ = tableview.cellForRow(at: indexPath) as? UserCell {
                let uid = FIRAuth.auth()!.currentUser!.uid
                let ref = FIRDatabase.database().reference()
                let key  = ref.child("users").childByAutoId().key
                
                let array = isSearching ? self.filteredUser : self.userMessages
                
                var isFollower = false
                
                ref.child("users").child(uid).child("following").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
                    
                    if let following = snapshot.value as? [String : AnyObject] {
                        for (ke, value) in following {
                            if value as! String == array[indexPath.row].uid {
                                isFollower = true
                                
                                ref.child("users").child(uid).child("following/\(ke)").removeValue()
                                ref.child("users").child(array[indexPath.row].uid!).child("followers/\(ke)").removeValue()
                                
                                self.tableview.cellForRow(at: indexPath)?.accessoryType = .none
                            }
                        }
                    }
                    if !isFollower {
                        let following = ["following/\(key)" : array[indexPath.row].uid]
                        let followers = ["followers/\(key)" : uid]
                        
                        ref.child("users").child(uid).updateChildValues(following)
                        ref.child("users").child(array[indexPath.row].uid!).updateChildValues(followers)
                        
                        self.tableview.cellForRow(at: indexPath)?.accessoryType = .checkmark
                    }
                    
                })
                ref.removeAllObservers()
                tableview.deselectRow(at: indexPath, animated: true)
            }
        }
    }
    
    func retrieveUsers() {
        let ref = FIRDatabase.database().reference()
        
        ref.child("users").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
            
            AppDelegate.instance().showActivityIndicator()
            let users = snapshot.value as! [String : AnyObject]
            self.userMessages.removeAll()
            for (_, value) in users {
                if let uid = value["uid"] as? String {
                    if uid != FIRAuth.auth()!.currentUser!.uid {
                        let userToShow = UserMessages()
                        if let fullName = value["fullname"] as? String, let imagePath = value["urlToImage"] as? String {
                            userToShow.fullname = fullName
                            userToShow.urlToImage = imagePath
                            userToShow.uid = uid
                            self.userMessages.append(userToShow)
                        }
                    }
                }
            }
            self.tableview.reloadData()
            AppDelegate.instance().dismissActivityIndicator()
        })
        ref.removeAllObservers()
        
    }
    
    func checkFollowing(indexPath: IndexPath, isSearching: Bool) {
        let uid = FIRAuth.auth()!.currentUser!.uid
        let ref = FIRDatabase.database().reference()
        
        ref.child("users").child(uid).child("following").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
            
            if let following = snapshot.value as? [String: AnyObject] {
                for (_, value) in following {
                    
                    var array = isSearching ? self.filteredUser: self.userMessages
                    if array.count == 0 {
                        return
                    }
    
                    if array.count > indexPath.row && value as? String == array[indexPath.row].uid {
                        self.tableview.cellForRow(at: indexPath)?.accessoryType = .checkmark
                    }
                }
            }
        })
        ref.removeAllObservers()
        
        
    }
    
   // MARK: Searchbar functions.
    
   func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    filteredUser = searchText.isEmpty ? userMessages : userMessages.filter({(dataString: UserMessages) -> Bool in
        return dataString.fullname?.range(of: searchText, options: .caseInsensitive) != nil
    })
    
    tableview.reloadData()
    
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        isSearching = true
        self.searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        tableview.reloadData()
    }
    
    // MARK: Tableview.
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as! UserCell
        
        if isSearching == true {
            cell.userID = self.filteredUser[indexPath.row].uid
            cell.nameLabel.text = self.filteredUser[indexPath.row].fullname
            cell.userImage.downloadImage(from: self.filteredUser[indexPath.row].urlToImage!)
        } else {
            cell.userID = self.userMessages[indexPath.row].uid
            cell.nameLabel.text = self.userMessages[indexPath.row].fullname
            cell.userImage.downloadImage(from: self.userMessages[indexPath.row].urlToImage!)
        }
        
        checkFollowing(indexPath: indexPath, isSearching: isSearching)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? filteredUser.count: userMessages.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}



    
