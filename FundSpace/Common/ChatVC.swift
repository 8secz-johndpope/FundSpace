//
//  ChatVC.swift
//  FundSpace
//
//  Created by admin on 9/13/19.
//  Copyright © 2019 Zhang Hui. All rights reserved.
//

import UIKit
import MessageKit
import InputBarAccessoryView
import Firebase
import FirebaseFirestore

class ChatVC: MessagesViewController, MessagesDataSource {
    
    var inputBar: InputBarAccessoryView = InputBarAccessoryView()
    let refreshControl = UIRefreshControl()
    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    
    var userName: String = ""
    var userProfileImage: UIImage = UIImage(named: "default_avatar")!
    var messageList: [Message] = []
    var channel: Channel!
    
    var currentUserID: String = Auth.auth().currentUser!.uid
    
    private let db = Firestore.firestore()
    private var reference: CollectionReference?
    private let storage = Storage.storage().reference()
    private var messageListener: ListenerRegistration?
    
    /// The object that manages attachments
    open lazy var attachmentManager: AttachmentManager = { [unowned self] in
        let manager = AttachmentManager()
        manager.delegate = self
        return manager
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureMessageCollectionView()
        configureMessageInputBar()
        configureNavigationTitleBar()
        loadMessages()
        
        if let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout {
            layout.textMessageSizeCalculator.outgoingAvatarSize = .zero
            layout.textMessageSizeCalculator.incomingAvatarSize = .zero
            layout.photoMessageSizeCalculator.incomingAvatarSize = .zero
            layout.photoMessageSizeCalculator.outgoingAvatarSize = .zero
            layout.setMessageIncomingAvatarSize(.zero)
        }
    }
    
    @objc func loadMoreMessages() {
        self.refreshControl.endRefreshing()
    }
    
    func configureMessageCollectionView() {
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messageCellDelegate = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        
        scrollsToBottomOnKeyboardBeginsEditing = true // default false
        maintainPositionOnKeyboardFrameChanged = true // default false
        
        messagesCollectionView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(loadMoreMessages), for: .valueChanged)
    }
    
    func configureMessageInputBar() {
        inputBar = ChatInputView()
        inputBar.delegate = self
        inputBar.inputPlugins = [attachmentManager]
        messageInputBar = inputBar
    }
    
    func configureNavigationTitleBar() {
        let titleView: ChatViewNavigationCell = Bundle.main.loadNibNamed("ChatViewNavigationCell", owner: self, options: nil)?.first as! ChatViewNavigationCell
        titleView.profileImageView.image = userProfileImage
        titleView.userNameLabel.text = userName
        titleView.activeView.backgroundColor = UIColor(red: 0, green: 0.49, blue: 1, alpha: 1)

        let uiView = UIView()
        uiView.addSubview(titleView)
        
        navigationItem.titleView = uiView
    }

    func loadMessages() {
        guard let id = channel.id else {
            navigationController?.popViewController(animated: true)
            return
        }
        
        reference = db.collection(["channels", id, "thread"].joined(separator: "/"))
        
        messageListener = reference?.addSnapshotListener { querySnapshot, error in
            guard let snapshot = querySnapshot else {
                print("Error listening for channel updates: \(error?.localizedDescription ?? "No error")")
                return
            }
            
            snapshot.documentChanges.forEach { change in
                self.handleDocumentChange(change)
            }
        }
    }
    
    func sendNotification() {
        let receiverID: String = channel.receiverID
        let senderID: String = channel.senderID
        let id: String = currentUserID == receiverID ? senderID : receiverID
        
        let notification = [
            "receiver": id,
            "type": "message"
        ]
        
        FirebaseService.sharedInstance.sendNotification(notificationInfo: notification) { (error) in
            
        }
    }
    
    private func handleDocumentChange(_ change: DocumentChange) {
        guard var message = Message(document: change.document) else {
            return
        }
        
        switch change.type {
        case .added:
            if let url = message.downloadURL {
                downloadImage(at: url) { [weak self] image in
                    guard let `self` = self else {
                        return
                    }
                    guard let image = image else {
                        return
                    }
                    
                    message.image = image
                    self.insertNewMessage(message)
                }
            } else {
                insertNewMessage(message)
            }
            
        default:
            break
        }
    }
    
    private func insertNewMessage(_ message: Message) {
        guard !messageList.contains(message) else {
            return
        }
        
        messageList.append(message)
        
        messageList.sort()
        
        messagesCollectionView.reloadData()
        
        DispatchQueue.main.async {
            self.messagesCollectionView.scrollToBottom(animated: true)
        }

    }
    
    private func downloadImage(at url: URL, completion: @escaping (UIImage?) -> Void) {
        let ref = Storage.storage().reference(forURL: url.absoluteString)
        let megaByte = Int64(1 * 1024 * 1024)
        
        ref.getData(maxSize: megaByte) { data, error in
            guard let imageData = data else {
                completion(nil)
                return
            }
            
            completion(UIImage(data: imageData))
        }
    }
    
    private func uploadImage(_ image: UIImage, to channel: Channel, completion: @escaping (URL?) -> Void) {
        guard let channelID = channel.id else {
            completion(nil)
            return
        }
        
        guard let scaledImage = image.scaledToSafeUploadSize, let data = scaledImage.jpegData(compressionQuality: 0.4) else {
            completion(nil)
            return
        }
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        let imageName = [UUID().uuidString, String(Date().timeIntervalSince1970)].joined()
        let imageRef = storage.child(channelID).child(imageName)
        imageRef.putData(data, metadata: metadata) { meta, error in
            guard let _ = meta else {
                completion(nil)
                return
            }
            imageRef.downloadURL(completion: { (url, error) in
                if (error != nil) {
                    completion(nil)
                    return
                }
                
                completion(url)
            })
        }
    }
    
    // MARK: - MessagesDataSource
    
    func currentSender() -> SenderType {
        return User(senderId: currentUserID, displayName: "")
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messageList.count
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messageList[indexPath.section]
    }
    
    func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        if indexPath.section % 3 == 0 {
            return NSAttributedString(string: MessageKitDateFormatter.shared.string(from: message.sentDate), attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10), NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        }
        return nil
    }
    
    func cellBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        
        return NSAttributedString(string: "Read", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10), NSAttributedString.Key.foregroundColor: UIColor.darkGray])
    }
    
    func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let name = message.sender.displayName
        return NSAttributedString(string: name, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption1)])
    }
    
    func messageBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        
        let dateString = formatter.string(from: message.sentDate)
        return NSAttributedString(string: dateString, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption2)])
    }

}

