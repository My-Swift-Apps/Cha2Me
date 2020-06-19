//
//  RegisterViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var messageLabel: UILabel!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        emailTextfield.delegate = self
        passwordTextfield.delegate = self
        messageLabel.isHidden = true
        title = K.appName
    }
    
    @IBAction func registerPressed(_ sender: UIButton)
    {
        // use optional binding to turn emailtext to String that to make sure that we wont have nil as a return
        if let email = emailTextfield.text, let password = passwordTextfield.text
        {
            Auth.auth().createUser(withEmail: email, password: password)
            {
                //using closure
                authResult, error
                in
                //this to turn the optional "error" to non optional if it existed
                if let e = error
                {   //the localizedDescription is used to transform lang to the lang of users' phone
                    self.messageLabel.isHidden = false
                    self.messageLabel.text = """
                    \(e.localizedDescription)
                    """
                    print(e.localizedDescription)
                    let alert = UIAlertController(title: "\(e.localizedDescription)", message: "", preferredStyle: .alert)
                    //this the button that will be pressed to add the item to the list
                    let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
                        //what will happen once the user click the add item button on our UIAlert
                        print("success!")
                    }
                    alert.addAction(action)
                    // to show our alert
                    self.present(alert, animated: true, completion: nil)
                }
                else
                {
                    //Navigate to the ChatViewController
                    self.performSegue(withIdentifier: K.registerSegue , sender: self)
                }
            }
        }
    }
    
}

//MARK: - UITextFieldDelegate
extension RegisterViewController: UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        if let email = emailTextfield.text, let password = passwordTextfield.text
        {
            Auth.auth().signIn(withEmail: email, password: password)
            {
                authResult, error in
                if let e = error
                {   //the localizedDescription is used to transform lang to the lang of users' phone
                    self.messageLabel.isHidden = false
                    self.messageLabel.text = """
                    \(e.localizedDescription)
                    """
                    print(e.localizedDescription)
                }
                else
                {
                    //Navigate to the ChatViewController
                    self.performSegue(withIdentifier: K.loginSegue , sender: self)
                }
            }
        }
        return true
    }
}
