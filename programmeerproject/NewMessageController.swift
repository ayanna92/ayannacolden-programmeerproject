//
//  NewMessageController.swift
//  programmeerproject
//
//  Created by Ayanna Colden on 12/01/2017.
//  Copyright © 2017 Ayanna Colden. All rights reserved.
//

import UIKit
import Firebase

class NewMessageController: UITableViewController {
    
    var messagesController: MessagesTableViewController?
    
    let cellId = "cellId"
    
    var user = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        followingUsers()
        
        tableView.register(MessageCell.self, forCellReuseIdentifier: cellId)
        
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    
    func followingUsers() {
        let ref = FIRDatabase.database().reference()
        let uid = FIRAuth.auth()!.currentUser!.uid
        
        ref.child("users").child(uid).child("following").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
            if let following = snapshot.value as? [String: AnyObject] {
                for(_, value) in following {
                    let fid = value as! String
                    
                    let userToShow = User()
                    userToShow.userID = fid
//                    self.user.append(userShow)
                    ref.child("users").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
                        
                        let users = snapshot.value as! [String : AnyObject]
                        self.user.removeAll()
                        if fid == value as? String {
                            for (_, value) in users {
                                let uid = value["uid"] as? String
                                if fid == uid {
                                   
//                                    let userToShow = User()
                                    DispatchQueue.main.async {
                                        
                                        if let fullName = value["full name"] as? String, let imagePath = value["urlToImage"] as? String {
                                            userToShow.fullName = fullName
                                            userToShow.imagePath = imagePath
                                            self.user.append(userToShow)
                                        
                                        }
                                        self.tableView.reloadData()
                                    }
                                    
                                    }
                            }
                        }
                        })
                    }
                }
        })
    }
    
    
    
    @IBAction func cancelPressed(_ sender: Any) {
        handleCancel()
    }
    func handleCancel() {
        dismiss(animated: true, completion: nil)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return user.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as! UserCell
        
        cell.nameLabel.text = self.user[indexPath.row].fullName
        cell.userID = self.user[indexPath.row].userID
        cell.userImage.downloadImage(from: self.user[indexPath.row].imagePath!)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let users = self.user[indexPath.row]
        print(users.userID)
        self.messagesController?.showChatControllerForUser(users)
        
    }
    
//    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if segue.identifier == "userMessages", let destination = segue.destination as? ChatLogController, let indexPath = tableView.indexPathForSelectedRow?.row {
//            
//            destination.user = self.user[indexPath]
//            
//        }
//    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
