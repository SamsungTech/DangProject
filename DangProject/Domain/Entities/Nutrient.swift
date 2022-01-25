//
//  Nutrient.swift
//  DangProject
//
//  Created by 김동우 on 2022/01/19.
//

import Foundation

struct NutrientName: Codable {
    var apiNum: NutrientResponse
    
    private enum CodingKeys: String, CodingKey {
        case apiNum = "I2790"
    }
}

struct NutrientResponse: Codable {
    var totalCount: String?
    var row: [Nutrient]
    
    private enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case row = "row"
    }
}

struct Nutrient: Codable {
    static let empty: Self = .init(num: "",
                                   foodCd: "",
                                   samplingRegionName: "",
                                   samplingMonthName: "",
                                   samplingRegionCD: "",
                                   samplingMonthCD: "",
                                   groupName: "",
                                   descKor: "",
                                   researchYear: "",
                                   makerName: "",
                                   subRefName: "",
                                   servingSize: "",
                                   nutrCont1: "",
                                   nutrCont2: "",
                                   nutrCont3: "",
                                   nutrCont4: "",
                                   nutrCont5: "",
                                   nutrCont6: "",
                                   nutrCont7: "",
                                   nutrCont8: "",
                                   nutrCont9: "")
    var num: String? // 번호
    var foodCd: String? // 식품 코드
    var samplingRegionName: String?
    var samplingMonthName: String? // 수학 시기
    var samplingRegionCD: String? // 지역코드
    var samplingMonthCD: String? // 수확 시기 코드
    var groupName: String? // 그룹 이름
    var descKor: String? // 음식 이름
    var researchYear: String? // 검색년도
    var makerName: String?
    var subRefName: String?
    var servingSize: String?
    var nutrCont1: String? // 칼로리
    var nutrCont2: String? // 탄수화물
    var nutrCont3: String? // 프로틴
    var nutrCont4: String? // 지방
    var nutrCont5: String? // 당
    var nutrCont6: String? // 나트륨
    var nutrCont7: String? // 콜레스테롤
    var nutrCont8: String? // 포화지방산
    var nutrCont9: String? // 트랜스지방
}

struct tempNutrient {
    var dang: String?
    var foodName: String?
}
