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
                                   birthday: "")
    static var isLatestProfileDataValue: Bool = false
    static var isLatestProfileImageDataValue: Bool = false
    
    static func setIsLatestProfileData(_ data: Bool) {
        self.isLatestProfileDataValue = data
    }
    
    static func setIsLatestProfileImageData(_ data: Bool) {
        self.isLatestProfileImageDataValue = data
    }
    
    var uid: String
    var name: String
    var height: Int
    var weight: Int
    var sugarLevel: Int
    var profileImage: UIImage
    var gender: String
    var birthday: String
    
    init(uid: String,
         name: String,
         height: Int,
         weight: Int,
         sugarLevel: Int,
         profileImage: UIImage,
         gender: String,
         birthday: String) {
        self.uid = uid
        self.name = name
        self.height = height
        self.weight = weight
        self.sugarLevel = sugarLevel
        self.profileImage = profileImage
        self.gender = gender
        self.birthday = birthday
    }
    
    init?(profileEntity: ProfileEntity) {
        guard let imageData = profileEntity.profileImage,
              let image = UIImage(data: imageData),
              let name = profileEntity.name,
              let gender = profileEntity.gender,
              let birthday = profileEntity.birthday else { return nil }
        self.uid = ""
        self.profileImage = image
        self.name = name
        self.height = Int(profileEntity.height)
        self.weight = Int(profileEntity.weight)
        self.sugarLevel = Int(profileEntity.sugarLevel)
        self.gender = gender
        self.birthday = birthday
    }
}



