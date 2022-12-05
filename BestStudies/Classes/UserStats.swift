// Project: UserStats.swift
// EID: Jac23662
// Course: CS371L

import Foundation

class UserStats {
    
    static let shared = UserStats()
    
    var studyTime = 0.0
    var slackTime = 0.0
    var totalSessions = 0
    var topStudyTime = 0.0
    var worstSlackTime = 0.0
    var topBuddy = ""
    var userDict: Dictionary<String, Int> = [:]
    
    private init(){}
    
    public func setStats(studyTime: TimeInterval, slackTime: TimeInterval, totalSessions: Int, topStudyTime: TimeInterval, worstSlackTime: TimeInterval, topBuddy: String, userDict: Dictionary<String, Int>) {
        self.studyTime = studyTime
        self.slackTime = slackTime
        self.totalSessions = totalSessions
        self.topStudyTime = topStudyTime
        self.worstSlackTime = worstSlackTime
        self.topBuddy = topBuddy
        self.userDict = userDict
    }
    
    public func updateStats(studyTime: TimeInterval, slackTime: TimeInterval, names: Array<String>) {
        self.studyTime += studyTime
        self.slackTime += slackTime
        self.totalSessions += 1
        self.topStudyTime = max(studyTime, self.topStudyTime)
        self.worstSlackTime = max(slackTime, self.worstSlackTime)
        if names.count <= 1 {
            self.topBuddy = "No buddies yet!"
        }
        else {
            for (userName, times) in self.userDict {
                for name in names {
                    if userName == name {
                        userDict[userName] = 1 + times
                    }
                }
            }
            let entry = userDict.max { a, b in a.value < b.value }
            self.topBuddy = entry!.0
        }
        
        DatabaseManager.shared.setStats{
            [weak self] success in
            guard success else {
                return
            }
        }
    }
}
