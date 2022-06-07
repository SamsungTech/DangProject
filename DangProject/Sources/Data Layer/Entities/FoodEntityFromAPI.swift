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

struct ServiceType: Codable {
    var totalCount: String
    let foodInfo: [FoodInfo]?
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

struct FoodInfo: Codable {
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

struct FoodEntity {
    
    let code: String
    let foodInfo: [FoodInfo]
    var keyword: String
    
    init(code: String, foodEntity: [FoodInfo], keyword: String) {
        self.code = code
        self.foodInfo = foodEntity
        self.keyword = keyword
    }
}
