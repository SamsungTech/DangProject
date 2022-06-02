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
}
