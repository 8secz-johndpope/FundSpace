//
//  Message.swift
//  FundSpace
//
//  Created by admin on 9/16/19.
//  Copyright © 2019 Zhang Hui. All rights reserved.
//

import Foundation
import CoreLocation
import MessageKit
import AVFoundation

import Firebase
import FirebaseFirestore

struct ChatImageMediaItem: MediaItem {

    var url: URL?
    var image: UIImage?
    var placeholderImage: UIImage
    var size: CGSize

    init(image: UIImage) {
        self.image = image
        self.size = CGSize(width: 200, height: 160)
        self.placeholderImage = UIImage()
    }

}
//
//struct ChatAudioItem: AudioItem {
//
//    var url: URL
//    var size: CGSize
//    var duration: Float
//
//    init(url: URL) {
//        self.url = url
//        self.size = CGSize(width: 160, height: 35)
//        // compute duration
//        let audioAsset = AVURLAsset(url: url)
//        self.duration = Float(CMTimeGetSeconds(audioAsset.duration))
//    }
//
//}
//
//struct ChatContactItem: ContactItem {
//
//    var displayName: String
//    var initials: String
//    var phoneNumbers: [String]
//    var emails: [String]
//
//    init(name: String, initials: String, phoneNumbers: [String] = [], emails: [String] = []) {
//        self.displayName = name
//        self.initials = initials
//        self.phoneNumbers = phoneNumbers
//        self.emails = emails
//    }
//
//}

//internal struct Message: MessageType {
//
//    var messageId: String
//    var sender: SenderType {
//        return user
//    }
//    var sentDate: Date
//    var kind: MessageKind
//
//    var user: User
//
//    var imageURL: URL? = nil
//
//    private init(kind: MessageKind, user: User, messageId: String, date: Date) {
//        self.kind = kind
//        self.user = user
//        self.messageId = messageId
//        self.sentDate = date
//    }
//
//    init(custom: Any?, user: User, messageId: String, date: Date) {
//        self.init(kind: .custom(custom), user: user, messageId: messageId, date: date)
//    }
//
//    init(text: String, user: User, messageId: String, date: Date) {
//        self.init(kind: .text(text), user: user, messageId: messageId, date: date)
//    }
//
//    init(attributedText: NSAttributedString, user: User, messageId: String, date: Date) {
//        self.init(kind: .attributedText(attributedText), user: user, messageId: messageId, date: date)
//    }
//
//    init(image: UIImage, user: User, messageId: String, date: Date) {
//        let mediaItem = ChatImageMediaItem(image: image)
//        self.init(kind: .photo(mediaItem), user: user, messageId: messageId, date: date)
//    }
//
//    init(thumbnail: UIImage, user: User, messageId: String, date: Date) {
//        let mediaItem = ChatImageMediaItem(image: thumbnail)
//        self.init(kind: .video(mediaItem), user: user, messageId: messageId, date: date)
//    }
//
//    init(location: CLLocation, user: User, messageId: String, date: Date) {
//        let locationItem = ChatCoordinateItem(location: location)
//        self.init(kind: .location(locationItem), user: user, messageId: messageId, date: date)
//    }
//
//    init(emoji: String, user: User, messageId: String, date: Date) {
//        self.init(kind: .emoji(emoji), user: user, messageId: messageId, date: date)
//    }
//
//    init(audioURL: URL, user: User, messageId: String, date: Date) {
//        let audioItem = ChatAudioItem(url: audioURL)
//        self.init(kind: .audio(audioItem), user: user, messageId: messageId, date: date)
//    }
//
//    init(contact: ChatContactItem, user: User, messageId: String, date: Date) {
//        self.init(kind: .contact(contact), user: user, messageId: messageId, date: date)
//    }
//
//    init?(document: QueryDocumentSnapshot) {
//        let data = document.data()
//
//        let date: Date = data["created"] as? Date ?? Date()
//        let id: String = document.documentID
//
//        let userID: String = data["senderID"] as? String ?? ""
//        let user: User = User(senderId: userID, displayName: "")
//
//        let message: String = data["message"] as? String ?? ""
//
//        if message != "" {
//            self.init(text: message, user: user, messageId: id, date: date)
//        } else if let urlString = data["url"] as? String, let url = URL(string: urlString) {
//            self.init(text: "", user: user, messageId: id, date: date)
//            self.imageURL = url
//        } else {
//            return nil
//        }
//    }
//}

struct Message: MessageType {
    
    let id: String?
    let content: String
    var sender: SenderType
    var messageId: String {
        return id ?? UUID().uuidString
    }
    var sentDate: Date
    var kind: MessageKind {
        if let image = image {
            let mediaItem = ChatImageMediaItem(image: image)
            return .photo(mediaItem)
        } else {
            return .text(content)
        }
    }
    
    var image: UIImage? = nil
    var downloadURL: URL? = nil
    
    init(userID: String, content: String) {
        sender = Sender(id: userID, displayName: "")
        self.content = content
        sentDate = Date()
        id = nil
    }
    
    init(userID: String, image: UIImage) {
        sender = Sender(id: userID, displayName: "")
        self.image = image
        content = ""
        sentDate = Date()
        id = nil
    }
    
    init?(document: QueryDocumentSnapshot) {
        let data = document.data()
        
        let sentDate: Date = data["created"] as? Date ?? Date()
        let senderID: String = data["senderID"] as? String ?? ""
        let content: String = data["content"] as? String ?? ""
        
        id = document.documentID
        
        self.sentDate = sentDate
        sender = Sender(id: senderID, displayName: "")
        
        if content != "" {
            self.content = content
            downloadURL = nil
        } else if let urlString = data["url"] as? String, let url = URL(string: urlString) {
            downloadURL = url
            self.content = ""
        } else {
            return nil
        }
    }
}

extension Message: Comparable {
    
    static func == (lhs: Message, rhs: Message) -> Bool {
        return lhs.id == rhs.id
    }
    
    static func < (lhs: Message, rhs: Message) -> Bool {
        return lhs.sentDate < rhs.sentDate
    }
    
}
