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
}
