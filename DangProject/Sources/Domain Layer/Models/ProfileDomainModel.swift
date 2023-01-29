//
//  ProfileDomainModel.swift
//  DangProject
//
//  Created by 김성원 on 2022/05/03.
//

import UIKit

struct ProfileDomainModel {
    static let empty: Self = .init(uid: "",
                                   email: "",
                                   name: "",
                                   height: 0,
                                   weight: 0,
                                   sugarLevel: 0,
                                   profileImage: UIImage())
    
    var uid: String
    var email: String
    var name: String
    var height: Int
    var weight: Int
    var sugarLevel: Int
    var profileImage: UIImage
    
    init(uid: String,
         email: String,
         name: String,
         height: Int,
         weight: Int,
         sugarLevel: Int,
         profileImage: UIImage) {
        self.uid = uid
        self.email = email
        self.name = name
        self.height = height
        self.weight = weight
        self.sugarLevel = sugarLevel
        self.profileImage = profileImage
    }
    
    init(_ profileEntity: ProfileEntity) {
        self.uid = ""
        self.email = profileEntity.email ?? ""
        self.profileImage = UIImage(data: profileEntity.profileImage ?? Data()) ?? UIImage()
        self.name = profileEntity.name ?? ""
        self.height = Int(profileEntity.height)
        self.weight = Int(profileEntity.weight)
        self.sugarLevel = Int(profileEntity.sugarLevel)
    }
    
}

extension ProfileDomainModel {
    static var isLatestProfileDataValue: Bool = false
    static var isLatestProfileImageDataValue: Bool = false
    
    static func setIsLatestProfileData(_ data: Bool) {
        self.isLatestProfileDataValue = data
    }
    
    static func setIsLatestProfileImageData(_ data: Bool) {
        self.isLatestProfileImageDataValue = data
    }
}