extension ChatVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        
        
        dismiss(animated: true, completion: {
            if let pickedImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage {
                let handled = self.attachmentManager.handleInput(of: pickedImage)
                if !handled {
                    // throw error
                }
            }
        })
    }
}

extension ChatVC: AttachmentManagerDelegate {
    // MARK: - AttachmentManagerDelegate
    
    func attachmentManager(_ manager: AttachmentManager, shouldBecomeVisible: Bool) {
        setAttachmentManager(active: shouldBecomeVisible)
    }
    
    func attachmentManager(_ manager: AttachmentManager, didReloadTo attachments: [AttachmentManager.Attachment]) {
        inputBar.sendButton.isEnabled = manager.attachments.count > 0
    }
    
    func attachmentManager(_ manager: AttachmentManager, didInsert attachment: AttachmentManager.Attachment, at index: Int) {
        inputBar.sendButton.isEnabled = manager.attachments.count > 0
    }
    
    func attachmentManager(_ manager: AttachmentManager, didRemove attachment: AttachmentManager.Attachment, at index: Int) {
        inputBar.sendButton.isEnabled = manager.attachments.count > 0
    }
    
    func attachmentManager(_ manager: AttachmentManager, didSelectAddAttachmentAt index: Int) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
//        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    // MARK: - AttachmentManagerDelegate Helper
    
    func setAttachmentManager(active: Bool) {
        
        let topStackView = inputBar.topStackView
        if active && !topStackView.arrangedSubviews.contains(attachmentManager.attachmentView) {
            topStackView.insertArrangedSubview(attachmentManager.attachmentView, at: topStackView.arrangedSubviews.count)
            topStackView.layoutIfNeeded()
        } else if !active && topStackView.arrangedSubviews.contains(attachmentManager.attachmentView) {
            topStackView.removeArrangedSubview(attachmentManager.attachmentView)
            topStackView.layoutIfNeeded()
        }
    }
}

// MARK: - MessageCellDelegate
extension ChatVC: MessageCellDelegate {
    
    func didTapAvatar(in cell: MessageCollectionViewCell) {
        print("Avatar tapped")
    }
    
    func didTapMessage(in cell: MessageCollectionViewCell) {
        print("Message tapped")
    }
    
    func didTapCellTopLabel(in cell: MessageCollectionViewCell) {
        print("Top cell label tapped")
    }
    
    func didTapCellBottomLabel(in cell: MessageCollectionViewCell) {
        print("Bottom cell label tapped")
    }
    
    func didTapMessageTopLabel(in cell: MessageCollectionViewCell) {
        print("Top message label tapped")
    }
    
    func didTapMessageBottomLabel(in cell: MessageCollectionViewCell) {
        print("Bottom label tapped")
    }
    
    func didTapPlayButton(in cell: AudioMessageCell) {
        
    }
    
    func didStartAudio(in cell: AudioMessageCell) {
        print("Did start playing audio sound")
    }
    
    func didPauseAudio(in cell: AudioMessageCell) {
        print("Did pause audio sound")
    }
    
