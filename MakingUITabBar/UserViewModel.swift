//
//  UserViewModel.swift
//  MakingUITabBar
//
//  Created by Jumpei Kowashi on 2022/09/18.
//

import UIKit

struct User {
    let userID: String
    let username: String
    
    init(userID: String, username: String) {
        self.userID = userID
        self.username = username
    }
}

class UserViewModel {
    @Published var user = User(userID: "AAA", username: "Ryoma")
    
    init() {}
    
    func changeUser(_ userID: String, _ username: String) {
        user = User(userID: userID, username: username)
    }
}
