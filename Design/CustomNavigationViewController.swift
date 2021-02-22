//
//  CustomNavigationViewController.swift
//  Original App ver.2
//
//  Created by 石井　翔 on 2020/09/07.
//  Copyright © 2020 石井　翔. All rights reserved.
//

import UIKit

class CustomNavigationViewController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

            super.viewDidLoad()
            //　ナビゲーションバーの背景色
        UINavigationBar.appearance().barTintColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
            // ナビゲーションバーのアイテムの色
        UINavigationBar.appearance().tintColor = .white
            // ナビゲーションバーのテキストを変更する
        UINavigationBar.appearance().titleTextAttributes = [
                // 文字の色
                .foregroundColor: UIColor.white
            ]
        
//        線を消す
        UINavigationBar.appearance().shadowImage = UIImage()
        }
   
        
    }
    


