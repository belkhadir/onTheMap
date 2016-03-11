//
//  LoginProvider.swift
//  onTheMaP
//
//  Created by Anas Belkhadir on 21/11/2015.
//  Copyright © 2015 Anas Belkhadir. All rights reserved.
//


struct LoginUser {
    let email: String
    let password: String
    init(email: String, password: String){
        self.email = email
        self.password = password
    }
    func isValid() -> Bool{
        return email != "" && password != ""
    }
}
