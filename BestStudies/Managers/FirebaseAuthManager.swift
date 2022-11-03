// Project: FirebaseAuthManager.swift
// EID: Jac23662
// Course: CS371L


import Foundation
import FirebaseAuth
import UIKit

//Auth Manager singleton class used to more readably evoke auth functions
final class AuthManager {
    static let shared = AuthManager()
    
    private let auth = Auth.auth()
    
    private init() {}
    
    public var isSignedIn: Bool {
        return auth.currentUser != nil
    }
    
    public func signUp (
        email: String,
        userName: String,
        password: String,
        errorLabel: UILabel,
        completion: @escaping (Bool) -> Void
    ) {
        guard !email.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.trimmingCharacters(in: .whitespaces).isEmpty,
              password.count >= 6 else {
            return
        }
        
        auth.createUser(withEmail: email, password: password) {
                authResult, error in
                if let error = error as NSError? {
                    errorLabel.text = "\(error.localizedDescription)"
                } else {
                    errorLabel.text = ""
                }
            }
            UserDefaults.standard.set(email, forKey: "email")
            UserDefaults.standard.set(userName, forKey: "userName")
            //TODO Don't store passwords in User Defaults
            UserDefaults.standard.set(password, forKey: "password")
            
            completion(true)
        }
    
    public func signIn (
        email: String,
        password: String,
        errorLabel: UILabel,
        completion: @escaping (Bool) -> Void
        
    ) {
        guard !email.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.trimmingCharacters(in: .whitespaces).isEmpty,
              password.count >= 6 else {
            return
        }
        
        auth.signIn(withEmail: email, password: password) {
            result, error in
            if let error = error as NSError? {
                errorLabel.text = "\(error.localizedDescription)"
            } else {
                errorLabel.text = ""
            }
            guard result != nil, error == nil else {
                completion(false)
                return
            }
            completion(true)
        }
    }
    
    public func signOut() {
        do {
            try auth.signOut()
            UserDefaults.standard.set("", forKey: "email")
            UserDefaults.standard.set("", forKey: "userName")
            //TODO Don't store passwords in User Defaults
            UserDefaults.standard.set("", forKey: "password")
        }
        catch {
            print(error)
        }
    }
    
    public func deleteAccount() {
        auth.currentUser?.delete()
        signOut()
    }
    
    public func changeEmail(email: String) {
        auth.currentUser?.updateEmail(to: email)
    }
    
    public func changeUsername(username: String) {
        
    }
    
    public func changePassword(password: String) {
        auth.currentUser?.updatePassword(to: password)
        
    }
    
    public func getCurrentEmail() -> String {
        return (auth.currentUser?.email)!
    }
    
//    public func getCurrentPassword() -> String {
//        return (auth.currentUser?.password)!
//    }
}
