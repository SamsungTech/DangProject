//
//  FoodEntityFromAPI.swift
//  DangProject
//
//  Created by 김성원 on 2022/02/07.
//

import Foundation

struct FoodFromAPI: Codable {
    let serviceType: ServiceType?
    
    enum CodingKeys: String, CodingKey {
        case serviceType = "I2790"
    }
}

// MARK: 재인 - struct 대문자로 고치면조흘거같요
struct ServiceType: Codable {
    var totalCount: String
    let foodInfo: [foodInfo]?
    let result: Result?
    
    struct Result: Codable {
        let msg: String
        let code: String

        enum CodingKeys: String, CodingKey {
            case msg = "MSG"
            case code = "CODE"
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case foodInfo = "row"
        case result = "RESULT"
    }
}


struct foodInfo: Codable {
    let sugarContent: String?
    let nameContent: String?
    let foodCode: String?
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        sugarContent = try values.decode(String.self, forKey: .sugarContent)
        nameContent = try values.decode(String.self, forKey: .nameContent)
        foodCode = try values.decode(String.self, forKey: .foodCode)
    }

    enum CodingKeys: String, CodingKey {
        case sugarContent = "NUTR_CONT5"
        case nameContent = "DESC_KOR"
        case foodCode = "FOOD_CD"
    }
}
