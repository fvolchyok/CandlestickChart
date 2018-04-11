//
//  TestView.swift
//  CandlestickChart
//
//  Created by Fyodor Volchyok on 4/11/18.
//

import UIKit


class CandlestickChartView: UIView {
    
    static let HorizontalSpacing: CGFloat = 5
    static let MaxCandlestickWidth: CGFloat = 30
    static let CandlestickCenterLineWidth: CGFloat = 3
    
    var candlestickArray = [Candlestick]() {
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
        let context = UIGraphicsGetCurrentContext()!
        context.applyTransformToSwitchToBottomLeftCoordinateSystem(in: self)
        transformContextToZoom(context)
        
        let candlestickWidth = calculateCandlestickWidth()
        
        for (index, candlestick) in candlestickArray.enumerated() {
            draw(candlestick, x: candlestickX(index: index, width: candlestickWidth), width: candlestickWidth)
        }
    }
    
    func transformContextToZoom(_ context: CGContext) {
        let priceRange = candlestickArray.priceRange()
        let aspectRatio = self.bounds.height / CGFloat(priceRange)
        context.translateBy(x: 0, y: -CGFloat(candlestickArray.lowestPrice()) * aspectRatio)
        context.scaleBy(x: 1, y: aspectRatio)
    }
    
    func calculateCandlestickWidth() -> CGFloat {
        let totalSpacing = CGFloat(candlestickArray.count - 1) * CandlestickChartView.HorizontalSpacing
        let proposedCandlestickWidth = (self.bounds.size.width - totalSpacing) / CGFloat(candlestickArray.count)
        return min(CandlestickChartView.MaxCandlestickWidth, proposedCandlestickWidth)
    }
    
    func candlestickX(index: Int, width: CGFloat) -> CGFloat {
        return CGFloat(index) * width + CGFloat(index) * CandlestickChartView.HorizontalSpacing
    }
    
    func draw(_ candlestick: Candlestick, x: CGFloat, width: CGFloat) {
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
        
        let rect = CGRect(x: x, y: CGFloat(candlestick.lowPrice), width: width, height: CGFloat(candlestick.highPrice - candlestick.lowPrice))
        
        let centerLine = rect.insetBy(dx: (rect.width - CandlestickChartView.CandlestickCenterLineWidth) / 2, dy: 0)
        context.fill(centerLine)
        
        let lowOpenClosePrice = CGFloat(min(candlestick.openPrice, candlestick.closePrice))
        let highOpenClosePrice = CGFloat(max(candlestick.openPrice, candlestick.closePrice))
        
        let bodyRect = CGRect(x: rect.origin.x, y: lowOpenClosePrice, width: rect.width, height: highOpenClosePrice - lowOpenClosePrice)
        context.fill(bodyRect)
    }

}


extension CGContext {
    
    func applyTransformToSwitchToBottomLeftCoordinateSystem(in view: UIView) {
        translateBy(x: 0, y: view.bounds.height)
        scaleBy(x: 1, y: -1)
    }
    
}
