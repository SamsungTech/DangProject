//
//  Convert.swift
//  DangProject
//
//  Created by 김동우 on 2022/04/09.
//

import Foundation

extension String {
    static func doubleArrayToStringArray(doubleArray: [Double]) -> [String] {
        var resultArray: [String] = []
        
        for d in doubleArray {
            let result = String(d)
            resultArray.append(result)
        }
        
        return resultArray
    }
}
