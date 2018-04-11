//
//  CandlestickChartView.swift
//  CandlestickChart
//
//  Created by Fyodor Volchyok on 4/10/18.
//

import UIKit


class CandlestickChartView: UIView {
    
    static let HorizontalSpacing: CGFloat = 5
    static let MaxCandlestickWidth: CGFloat = 30
    static let CandlestickCenterLineWidth: CGFloat = 3
    
    var candlestickArray: [Candlestick] = [] {
        didSet {
            setNeedsDisplay()
        }
    }
    
    // forces redraw on orientation change
    override func layoutSubviews() {
        super.layoutSubviews()
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        guard !candlestickArray.isEmpty else { return }
        print(candlestickArray)
        
        let candlestickWidth = calculateCandlestickWidth()
        
        let (highestCandlestickPrice, lowestCandlestickPrice) = candlestickArray.priceBounds()
        
        let priceRange = CGFloat(highestCandlestickPrice - lowestCandlestickPrice)
        let viewHeight = self.bounds.size.height
        let scaleFactor = viewHeight / priceRange
        
        let translateFactor = CGFloat(-lowestCandlestickPrice)
        
        for (index, candlestick) in candlestickArray.enumerated() {
            let scaledRelativeDistanceToBottom = convertToAnotherCoordinateSystem(value: CGFloat(candlestick.lowPrice), translation: translateFactor, scale: scaleFactor)
            let scaledRelativeDistanceToTop = convertToAnotherCoordinateSystem(value: CGFloat(candlestick.highPrice), translation: translateFactor, scale: scaleFactor)
            
            let candlestickX = CGFloat(index) * candlestickWidth + CGFloat(index) * CandlestickChartView.HorizontalSpacing
            let candlestickYInCocoaTouchCoordinateSystem = viewHeight - scaledRelativeDistanceToTop
            
            let scaledCandlestickFrame = CGRect(x: candlestickX, y: candlestickYInCocoaTouchCoordinateSystem, width: candlestickWidth, height: scaledRelativeDistanceToTop - scaledRelativeDistanceToBottom)
            
            guard scaledCandlestickFrame.intersects(rect) else { continue }
            
            draw(candlestick: candlestick, in: scaledCandlestickFrame, translate: translateFactor, scale: scaleFactor)
        }
    }
    
    func calculateCandlestickWidth() -> CGFloat {
        let totalSpacing = CGFloat(candlestickArray.count - 1) * CandlestickChartView.HorizontalSpacing
        let proposedCandlestickWidth = (self.bounds.size.width - totalSpacing) / CGFloat(candlestickArray.count)
        return min(CandlestickChartView.MaxCandlestickWidth, proposedCandlestickWidth)
    }
    
    func convertToAnotherCoordinateSystem(value: CGFloat, translation: CGFloat, scale: CGFloat) -> CGFloat {
        return (value + translation) * scale
    }
    
    func draw(candlestick: Candlestick, in rect: CGRect, translate: CGFloat, scale: CGFloat) {
        let context = UIGraphicsGetCurrentContext()!
        
        let color: CGColor!
        switch candlestick.trend {
        case nil:
            color = UIColor.black.cgColor
        case CandlestickTrend.bullish?:
            color = UIColor.blue.cgColor
        case CandlestickTrend.bearish?:
            color = UIColor.orange.cgColor
        }
        
        context.setFillColor(color)
        
        let centerLine = rect.insetBy(dx: (rect.width - CandlestickChartView.CandlestickCenterLineWidth) / 2, dy: 0)
        context.fill(centerLine)
        
        let lowOpenClosePrice = CGFloat(min(candlestick.openPrice, candlestick.closePrice))
        let highOpenClosePrice = CGFloat(max(candlestick.openPrice, candlestick.closePrice))
        
        let bodyScaledBottom = convertToAnotherCoordinateSystem(value: lowOpenClosePrice, translation: translate, scale: scale)
        let bodyScaledTop = convertToAnotherCoordinateSystem(value: highOpenClosePrice, translation: translate, scale: scale)
        let bodyScaledHeight = bodyScaledTop - bodyScaledBottom
        
        let bodyYInCocoaTouchCoordinateSystem = self.bounds.size.height - bodyScaledTop
        let bodyRect = CGRect(x: rect.origin.x, y: bodyYInCocoaTouchCoordinateSystem, width: rect.width, height: bodyScaledHeight)
        context.fill(bodyRect)
    }
    
}


extension Array where Element == Candlestick {
    
    func priceBounds() -> (Float, Float) {
        // alternatively:
        // candlestickArray.map({ $0.highPrice }).max()
        let highestCandlestickPrice = reduce(self[0].highPrice) { (currentHighestPrice, candlestick) -> Float in
            return Swift.max(currentHighestPrice, candlestick.highPrice)
        }
        let lowestCandlestickPrice = reduce(self[0].lowPrice) { (currentLowestPrice, candlestick) -> Float in
            return Swift.min(currentLowestPrice, candlestick.lowPrice)
        }
        return (highestCandlestickPrice, lowestCandlestickPrice)
    }
    
}