    func didStopAudio(in cell: AudioMessageCell) {
        print("Did stop audio sound")
    }
    
    func didTapAccessoryView(in cell: MessageCollectionViewCell) {
        print("Accessory view tapped")
    }
}

// MARK: - MessageLabelDelegate
extension ChatVC: MessageLabelDelegate {
    
    func didSelectAddress(_ addressComponents: [String: String]) {
        print("Address Selected: \(addressComponents)")
    }
    
    func didSelectDate(_ date: Date) {
        print("Date Selected: \(date)")
    }
    
    func didSelectPhoneNumber(_ phoneNumber: String) {
        print("Phone Number Selected: \(phoneNumber)")
    }
    
    func didSelectURL(_ url: URL) {
        print("URL Selected: \(url)")
    }
    
    func didSelectTransitInformation(_ transitInformation: [String: String]) {
        print("TransitInformation Selected: \(transitInformation)")
    }
    
    func didSelectHashtag(_ hashtag: String) {
        print("Hashtag selected: \(hashtag)")
    }
    
    func didSelectMention(_ mention: String) {
        print("Mention selected: \(mention)")
    }
    
    func didSelectCustom(_ pattern: String, match: String?) {
        print("Custom data detector patter selected: \(pattern)")
    }
    
}

// MARK: - MessageInputBarDelegate
extension ChatVC: InputBarAccessoryViewDelegate {
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        
        // Here we can parse for which substrings were autocompleted
        let attributedText = messageInputBar.inputTextView.attributedText!
        let range = NSRange(location: 0, length: attributedText.length)
        attributedText.enumerateAttribute(.autocompleted, in: range, options: []) { (_, range, _) in
            
            let substring = attributedText.attributedSubstring(from: range)
            let context = substring.attribute(.autocompletedContext, at: 0, effectiveRange: nil)
            print("Autocompleted: `", substring, "` with context: ", context ?? [])
        }
        
        let attachments = attachmentManager.attachments
        let user = User(senderId: currentUserID, displayName: "")
        
        messageInputBar.inputTextView.text = String()
        messageInputBar.invalidatePlugins()
        
        // Send button activity animation
        messageInputBar.sendButton.startAnimating()
        messageInputBar.inputTextView.placeholder = "Sending..."
        
        if text != "" {
            let messageData = [
                "created": Date(),
                "senderID": user.senderId,
                "content": text,
                "url": nil
            ] as [String : Any?]
            
            db.collection(["channels", channel.id!, "thread"].joined(separator: "/")).addDocument(data: messageData as [String : Any]) { error in
                if let e = error {
                    print("Error sending message: \(e.localizedDescription)")
                    return
                }
                
                if (attachments.count == 0) {
                    self.messageInputBar.sendButton.stopAnimating()
                    self.messageInputBar.inputTextView.placeholder = "Aa"
                    self.messagesCollectionView.scrollToBottom(animated: true)
                    
                    self.sendNotification()
                }
            }
        }
        
        for attachment in attachments {
            switch attachment {
            case .image(let image):
                var ref: DocumentReference? = nil
                uploadImage(image, to: channel) { [weak self] url in
                    let messageData = [
                        "created": Date(),
                        "senderID": user.senderId,
                        "content": "",
                        "url": url?.absoluteString
                    ] as [String : Any?]
                    
                    self!.db.collection(["channels", self!.channel.id!, "thread"].joined(separator: "/")).addDocument(data: messageData as [String : Any]) { error in
                        if let e = error {
                            print("Error sending message: \(e.localizedDescription)")
                            return
                        }
                        self!.messageInputBar.sendButton.stopAnimating()
                        self!.messageInputBar.inputTextView.placeholder = "Aa"
                        self!.messagesCollectionView.scrollToBottom(animated: true)
                    }
                }
            default:
                break
            }
            
        }
        
        if attachments.count > 0 {
            sendNotification()
        }
    }
}

// MARK: - MessagesDisplayDelegate
extension ChatVC: MessagesDisplayDelegate {
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        let opponentColor = UIColor(red: 0.8, green: 0.9, blue: 1, alpha: 1)
        let defaultColor = UIColor.lightGray.withAlphaComponent(0.6)
        return isFromCurrentSender(message: message) ? defaultColor : opponentColor
    }
    
    func shouldDisplayHeader(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> Bool {
        return false
    }
    
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        let corner: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
        return .bubbleTail(corner, .curved)
    }
    
}

// MARK: - MessagesLayoutDelegate
extension ChatVC: MessagesLayoutDelegate {
    
    func avatarSize(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        return .zero
    }
    
    func footerViewSize(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        return CGSize(width: 0, height: 8)
    }
    
    func heightForLocation(message: MessageType, at indexPath: IndexPath, with maxWidth: CGFloat, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        
        return 0
    }
    
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
    return input.rawValue
}
