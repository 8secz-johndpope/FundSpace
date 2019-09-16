//
//  Channel.swift
//  FundSpace
//
//  Created by admin on 9/16/19.
//  Copyright © 2019 Zhang Hui. All rights reserved.
//

import FirebaseFirestore

struct Channel {
    
    var id: String?
    var senderName: String
    var lastMessage: String
    var senderID: String
    var receiverID: String
    var senderUserImageURL: String
    
    init(senderName: String, lastMessage: String, senderID: String, receiverID: String, senderUserImageURL: String) {
        id = nil
        self.senderName = senderName
        self.lastMessage = lastMessage
        self.senderID = senderID
        self.receiverID = receiverID
        self.senderUserImageURL = senderUserImageURL
    }
    
    init?(document: QueryDocumentSnapshot) {
        let data = document.data()
        
        let senderName: String = data["name"] as? String ?? ""
        let lastMessage: String = data["message"] as? String ?? ""
        let senderID: String = data["sender"] as? String ?? ""
        let receiverID: String = data["receiver"] as? String ?? ""
        let senderUserImageURL: String = data["image"] as? String ?? ""
        
        id = document.documentID
        self.senderName = senderName
        self.lastMessage = lastMessage
        self.senderID = senderID
        self.receiverID = receiverID
        self.senderUserImageURL = senderUserImageURL
    }
    
}

extension Channel: DatabaseRepresentation {

    var representation: [String : Any] {
        var rep: [String: Any] = [:]
        rep["name"] = senderName
        rep["message"] = lastMessage
        rep["sender"] = senderID
        rep["receiver"] = receiverID
        rep["image"] = senderUserImageURL
        
        if let id = id {
            rep["id"] = id
        }

        return rep
    }
}

//
//extension Channel: Comparable {
//
//    static func == (lhs: Channel, rhs: Channel) -> Bool {
//        return lhs.id == rhs.id
//    }
//
//    static func < (lhs: Channel, rhs: Channel) -> Bool {
//        return lhs.name < rhs.name
//    }
//
//}
