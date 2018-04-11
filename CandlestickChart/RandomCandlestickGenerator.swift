//
//  RandomCandlestickGenerator.swift
//  CandlestickChart
//
//  Created by Fyodor Volchyok on 4/10/18.
//

import Foundation


class RandomCandlestickGenerator {
    
    func randomCandlesticks(withNumber numOfCandlesticks: Int = 10, in priceRange: ClosedRange<Float> = (0.0...100)) -> [Candlestick] {
        return (1...numOfCandlesticks).map({ i in randomCandlestick(in: priceRange) })
    }
    
    func randomCandlestick(in priceRange: ClosedRange<Float> = (0.0...100)) -> Candlestick {
        // TODO: refactoring
        let lowPrice = randomFloat() * priceRange.length + priceRange.lowerBound
        let highPrice = randomFloat() * (priceRange.upperBound - lowPrice) + lowPrice
        let openPrice = randomFloat() * (highPrice - lowPrice) + lowPrice
        let closePrice = randomFloat() * (highPrice - lowPrice) + lowPrice
        return Candlestick(lowPrice: lowPrice, highPrice: highPrice, openPrice: openPrice, closePrice: closePrice)
    }
    
}


func randomFloat() -> Float {
    return Float(arc4random()) / Float(UInt32.max)
}


extension ClosedRange where Bound : BinaryFloatingPoint {
    
    var length: Bound {
        return upperBound - lowerBound
    }
    
}
