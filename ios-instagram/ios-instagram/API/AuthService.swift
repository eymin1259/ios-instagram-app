import UIKit
import Firebase


struct AuthCredentials {
    let email: String
    let password: String
    let fullname: String
    let username : String
    let profileImage : UIImage
}

struct AuthService {
    static func registerUser(withCredentials credentials: AuthCredentials, completion: @escaping(Error?)->Void){
        
        // 1. upload image to Firebase-Storage
        ImageUploader.uploadImage(image: credentials.profileImage) { (imageUrl) in
            
            // 2. upload auth information to Firebase-Authentification
            Auth.auth().createUser(withEmail: credentials.email, password: credentials.password) { (result, error) in
                
                if let error = error {
                    print("debug : failed to register user -> \(error.localizedDescription)")
                    return
                }
                
                guard let uid = result?.user.uid else {return}
                
                // 3. upload user information(auth + img + other infos) to Firestore-DB
                // 3-1. create data
                let data: [String:Any] = ["email": credentials.email, "fullname":credentials.fullname, "profileImage":imageUrl,
                                          "uid":uid,
                                          "username":credentials.username]
                
                
                // 3-2. create or access to "users" collection
                // 3-3. create "uid" document in the "users" collection
                // 3-4. set data in the "uid" document
                Firestore.firestore().collection("users").document(uid).setData(data, completion: completion)
                
            }
        }
        
        
    }
}
