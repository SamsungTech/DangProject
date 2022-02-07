//
//  FoodEntityFromAPI.swift
//  DangProject
//
//  Created by 김성원 on 2022/02/07.
//

import Foundation

struct FoodFromAPI: Codable {
    let serviceType: serviceType?
    
    enum CodingKeys: String, CodingKey {
        case serviceType = "I2790"
    }
}
struct serviceType: Codable {
    let totalCount: String
    let foodInfo: [foodInfo]?
    
    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case foodInfo = "row"
    }
}


struct foodInfo: Codable {
    let sugarContent: String
    let nameContent: String
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        sugarContent = try values.decode(String.self, forKey: .sugarContent)
        nameContent = try values.decode(String.self, forKey: .nameContent)
    }

    enum CodingKeys: String, CodingKey {
        case sugarContent = "NUTR_CONT5"
        case nameContent = "DESC_KOR"
    }
    
}
