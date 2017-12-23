
import UIKit

extension UIColor {
    
    func lighter(by percentage: CGFloat = 30.0) -> UIColor {
        return self.adjustBrightness(by: abs(percentage))
    }
    
    func darker(by percentage: CGFloat = 30.0) -> UIColor {
        return self.adjustBrightness(by: -abs(percentage))
    }
    
    func adjustBrightness(by percentage: CGFloat = 30.0) -> UIColor {
        var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        if self.getHue(&h, saturation: &s, brightness: &b, alpha: &a) {
            if b < 1.0 {
                let newB: CGFloat = max(min(b + (percentage/100.0)*b, 1.0), 0,0)
                return UIColor(hue: h, saturation: s, brightness: newB, alpha: a)
            } else {
                let newS: CGFloat = min(max(s - (percentage/100.0)*s, 0.0), 1.0)
                return UIColor(hue: h, saturation: newS, brightness: b, alpha: a)
            }
        }
        return self
    }
    
    class func gray(_ rgb: CGFloat) -> UIColor {
        return UIColor(red: rgb/255, green: rgb/255, blue: rgb/255, alpha: 1)
    }
    
    class func colorFromHex(hexString:String) -> UIColor {
        
        func clean(hexString: String) -> String {
            var cleanedHexString = String()
            if (hexString[hexString.startIndex] == "#") {
                cleanedHexString = hexString.substring(from: hexString.index(hexString.startIndex, offsetBy: 1))
            }
            return cleanedHexString
        }
        
        let cleanedHexString = clean(hexString: hexString)
        if let cachedColor = UIColor.getColorFromCache(hexString: cleanedHexString) {
            return cachedColor
        }
        let scanner = Scanner(string: cleanedHexString)
        var value:UInt32 = 0
        if (scanner.scanHexInt32(&value)) {
            let intValue = UInt32(value)
            let mask:UInt32 = 0xFF
            let red = intValue >> 16 & mask
            let green = intValue >> 8 & mask
            let blue = intValue & mask
            let colors:[UInt32] = [red, green, blue]
            let normalised = normalise(colors: colors)
            let newColor = UIColor(red: normalised[0], green: normalised[1], blue: normalised[2], alpha: 1)
            UIColor.storeColorInCache(hexString: cleanedHexString, color: newColor)
            return newColor
        } else {
            print("Error: Couldn't convert the hex string to a number, returning UIColor.whiteColor() instead.")
            return UIColor.white
        }
    }
    
    private class func normalise(colors: [UInt32]) -> [CGFloat]{
        var normalisedVersions = [CGFloat]()
        for color in colors{
            normalisedVersions.append(CGFloat(color % 256) / 255)
        }
        return normalisedVersions
    }
    
    private static var hexColorCache = [String : UIColor]()
    
    private class func getColorFromCache(hexString: String) -> UIColor? {
        guard let color = UIColor.hexColorCache[hexString] else {
            return nil
        }
        return color
    }
    
    private class func storeColorInCache(hexString: String, color: UIColor) {
        if UIColor.hexColorCache.keys.contains(hexString) {
            return
        }
        UIColor.hexColorCache[hexString] = color
    }
    
    private class func clearColorCache() {
        UIColor.hexColorCache.removeAll()
    }
}
