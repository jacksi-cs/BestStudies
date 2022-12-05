// Project: FirebaseDatabaseManager.swift
// EID: Jac23662
// Course: CS371L


import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore

final class DatabaseManager {
    static let shared = DatabaseManager()
    
    private let database = Firestore.firestore()
    private var user = UserStats.shared
    
    private init() {
        //user = UserStats(studyTime: 0, slackTime: 0, totalSessions: 0, topStudyTime: 0, worstSlackTime: 0, topBuddy: "", userDict: [:])
    }
    
    public func setStats(
        completion: @escaping (Bool) -> Void
    ) {
        let documentId = AuthManager.shared.getCurrentEmail()
            .replacingOccurrences(of: ".", with: "_")
            .replacingOccurrences(of: "@", with: "_")
        
        let data: [String: Any] = [
            "studyTime": user.studyTime,
            "slackTime": user.slackTime,
            "totalSessions" : user.totalSessions,
            "topStudyTime" : user.topStudyTime,
            "worstSlackTime" : user.worstSlackTime,
            "topBuddy" : user.topBuddy,
            "otherUsers": user.userDict
        ]
        
        database
            .collection("userStats")
            .document(documentId)
            .setData(data) { error in
                completion(error == nil)
            }
    }
    
    public func getStats(
        completion: @escaping (Bool) -> Void
    ) -> Void {
        let documentId = AuthManager.shared.getCurrentEmail()
            .replacingOccurrences(of: ".", with: "_")
            .replacingOccurrences(of: "@", with: "_")
        
        database
            .collection("userStats")
            .document(documentId)
            .getDocument { [self] snapshot, error in
                guard let data = snapshot?.data(),
                      let studyTime = data["studyTime"],
                      let slackTime = data["slackTime"],
                      let totalSessions = data["totalSessions"],
                      let topStudyTime = data["topStudyTime"],
                      let worstSlackTime = data["worstSlackTime"],
                      let topBuddy = data["topBuddy"],
                      let userDict = data["otherUsers"],
                      error == nil else {
                    print("ERROR")
                    completion(false)
                    return
                }
                user.setStats(studyTime: studyTime as! TimeInterval, slackTime: slackTime as! TimeInterval, totalSessions: totalSessions as! Int, topStudyTime: topStudyTime as! TimeInterval, worstSlackTime: worstSlackTime as! TimeInterval, topBuddy: topBuddy as! String, userDict: userDict as! Dictionary<String, Int>)
                
                completion(true)
            }
        
    }
    
    public func getCache() -> UserStats{
        return user
    }
    
    public func updateStats(studyTime: TimeInterval, slackTime: TimeInterval, names: Array<String>) -> Void {
        user.updateStats(studyTime: studyTime, slackTime: slackTime, names: names)
    }
}
