
import Foundation

public struct Kelvin: Codable {
    
    private var kelvin: Double
    
    init(kelvin: Double) {
        self.kelvin = kelvin
    }
    
    var celsiusValue: Int {
        return Int(kelvin - 273.15)
    }
    
    var fahrenheitValue: Int {
        return Int((kelvin * 9 / 5) - 459.67)
    }
}

extension Kelvin: ExpressibleByFloatLiteral {
    public init(floatLiteral value: FloatLiteralType) {
        self.init(kelvin: value)
    }
}

extension Kelvin: Comparable {
    public static func < (lhs: Kelvin, rhs: Kelvin) -> Bool {
        return lhs.kelvin < rhs.kelvin
    }
}
