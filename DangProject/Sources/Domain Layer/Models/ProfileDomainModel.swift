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
                                   gender: "",
                                   birthDay: "")
    var uid: String
    var name: String
    var height: Int
    var weight: Int
    var sugarLevel: Int
    var profileImage: UIImage
    var gender: String
    var birthDay: String
    
    init(uid: String,
         name: String,
         height: Int,
         weight: Int,
         sugarLevel: Int,
         profileImage: UIImage,
         gender: String,
         birthDay: String) {
        self.uid = uid
        self.name = name
        self.height = height
        self.weight = weight
        self.sugarLevel = sugarLevel
        self.profileImage = profileImage
        self.gender = gender
        self.birthDay = birthDay
    }
    
    init?(profileEntity: ProfileEntity) {
        guard let imageData = profileEntity.profileImage,
              let image = UIImage(data: imageData),
              let name = profileEntity.name,
              let gender = profileEntity.gender,
              let birthDay = profileEntity.birthDay else { return nil }
        self.uid = ""
        self.profileImage = image
        self.name = name
        self.height = Int(profileEntity.height)
        self.weight = Int(profileEntity.weight)
        self.sugarLevel = Int(profileEntity.sugarLevel)
        self.gender = gender
        self.birthDay = birthDay
    }
}



