//
//  NotificationService.swift
//  ios-instagram
//
//  Created by yongmin lee on 4/19/21.
//

import Firebase

struct NotificationService{
    
    static func uploadNotification(toUid uid: String, fromUser: User ,type: NotificationType, post: Post? = nil){
        guard let currentUid = Auth.auth().currentUser?.uid else {return}
        guard uid != currentUid else {
            // no notification to myself
            return
        }
        var data: [String:Any] = ["timestamp":Timestamp(date: Date()),
                                  "uid":fromUser.uid,
                                  "type":type.rawValue,
                                  "userProfileImageUrl":fromUser.profileImage,
                                  "username":fromUser.username]
        if let post = post {
            data["postId"] = post.postId
            data["postImageUrl"] = post.imageUrl
        }
        
        //  notification document을 uid 값으로 생성하여, 어떤 user에게 notificaiton을 줄건지 구분 시켜준다 (layer 1)
        //  해당 user document안에 어떤 notification을 줄건지 notification data를 저장한 collection 생성 ( layer 2)
        let doc = COLLECTION_NOTIFICATIONS.document(uid).collection("user-notification").document()
        let docId = doc.documentID
        data["id"] = docId
        
        doc.setData(data) { (error) in
            if let error = error {
                print("debug : failed to upload Notification -> \(error.localizedDescription)")
            }
            print("debug : success to upload Notification")
        }
    }
    
    static func fetchNotification(completion:@escaping([Notification]) -> Void){
        guard let currentUid = Auth.auth().currentUser?.uid else {
            return
        }
        
        COLLECTION_NOTIFICATIONS.document(currentUid).collection("user-notification").getDocuments { (snapshot, error) in
            if let error = error {
                print("debug : failed to fetch Notification -> \(error.localizedDescription)")
            }
            
            guard let docs = snapshot?.documents else {return}
            
            let notificatoins = docs.map( { Notification(dictionary: $0.data())})
            
            completion(notificatoins)
            
            
        }
    }
    
}

