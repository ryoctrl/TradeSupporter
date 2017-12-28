//
//  UISegmentControlExtension.swift
//  TradeSupporter
//
//  Created by mosin on 2017/12/26.
//  Copyright © 2017年 mosin. All rights reserved.
//

import Foundation
import UIKit

extension UISegmentedControl {
    func changeAllSegmentWithArray(arr: [String], initialize: Bool = false){
        if initialize {
            self.removeAllSegments()
        }
        for i in 0..<arr.count {
            self.insertSegment(withTitle: arr[i], at: numberOfSegments, animated: false)
        }
        
        self.selectedSegmentIndex = 0
    }
}
