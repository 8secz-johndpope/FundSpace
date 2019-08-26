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
    let storage = Storage.storage()
    var ref: DocumentReference? = nil
    var currentUser: User? = nil
    
    fileprivate var userProjectsCount = 0
    fileprivate var userProjectsResultCount = 0
    
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
                    if (error != nil) {
                        completion(nil, error)
                        return
                    }
                    
                    self.db.collection("users").document(uid!).getDocument(completion: { (document, error) in
                        if let document = document, document.exists {
                            completion(document.data(), nil)
                        } else {
                            completion([:], nil)
                        }
                    })
                })
            } else {
                completion(user, error)
            }
        }
    }
    
    
    // Log In with Email and Password
    func logInUser(email: String, password: String, completion: @escaping (Any?, Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if (error == nil) {
                let uid = user?.user.uid
                
                self.db.collection("users").document(uid!).getDocument(completion: { (document, error) in
                    if let document = document, document.exists {
                        completion(document.data(), nil)
                    } else {
                        completion([:], nil)
                    }
                })
            } else {
                completion(user, error)
            }
        }
    }
    
    
    // Log In with Social Account such as Google, Facebook
    func logInWithSocial(credential: Any, userInfo: [String: Any], completion: @escaping (Any?, Error?) -> Void) {
        Auth.auth().signIn(with: credential as! AuthCredential) { (authResult, error) in
            if let error = error {
                completion(nil, error)
            } else {
                self.storeUserInfo(id: (authResult?.user.uid)!, userInfo: userInfo, completion: { (error) in
                    if (error != nil) {
                        completion(nil, error)
                        return
                    }
                    
                    self.db.collection("users").document((authResult?.user.uid)!).getDocument(completion: { (document, error) in
                        if let document = document, document.exists {
                            completion(document.data(), nil)
                        } else {
                            completion([:], nil)
                        }
                    })
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
    
    // Upload profile image and update the user info.
    func uploadImage(imageData: Data?, completion: @escaping (String?, Error?) -> Void) {
        let user_id: String = Auth.auth().currentUser!.uid
        
        if (imageData == nil) {
            completion(user_id, nil)
            return
        }
        
        let profileRef = storage.reference().child(user_id + "/profile/profile.png")
        profileRef.putData(imageData!, metadata: nil) { (metadata, error) in
            guard let _ = metadata else {
                completion("error", error)
                return
            }
            
            profileRef.downloadURL(completion: { (url, error) in
                if (error != nil) {
                    completion("error", error)
                    return
                }
                
                if let profileImage = url?.absoluteString {
                    var tmp: [String: Any] = [:]
                    tmp["profile_pic"] = profileImage
                    
                    self.storeUserInfo(id: user_id, userInfo: tmp, completion: { (error) in
                        if error == nil {
                            completion(user_id, nil)
                        } else {
                            completion(nil, error)
                        }
                    })
                }
            })
        }
    }
    
    // Download user profile image
    func downloadImage(path: String, completion: @escaping (Data?, Error?) -> Void) {
        let profileRef = storage.reference(forURL: path)
        
        profileRef.getData(maxSize: 100 * 1024 * 1024) { (data, error) in
            completion(data, error)
        }
    }
    
    // Fetch previous projects for developer
    func fetchPreviousProjects(completion: @escaping (Array<[String: Any]>?, Error?) -> Void) {
        let user_id: String = Auth.auth().currentUser!.uid
        db.collection("users").document(user_id).getDocument(completion: { (document, error) in
            if let document = document, document.exists {
                var result: Array<[String: Any]> = []
                let prevProjectIDs: Array<String> = document.get("prevProjectIDs") as? Array<String> ?? []
                
                self.userProjectsCount = prevProjectIDs.count
                self.userProjectsResultCount = 0
                
                for prevProjectID in prevProjectIDs {
                    self.db.collection("prev_projects").document(prevProjectID).getDocument(completion: { (prevDocument, prevError) in
                        self.userProjectsResultCount += 1
                        if let prevDocument = prevDocument, prevDocument.exists {
                            var tmp: [String: Any] = prevDocument.data()!
                            tmp["id"] = prevDocument.documentID
                            result.append(tmp)
                        }
                
                        if self.userProjectsCount == self.userProjectsResultCount {
                            completion(result, nil)
                        }
                    })
                }
//                completion(result, nil)
            } else {
                completion([], error)
            }
        })
    }
    
    func updatePreviousProject(prevProject: [String: Any], completion: @escaping (Error?) -> Void) {
        let id: String = prevProject["id"] as? String ?? ""
        if id == "" {
            var ref: DocumentReference? = nil
            ref = db.collection("prev_projects").addDocument(data: prevProject) { (error) in
                if let error = error {
                    completion(error)
                } else {
                    let user_id: String = Auth.auth().currentUser!.uid
                    self.db.collection("users").document(user_id).getDocument(completion: { (document, error) in
                        if let error = error {
                            completion(error)
                            return
                        }
                        
                        var IDs: Array<String> = []
                        if let document = document, document.exists {
                            IDs = document.get("prevProjectIDs") as? Array<String> ?? []
                        }
                        
                        IDs.append(ref!.documentID)
                        
                        self.storeUserInfo(id: user_id, userInfo: ["prevProjectIDs": IDs], completion: { (error) in
                            completion(error)
                        })
                    })
                }
            }
        } else {
            db.collection("prev_projects").document(id).setData(prevProject, merge: true) { (error) in
                completion(error)
            }
        }
    }
    
    func addProject(projectInfo: [String: Any], completion: @escaping (Error?) -> Void) {
        var ref: DocumentReference? = nil
        ref = db.collection("projects").addDocument(data: projectInfo) { (error) in
            if let error = error {
                completion(error)
            } else {
                let user_id: String = Auth.auth().currentUser!.uid
                self.db.collection("users").document(user_id).getDocument(completion: { (document, error) in
                    if let error = error {
                        completion(error)
                        return
                    }
                    
                    var IDs: Array<String> = []
                    if let document = document, document.exists {
                        IDs = document.get("projectIDs") as? Array<String> ?? []
                    }
                    
                    IDs.append(ref!.documentID)
                    
                    self.storeUserInfo(id: user_id, userInfo: ["projectIDs": IDs], completion: { (error) in
                        completion(error)
                    })
                })
            }
        }
    }
}
