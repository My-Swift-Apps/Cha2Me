//
//  ChatViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: UIViewController
{
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    
    let db = Firestore.firestore()
    var messages: [Message] = []
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        let backgroundImage = UIImageView(image: UIImage(named: "Image12"))
        self.tableView.backgroundView = backgroundImage
        self.tableView.backgroundColor = nil
        
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        messageTextfield.delegate = self
        title = K.appName
        navigationItem.hidesBackButton = true
        tableView.dataSource =  self
        
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        tableView.backgroundColor = nil
        loadMessages()
    }
    
}

//MARK: - loadMessages

extension ChatViewController
{
    func loadMessages ()
    {
        db.collection(K.FStore.collectionName)
            .order(by: K.FStore.dateField)
            .addSnapshotListener { (querySnapshot, error) in
                self.messages = []
                if let e = error
                {
                    print("there was an issue saving the data to firestore, \(e)")
                }
                else
                {
                    if let snapshotDocuments = querySnapshot?.documents
                    {
                        for doc in snapshotDocuments
                        {
                            let data = doc.data()
                            if let messageSender = data[K.FStore.senderField] as? String, let messageBody = data[K.FStore.bodyField] as? String
                            {
                                let newMessage = Message (sender: messageSender , body: messageBody)
                                self.messages.append(newMessage)
                                DispatchQueue.main.async
                                    {
                                        self.tableView.reloadData()
                                        // to get to the last message that was send we acan call
                                        let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                                        self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                                }
                            }
                        }
                    }
                }
        }
   }
}

//MARK: - UITableViewDataSource
/*
 UITableViewDataSource is a protocol which responisable for populating the text table view by telling it how many cells it needs and which cell to put in the table view
 */
extension ChatViewController: UITableViewDataSource
{
    //number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        //to return the number of the messages denamically
        return messages.count
    }
    //position of the message in the sell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let message = messages[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath)
            as! MessageCell
        cell.label.text = message.body
        
        //this is a message from the current user
        if message.sender == Auth.auth().currentUser?.email
        {
            cell.leftImageView.isHidden = true
            cell.rightImageView.isHidden = false
            cell.messageBuble.backgroundColor = UIColor(named: K.BrandColors.lighBlue)
            cell.label.textColor = UIColor(named: K.BrandColors.purple)
        }
        else
        {
            cell.leftImageView.isHidden = false
            cell.rightImageView.isHidden = true
            cell.messageBuble.backgroundColor = UIColor(named: K.BrandColors.purple)
            cell.label.textColor = UIColor(named: K.BrandColors.lightPurple)
        }
        
        return cell
    }
}

//MARK: - Sender

extension ChatViewController
{
    @IBAction func sendPressed(_ sender: UIButton)
    {
        if (messageTextfield.text != "")
        {
            if let messageBody = messageTextfield.text, let messageSender = Auth.auth().currentUser?.email
            {
                db.collection(K.FStore.collectionName).addDocument(data:[
                    K.FStore.senderField: messageSender,
                    K.FStore.bodyField: messageBody,
                    K.FStore.dateField: Date().timeIntervalSince1970
                ]){ (error) in
                    if let e = error
                    {
                        print("there was an issue saving the data to firestore, \(e)")
                    }
                    else
                    {
                        //now checking if there was anything written in the textfield
                        print("successfully saved data.")
                        DispatchQueue.main.async
                            {
                                self.messageTextfield.text = ""
                            }
                    }
                }
            }
        }
        else
        {
            messageTextfield.placeholder = "Please enter a message"
        }
        
        
    }
}

//MARK: - LogOut

extension ChatViewController
{
    @IBAction func logoutPressed(_ sender: UIBarButtonItem)
    {
        do
        {
            try Auth.auth().signOut()
            //in here is where we will navigate the user to the welcome page
            navigationController?.popToRootViewController(animated: true)
            
            
        }
        catch let signOutError as NSError
        {
            print ("Error signing out: %@", signOutError)
        }
    }
}

//MARK: - UITextFieldDelegate
extension ChatViewController: UITextFieldDelegate
{
    //checking if the searchBar is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //option to see if the searchBar has endEdition
        if (messageTextfield.text != "")
        {
            if let messageBody = messageTextfield.text, let messageSender = Auth.auth().currentUser?.email
            {
                db.collection(K.FStore.collectionName).addDocument(data:[
                    K.FStore.senderField: messageSender,
                    K.FStore.bodyField: messageBody,
                    K.FStore.dateField: Date().timeIntervalSince1970
                ]){ (error) in
                    if let e = error
                    {
                        print("there was an issue saving the data to firestore, \(e)")
                    }
                    else
                    {
                        //now checking if there was anything written in the textfield
                        print("successfully saved data.")
                        DispatchQueue.main.async
                            {
                                self.messageTextfield.text = ""
                            }
                    }
                }
            }
        }
        else
        {
            messageTextfield.placeholder = "Please enter a message"
        }
        messageTextfield.endEditing(true)
        return true
    }
}
