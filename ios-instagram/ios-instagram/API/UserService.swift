//
//  UserService.swift
//  ios-instagram
//
//  Created by yongmin lee on 4/12/21.
//

import Firebase

struct UserService {
    static func fetchUser(completion: @escaping (User) -> Void) {

        if let current_uid = Auth.auth().currentUser?.uid{
            COLLECTION_USERS.document(current_uid).getDocument { (snapshot, error) in
                if let error = error{
                    print("debug : COLLECTION_USERS.document(current_uid).getDocument error -> \(error.localizedDescription)")
                    return
                }
                
                if let dataDictionary = snapshot?.data(){
                    let user = User(dictionary: dataDictionary)
                    completion(user)
                }
            }
        }else {
            print("deubg : there is no current_uid")
        }
    }
    
    static func fetchUsers(completion: @escaping([User]) ->Void) {
        COLLECTION_USERS.getDocuments { (snapshot, error) in
            if let error = error {
                print("debug :   COLLECTION_USERS.getDocuments error -> \(error.localizedDescription)")
                return
            }
            
            guard let snapshot = snapshot else {return}
            var users = [User]()
            snapshot.documents.forEach { (document) in
                let user = User(dictionary: document.data())
                users.append(user)
            }
            
//            let users = snapshot.documents.map( {User(dictionary: $0.data())} ) // $0 : each element
            
            
            
            completion(users)
            
            
            
        }
    }

}
