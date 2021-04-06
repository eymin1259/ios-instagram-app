import FirebaseStorage

struct ImageUploader {
    static func uploadImage(image: UIImage, completion: @escaping(String)->Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.75) else {return}
        
        let filename = NSUUID().uuidString
        
        // upload image to Firebase-Storage withPath
        let ref = Storage.storage().reference(withPath: "/profile_images/\(filename)")
        
        ref.putData(imageData, metadata: nil) { (metadta, error) in
            if let err = error {
                print("debug : failed to upload image ->  \(err.localizedDescription)")
                return
            }
            
            ref.downloadURL { (url, error) in
                guard let imageUrl = url?.absoluteString else {return}
                completion(imageUrl)
            }
        }
    }
}
