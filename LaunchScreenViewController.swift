//
//  launchViewController.swift
//  Original App ver.2
//
//  Created by 石井　翔 on 2020/10/11.
//  Copyright © 2020 石井　翔. All rights reserved.
//

import UIKit

class LaunchScreenViewController: UIViewController {
    
    @IBOutlet weak var airPlaneImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //imageView作成
        self.airPlaneImageView = UIImageView(frame: CGRectMake(0, 0, 200, 200))
        //中央寄せ
        self.airPlaneImageView.center = self.view.center
        //画像を設定
        self.airPlaneImageView.image = UIImage(named: "airPlane")
        //viewに追加
        self.view.addSubview(self.airPlaneImageView)
   
    }
    
    // CGRectMakeをwrap
       func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
           return CGRect(x: x, y: y, width: width, height: height)
       }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //80%まで縮小させて・・・
        UIView.animate(withDuration: 0.3,
                       delay: 1.0,
                       options: UIView.AnimationOptions.curveEaseOut,
                       animations: { () in
                        self.airPlaneImageView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }, completion: { (Bool) in
            
        })
        
        //8倍まで拡大！
        UIView.animate(withDuration: 0.2,
                       delay: 1.3,
                       options: UIView.AnimationOptions.curveEaseOut,
                       animations: { () in
                        self.airPlaneImageView.transform = CGAffineTransform(scaleX: 10.0, y: 10.0)
                        self.airPlaneImageView.alpha = 0
        }, completion: { (Bool) in
            //で、アニメーションが終わったらimageViewを消す
            self.airPlaneImageView.removeFromSuperview()
        })
        
    }
    
}
