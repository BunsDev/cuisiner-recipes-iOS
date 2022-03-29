//
//  AuthService.swift
//  Cuisiner
//
//  Created by Fatih Gursoy on 30.03.2022.
//

import Foundation
import Firebase

class CurrentUser {
    
    static let shared = CurrentUser()
  
    weak var delegate: AuthDelegate?
    
    var currentUser = Auth.auth().currentUser
    
    var userId: String? {
        return currentUser?.uid
    }
    
    var userName: String? {
        return currentUser?.displayName
    }
    
    var userEmail: String? {
        return currentUser?.email
    }
    
    private init() {
        
    }
    
    func signOut() {
        
        do {
            try Auth.auth().signOut()
            delegate?.didSignOut()
        } catch {
            print("Can't signout")
        }
        
    }
 
}

protocol AuthDelegate: AnyObject {
    
    func didSignOut()

}
