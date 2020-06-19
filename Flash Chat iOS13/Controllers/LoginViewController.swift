//
//  LoginViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import Firebase
class LoginViewController: UIViewController {
    
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
    
    @IBAction func loginPressed(_ sender: UIButton)
    {
        // use optional binding to turn emailtext to String that to make sure that we wont have nil as a return
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
    }
    
}

//MARK: - UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate
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
