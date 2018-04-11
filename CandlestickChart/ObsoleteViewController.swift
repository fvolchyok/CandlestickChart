//
//  ViewController.swift
//  CandlestickChart
//
//  Created by Fyodor Volchyok on 4/10/18.
//

import UIKit


class ObsoleteViewController: UIViewController {
    
    @IBOutlet weak var candlestickChartView: CandlestickChartView!
    
    let candlestickGenerator = RandomCandlestickGenerator()

    override func viewDidLoad() {
        super.viewDidLoad()
        randomize()
    }
    
    @IBAction func randomize() {
        candlestickChartView.candlestickArray = candlestickGenerator.randomCandlesticks(withNumber: 12)
    }
    
}
