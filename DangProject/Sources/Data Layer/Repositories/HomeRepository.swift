//
//  HomeRepository.swift
//  DangProject
//
//  Created by 김동우 on 2022/03/12.
//

import Foundation

class HomeRepository: HomeRepositoryProtocol {
    
    
    var dangGeneralData: DangGeneral =
        DangGeneral(tempDang: [
                        "0.5","5.0","7.0","0.0","10.0","20.0","15.0"
                    ],
                    tempFoodName: [
                        "김치말이국수","김치볶음밥","라면","탕수육","냉모밀","나시고랭","깍두기"
                    ],
                    weekDang: [
                        "5.5","8.8","1.5","11.8","22.0","10.0","22.2"
                    ],
                    monthDang: [
                        15.0, 8.0, 20.0, 15.0, 5.0, 1.0, 17.0,
                        5.0, 14.0, 8.0, 10.0, 1.0, 13.0, 8.0,
                        20.0, 6.0, 8.0, 15.0, 15.0, 2.0, 10.0,
                        8.0, 10.0, 8.0, 2.0, 12.0, 15.0, 1.0,
                        5.0, 6.0, 8.0, 15.0, 8.0, 2.0, 19.0,
                        1.0, 12.0, 8.0, 14.0, 1.0, 18.0, 19.0
                    ],
                    monthMaxDang: [
                        20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0,
                        20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0,
                        20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0,
                        20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0,
                        20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0,
                        20.0, 20.0, 20.0, 20.0, 20.0, 20.0, 20.0
                    ],
                    yearDang: [
                        "10.5","5.8","20","3.2","5","16","13"
                    ])
}