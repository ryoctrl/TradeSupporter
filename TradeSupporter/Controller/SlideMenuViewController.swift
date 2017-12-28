//
//  SlideMenuViewController.swift
//  TradeSupporter
//
//  Created by mosin on 2017/12/25.
//  Copyright © 2017年 mosin. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

class SlideMenuViewController: SlideMenuController{
    
    override func awakeFromNib() {
        let mainVC = storyboard?.instantiateViewController(withIdentifier: "Main")
        let leftVC = storyboard?.instantiateViewController(withIdentifier: "Left")
        let rightVC = storyboard?.instantiateViewController(withIdentifier: "Right")
        
        //UIViewControllerにはNavigationBarは無いためUINavigationControllerを生成しています。
        let navigationController = UINavigationController(rootViewController: mainVC!)
        //ライブラリ特有のプロパティにセット
        mainViewController = navigationController
        leftViewController = leftVC
        rightViewController = rightVC
        
        SlideMenuOptions.hideStatusBar = false
        SlideMenuOptions.contentViewScale = 1
        SlideMenuOptions.leftViewWidth = 290.0
        SlideMenuOptions.rightViewWidth = 290.0
        super.awakeFromNib()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

