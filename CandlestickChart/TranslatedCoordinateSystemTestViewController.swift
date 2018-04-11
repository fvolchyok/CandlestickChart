//
//  TranslatedCoordinateSystemTestViewController.swift
//  CandlestickChart
//
//  Created by Fyodor Volchyok on 4/11/18.
//

import UIKit


class TranslatedCoordinateSystemTestViewController: UIViewController {
    
    @IBOutlet weak var candlestickView: CandlestickChartView!
    
    let candlestickGenerator = RandomCandlestickGenerator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        randomize()
    }
    
    @IBAction func randomize() {
        candlestickView.candlestickArray = candlestickGenerator.randomCandlesticks(withNumber: 12)
    }
    
}
