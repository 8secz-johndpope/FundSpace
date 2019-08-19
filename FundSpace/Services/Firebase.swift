//
//  Firebase.swift
//  FundSpace
//
//  Created by admin on 8/18/19.
//  Copyright © 2019 Zhang Hui. All rights reserved.
//

import UIKit
import Firebase

class FirebaseService {
    static let sharedInstance = FirebaseService()
    let db = Firestore.firestore()
    var ref: DocumentReference? = nil
    var currentUser: User? = nil
    
    init() {
        currentUser = Auth.auth().currentUser
    }
    
    
    // Sign Up with Email and Password
    func signUpUser(userInfo: [String: Any], completion: @escaping (Any?, Error?) -> Void) {
        Auth.auth().createUser(withEmail: userInfo["email"] as! String, password: userInfo["password"] as! String) { (user, error) in
            if error == nil {
                let uid = user?.user.uid
                var tmp: [String: Any] = userInfo
                tmp.removeValue(forKey: "password")
                self.storeUserInfo(id: uid!, userInfo: tmp, completion: { (error) in
                    completion(user, error)
                })
            } else {
                completion(user, error)
            }
        }
    }
    
    
    // Log In with Email and Password
    func logInUser(email: String, password: String, completion: @escaping (AuthDataResult?, Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            completion(user, error)
        }
    }
    
    
    // Log In with Social Account such as Google, Facebook
    func logInWithSocial(credential: Any, userInfo: [String: Any], completion: @escaping (AuthDataResult?, Error?) -> Void) {
        Auth.auth().signInAndRetrieveData(with: credential as! AuthCredential) { (authResult, error) in
            if let error = error {
                completion(nil, error)
            } else {
                self.storeUserInfo(id:     (authResult?.user.uid)!, userInfo: userInfo, completion: { (error) in
                    if error == nil {
                        completion(authResult, nil)
                    } else {
                        completion(nil, error)
                    }
                })
            }
        }
    }
    
    
    // Update current user information
    func storeUserInfo(id: String, userInfo: [String: Any], completion: @escaping (Error?) -> Void) {
        db.collection("users").document(id).setData(userInfo, merge: true, completion: { (error) in
            if let error = error {
                completion(error)
            } else {
                completion(nil)
            }
        })
    }
    
    
    // Reset Password
    func resetPasswordWithEmail(email: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            completion(error)
        }
    }
    
    func uploadImage(imageData: Data, completion: @escaping (String?, Error?) -> Void) {
    }
}
