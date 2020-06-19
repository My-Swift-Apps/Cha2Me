//
//  Constant.swift
//  Flash Chat iOS13
//
//  Created by Mero on 2020-05-12.
//  Copyright © 2020 Angela Yu. All rights reserved.
//

//in here we will be colecting all the contstant in a struct so all we have to do is just call them and not have any typo

struct K
{
    static let appName = "⚡️ FlashChat"
    static let cellIdentifier = "ReusableCell"
    static let cellNibName = "MessageCell"
    static let registerSegue = "RegisterToChat"
    static let loginSegue = "LoginToChat"
    
    struct BrandColors {
        static let purple = "BrandPurple"
        static let lightPurple = "BrandLightPurple"
        static let blue = "BrandBlue"
        static let lighBlue = "BrandLightBlue"
    }
    
    struct FStore {
        static let collectionName = "messages"
        static let senderField = "sender"
        static let bodyField = "body"
        static let dateField = "date"
    }
}
