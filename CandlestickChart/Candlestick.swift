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
