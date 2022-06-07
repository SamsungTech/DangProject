//
//  ProfileDomainModel.swift
//  DangProject
//
//  Created by 김성원 on 2022/05/03.
//

import Foundation
import UIKit

struct ProfileDomainModel {
    let uid: String
    let name: String
    let height: Int
    let weight: Int
    let sugarLevel: Int
    var profileImage: UIImage
    
    init(uid: String, name: String, height: Int, weight: Int, sugarLevel: Int, profileImage: UIImage) {
        self.uid = uid
        self.name = name
        self.height = height
        self.weight = weight
        self.sugarLevel = sugarLevel
        self.profileImage = profileImage
    }
}



