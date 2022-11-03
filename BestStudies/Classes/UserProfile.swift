// Project: UserProfile.swift
// EID: Jac23662
// Course: CS371L


import Foundation

class UserProfile {
    let userName: String
    let email: String
    let password: String
    let profilePictureRef: String?
    
    init(userName: String, email: String, password: String, profilePictureRef: String = "") {
        self.userName = userName
        self.email = email
        self.password = password
        //TODO
        self.profilePictureRef = profilePictureRef
    }
}
