//
//  ChatViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ChatViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
//    //messages is an array of Message objects. This array is what feeds data into the table view.
    var messages: [Message] = []
//  [
//        Message(sender: "sanyukta@gmail.com", body: "Heya"),
//        Message(sender: "sanyukta@gmail.com", body: "Wasup!"),
//        Message(sender: "sanyukta@gmail.com", body: "All gud?")
//  ]
    
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Tells the table view: This view controller will provide the data for the table.
        //That’s why ChatViewController class conforms to UITableViewDataSource Protocol
        tableView.dataSource = self
        
        title = Constants.appName
        
        //Removes the back button on chat page. Forces users to log out instead of navigating back.
        navigationItem.hidesBackButton = true
        
        tableView.register(UINib(nibName: Constants.cellNibName, bundle: nil), forCellReuseIdentifier: Constants.cellIdentifier)
        
        //load messages there in table view which are in firebase firestore
        loadMessages()
    }
    
    //typed message -> sent
    @IBAction func sendPressed(_ sender: UIButton) {
        if let messageSender = Auth.auth().currentUser?.email,
            let messageBody = messageTextfield.text,
            !messageBody.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            db.collection(Constants.collectionName).addDocument(data: [
                Constants.senderField: messageSender,
                Constants.bodyField: messageBody,
                Constants.dateField: Date().timeIntervalSince1970 //with sec
                ])
            {
                (error) in
                
                DispatchQueue.main.async {
                    sender.isEnabled = true   //allow next send
                }
                
                if let e = error{
                    print("Facing issue while saving data to Firebase Firestore!, \(e)")
                }
                else{
                    
                    DispatchQueue.main.async {
                        self.messageTextfield.text = ""
                        self.messageTextfield.becomeFirstResponder()
                    }
                }
            }
            
        }
    }
    
    func loadMessages() {
        
        //db.collection(Constants.collectionName).getDocuments(completion: { querySnapshot, error in
        //for live updating chats on text view
            db.collection(Constants.collectionName)
            .order(by: Constants.dateField)
            .addSnapshotListener({ querySnapshot, error in
                
            //shows updated msg only without reprinting older msgs
            self.messages = []
                
            if let e = error {
                print("Facing issue while loading data from Firestore: \(e)")
            } else {
                if let snapshotDocs = querySnapshot?.documents {
                    for doc in snapshotDocs {
                        let data = doc.data()
                        
                        if let messageSender = data[Constants.senderField] as? String,
                           let messageBody = data[Constants.bodyField] as? String {
                            
                            let newMessage = Message(sender: messageSender, body: messageBody)
                            self.messages.append(newMessage)
                        }
                    }
                    
                    // reload table view after data is fetched
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        //to scroll down to the latest message
                        let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                        self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                        
                    }
                }
            }
        })
    }

    
    
    
    @IBAction func logOut(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
            //Takes the user back to the first root screen
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
}

extension ChatViewController: UITableViewDataSource {
    
    //Tells the table view: Show one row per message
    // 1. Tells the table view how many rows there are in a given section.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // Assuming 'messages' is an array property in ChatViewController that holds the count of data to be displayed.
        return messages.count
    }
    
    // 2. Asks the data source for a cell to insert in a particular location of the table view.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let message = messages[indexPath.row]
        
        // Dequeue a reusable cell to optimize performance.
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier, for: indexPath)
        as! MessageCell
        cell.label.text = message.body
        
        
        //Distinguish:
        //this message is from current user
        if message.sender == Auth.auth().currentUser?.email {
            cell.youAvatar.isHidden = true
            cell.avatar.isHidden = false
            cell.messageField.backgroundColor = UIColor(named: Constants.lightPurple)
            cell.label.textColor = UIColor(named: Constants.purple)
        }
        //this message is from another user
        else{
            cell.avatar.isHidden = true
            cell.youAvatar.isHidden = false
            cell.messageField.backgroundColor = UIColor(named: Constants.purple)
            cell.label.textColor = UIColor(named: Constants.lightPurple)
        }
        
        return cell
    }
}

//Runs when a user taps a message
extension ChatViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        
    }
}
