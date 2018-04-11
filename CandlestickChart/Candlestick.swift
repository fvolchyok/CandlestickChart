//
//  Candlestick.swift
//  CandlestickChart
//
//  Created by Fyodor Volchyok on 4/10/18.
//

import Foundation


struct Candlestick {
    
    let lowPrice: Float
    let highPrice: Float
    let openPrice: Float
    let closePrice: Float
    
}


// MARK: Trend

enum CandlestickTrend {
    case bullish
    case bearish
}


extension Candlestick {
    
    var trend: CandlestickTrend? {
        guard openPrice != closePrice else { return nil }
        return openPrice < closePrice ? .bullish : .bearish
    }
    
}


extension Array where Element == Candlestick {
    
    func lowestPrice() -> Float {
        return reduce(self[0].lowPrice) { (currentLowestPrice, candlestick) -> Float in
            return Swift.min(currentLowestPrice, candlestick.lowPrice)
        }
    }
    
    func highestPrice() -> Float {
        // alternatively:
        // candlestickArray.map({ $0.highPrice }).max()
        return reduce(self[0].highPrice) { (currentHighestPrice, candlestick) -> Float in
            return Swift.max(currentHighestPrice, candlestick.highPrice)
        }
    }
    
    func priceBounds() -> (Float, Float) {
        return (lowestPrice(), highestPrice())
    }
    
    func priceRange() -> Float {
        let (lowestCandlestickPrice, highestCandlestickPrice) = priceBounds()
        return highestCandlestickPrice - lowestCandlestickPrice
    }
    
}
