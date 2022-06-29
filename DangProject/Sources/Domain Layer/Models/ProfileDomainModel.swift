//
//  ProfileDomainModel.swift
//  DangProject
//
//  Created by 김성원 on 2022/05/03.
//

import UIKit

struct ProfileDomainModel {
    static let empty: Self = .init(uid: "",
                                   name: "",
                                   height: 0,
                                   weight: 0,
                                   sugarLevel: 0,
                                   profileImage: UIImage(),
                                   gender: "")
    var uid: String
    var name: String
    var height: Int
    var weight: Int
    var sugarLevel: Int
    var profileImage: UIImage
    var gender: String
    
    init(uid: String,
         name: String,
         height: Int,
         weight: Int,
         sugarLevel: Int,
         profileImage: UIImage,
         gender: String) {
        self.uid = uid
        self.name = name
        self.height = height
        self.weight = weight
        self.sugarLevel = sugarLevel
        self.profileImage = profileImage
        self.gender = gender
    }
}



