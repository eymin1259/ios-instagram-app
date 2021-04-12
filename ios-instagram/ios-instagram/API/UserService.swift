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
}
