import Foundation

extension Double {
    func roundDecimal(to place: Int) -> Double {
        let modifiedNumber = pow(10, Double(place))
        var n = self
        n = n * modifiedNumber
        n.round()
        n = n / modifiedNumber
        return n
    }
    
    static func calculateCircleAnimationDuration(dang: Double, maxDang: Double) -> Double {
        return Double((dang/maxDang)*3)
    }
    
    static func calculateSugarSum(todaySugar: [Double]) -> Double {
        var sum: Double = 0.0
        
        for item in todaySugar {
            sum += item
        }
        
        return sum
    }
    
    static func calculateCircleLineAngle(percent: Int) -> Double {
        return minimum(Double(percent) * 0.008, 0.8)
    }
    
    static func calculateIsTargetSugarExistence(_ array: [FoodDomainModel]) -> Double {
        if array.isEmpty {
            return 0.0
        } else {
            return array.first?.targetSugar ?? 0.0
        }
    }
}
