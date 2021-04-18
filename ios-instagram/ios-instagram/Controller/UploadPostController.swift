//
//  UploadPostController.swift
//  ios-instagram
//
//  Created by yongmin lee on 4/17/21.
//

import UIKit

protocol UploadPostControllerDelegate : class{
    func cnotrollerDidFinishUploadPost(_ controller: UploadPostController)
}

class UploadPostController : UIViewController {
    
    // MARK: properties
    
    var selectedImage : UIImage? {
        didSet {photoImageView.image = selectedImage}
    }
    
    var currendUid : User?
    
    weak var delegate :UploadPostControllerDelegate?
    
    
    private let photoImageView : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
//        iv.image = #imageLiteral(resourceName: "venom-7")
        return iv
    }()
    
    private lazy var captionTextView: InputTextView = {
        let tv = InputTextView()
        tv.placeholderText = "enter caption"
        tv.font = UIFont.systemFont(ofSize: 15)
        tv.delegate = self
        return tv
    }()
    
    private let characterCountLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "0/100"
        return label
    }()
    
    // MARK: life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        congigureUI()
    }
    
    // MARK: helpers
    func congigureUI(){
        
        view.backgroundColor = .white
        
        navigationItem.title = "Upload Post"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCanel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .done, target: self, action: #selector(handleShare))
        
        view.addSubview(photoImageView)
        photoImageView.setDimensions(height: 200, width: 200)
        photoImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 8)
        photoImageView.centerX(inView: view)
        photoImageView.layer.cornerRadius = 10
        
        view.addSubview(captionTextView)
        captionTextView.anchor(top:photoImageView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 16, paddingLeft: 12, paddingRight: 12, height: 64)
        
        view.addSubview(characterCountLabel)
        characterCountLabel.anchor(bottom: captionTextView.bottomAnchor, right: view.rightAnchor, paddingBottom: -10, paddingRight: 12)
        
    }
    
    func checkMaxLength(_ textView: UITextView, maxLen: Int){
        if(textView.text.count > maxLen){
            textView.deleteBackward()
        }
    }
    
    @objc func handleCanel(){
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleShare() {
        guard  let image = self.selectedImage else {return}
        guard  let caption = self.captionTextView.text else { return }
        guard  let currentUser = self.currendUid else {return}
        
        self.showLoader(true)
        PostService.uploadPost(caption: caption, image: image, user: currentUser) { (error) in
            
            self.showLoader(false)
            
            if let error = error {
                print("debug : upload post error -> \(error.localizedDescription)")
                return
            }
            
            // after uploading post, go to feed controller
            self.delegate?.cnotrollerDidFinishUploadPost(self)
        }
    }
}

//MARk: UITextViewDelegate

extension UploadPostController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        self.checkMaxLength(textView, maxLen: 100)
        let count = textView.text.count
        characterCountLabel.text = "\(count)/100"
        
    }
}
