// Project: UserStats.swift
// EID: Jac23662
// Course: CS371L


import Foundation

class UserProfile {
    let studyTime: TimeInterval
    let slackTime: TimeInterval
    let userDict: Dictionary<String, Int>
    
    init(studyTime: TimeInterval, slackTime: TimeInterval, userDict: Dictionary<String, Int>) {
        self.studyTime = studyTime
        self.slackTime = slackTime
        self.userDict = userDict
    }
}
