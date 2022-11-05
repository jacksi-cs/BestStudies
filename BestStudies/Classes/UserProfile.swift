// Project: UserProfile.swift
// EID: Jac23662
// Course: CS371L


import Foundation

class UserProfile {
    let userName: String
    let email: String
    let password: String
    let profilePictureRef: String?
    let volumeOn: Bool
    let musicVolume: Int
    let settingVolume: Int
    
    init(userName: String, email: String, password: String, volumeOn: Bool, musicVolume: Int, settingVolume: Int, profilePictureRef: String = "") {
        self.userName = userName
        self.email = email
        self.password = password
        self.volumeOn = volumeOn
        self.musicVolume = musicVolume
        self.settingVolume = settingVolume

        //TODO
        self.profilePictureRef = profilePictureRef
    }
}
