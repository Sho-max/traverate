//
//  LogInViewController.swift
//  Original App ver.2
//
//  Created by 石井　翔 on 2020/09/07.
//  Copyright © 2020 石井　翔. All rights reserved.
//

import UIKit
import NCMB
import TransitionButton
import AVFoundation


class LogInViewController: UIViewController, UINavigationControllerDelegate{

//    ここのオートレイアウトをコードで
    let signInbutton = TransitionButton(frame: CGRect(x:0 , y:0 , width: 250, height: 50))
   
    @IBOutlet var greetingLabel: UILabel!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SignInButtonAction()
        videoPlay()
        setGreet()
       
        
    }
    
    
    
    @IBAction func buttonAction(_ button: TransitionButton) {
//        ボタンのアニメーション開始
        button.startAnimation()
        let qualityOfServiceClass = DispatchQoS.QoSClass.background
        let backgroundQueue = DispatchQueue.global(qos: qualityOfServiceClass)
        backgroundQueue.async(execute: {
            
            sleep(3)
            
            DispatchQueue.main.async(execute: { () -> Void in
//アニメーションを止める
                button.stopAnimation(animationStyle: .expand, completion: {
                    self.performSegue(withIdentifier: "toSignIn", sender: nil)
                })
            })
        })
    }
    
    @IBAction func ButtonAction(_ button: TransitionButton) {
    //        ボタンのアニメーション開始
            button.startAnimation()
            let qualityOfServiceClass = DispatchQoS.QoSClass.background
            let backgroundQueue = DispatchQueue.global(qos: qualityOfServiceClass)
            backgroundQueue.async(execute: {
                
                 sleep(3)
                
                DispatchQueue.main.async(execute: { () -> Void in
    //アニメーションを止める
                    button.stopAnimation(animationStyle: .expand, completion: {
                        self.performSegue(withIdentifier: "toSignUp", sender: nil)
                    })
                })
            })
        }
    
    func SignInButtonAction(){
        self.view.addSubview(signInbutton)
        signInbutton.setTitle("LOG IN", for: .normal)
        signInbutton.spinnerColor = .white
        signInbutton.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
        signInbutton.layer.borderWidth = 1
        signInbutton.layer.borderColor = UIColor.white.cgColor
        signInbutton.layer.cornerRadius = 4
        signInbutton.layer.position = CGPoint(x: self.view.frame.width/2, y: self.view.frame.height/1.5)
    }
    
    func videoPlay(){
        let path = Bundle.main.path(forResource: "Fly - 9761", ofType: "mp4")!
        let player = AVPlayer(url: URL(fileURLWithPath: path))
               player.actionAtItemEnd = .none
               player.play()

               let playerLayer = AVPlayerLayer(player: player)
               playerLayer.frame = view.bounds
               playerLayer.videoGravity = .resizeAspectFill
               playerLayer.zPosition = -2 // 次に追加するoverlayより後ろにする
               view.layer.insertSublayer(playerLayer, at: 0)

               // 動画の上に重ねる半透明の黒いレイヤー
               let dimOverlay = CALayer()
               dimOverlay.frame = view.bounds
               dimOverlay.backgroundColor = UIColor.black.cgColor
               dimOverlay.zPosition = -1
               dimOverlay.opacity = 0.4 // 不透明度
               view.layer.insertSublayer(dimOverlay, at: 0)

               // 最後まで再生したら最初から再生する
               let playerObserver = NotificationCenter.default.addObserver(
                   forName: .AVPlayerItemDidPlayToEndTime,
                   object: player.currentItem,
                   queue: .main) { [weak playerLayer] _ in
                    playerLayer?.player?.seek(to: CMTime.zero)
                       playerLayer?.player?.play()
        }
    }
    
    func setGreet(){
           let greetings = [
                    "HELLO",
                    "こんにちは",
                    "HOLA",
                    "CIAO",
                    "你好",
                    "Selamat Xiang"
                    ]
           
           let randomGreeting = greetings.randomElement()
        
        greetingLabel.text = randomGreeting
       }
       
}
