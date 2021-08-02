//
//  FetchedUser.swift
//  Rave Fitness
//
//  Created by 郑刘 on 7/29/21.
//

import Foundation

struct FetchedUser
{
    let uid:String
    let firstname:String
    let lastname:String
    
    init(uid:String, dictionary:[String:Any])
    {
        self.uid = uid
        self.firstname = dictionary["firstname"] as? String ?? ""
        self.lastname = dictionary["lastname"] as? String ?? ""
    }
}
