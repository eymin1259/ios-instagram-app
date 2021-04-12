import UIKit

protocol AuthenticationViewModel { // bind user-input-data(local-data) to view
    // protocol : anything that confirms this AuthenticationVIewModel protocol has to implement 3 properties below
    var formValid: Bool { get }
    var btnBackground: UIColor { get }
    var btnTitleColor: UIColor { get }
    
}

struct LoginViewModel : AuthenticationViewModel {

    var email: String?
    var password: String?
    
    //computed property
    var formValid: Bool  {
        return email?.isEmpty == false && password?.isEmpty == false
    }
    
    var btnBackground: UIColor {
        return formValid ? #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1) :  #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1).withAlphaComponent(0.1)
    }
    
    var btnTitleColor: UIColor {
        return formValid ? .white : UIColor(white: 1, alpha: 0.2)
    }
    
}

struct RegisterationViewModel : AuthenticationViewModel {
    var email: String?
    var password: String?
    var fullname : String?
    var username: String?
    
    //computed property
    var formValid: Bool  {
        return email?.isEmpty == false && password?.isEmpty == false && fullname?.isEmpty == false && username?.isEmpty == false
    }
    
    var btnBackground: UIColor {
        return formValid ? #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1) :  #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1).withAlphaComponent(0.1)
    }
    
    var btnTitleColor: UIColor {
        return formValid ? .white : UIColor(white: 1, alpha: 0.2)
    }
    
}
