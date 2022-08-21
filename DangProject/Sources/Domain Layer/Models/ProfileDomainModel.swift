//
//  ProfileDomainModel.swift
//  DangProject
//
//  Created by 김성원 on 2022/05/03.
//

import UIKit

enum GenderType: String {
    case male = "남자"
    case female = "여자"
}

struct ProfileDomainModel {
    static let empty: Self = .init(uid: "",
                                   name: "",
                                   height: 0,
                                   weight: 0,
                                   sugarLevel: 0,
                                   profileImage: UIImage(),
                                   gender: .male,
                                   birthday: "")
    
    var uid: String
    var name: String
    var height: Int
    var weight: Int
    var sugarLevel: Int
    var profileImage: UIImage
    var gender: GenderType
    var birthday: String
    
    init(uid: String,
         name: String,
         height: Int,
         weight: Int,
         sugarLevel: Int,
         profileImage: UIImage,
         gender: GenderType,
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
    
    init(_ profileEntity: ProfileEntity) {
        self.uid = ""
        self.profileImage = UIImage(data: profileEntity.profileImage ?? Data()) ?? UIImage()
        self.name = profileEntity.name ?? ""
        self.height = Int(profileEntity.height)
        self.weight = Int(profileEntity.weight)
        self.sugarLevel = Int(profileEntity.sugarLevel)
        self.gender = Self.convertStringToGenderType(profileEntity.gender!)
        self.birthday = profileEntity.birthday ?? ""
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

    static func convertStringToGenderType(_ gender: String) -> GenderType {
        if gender == GenderType.male.rawValue {
            return GenderType.male
        } else {
            return GenderType.female
        }
    }
}
