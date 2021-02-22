//
//  SignUpViewController.swift
//  Original App ver.2
//
//  Created by 石井　翔 on 2020/09/08.
//  Copyright © 2020 石井　翔. All rights reserved.
//

import UIKit
import NCMB



class SignUpViewController: UIViewController,UITextFieldDelegate{
    
    
    @IBOutlet var emailTextBox: UITextField!
    @IBOutlet var backButton: UIBarButtonItem!
    @IBOutlet var signUp: UIButton!
    @IBOutlet weak var confirmationEmailAddress: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextBox.delegate = self
        signUp.layer.cornerRadius = signUp.frame.width * 0.1
        signUp.clipsToBounds = true
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func back(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func register(){
        let user = NCMBUser()
        
        
        //    メールアドレスをNCMBのメールアドレレスに入れる
        user.mailAddress = emailTextBox.text!
        
        // メール認証
        var error : NSError? = nil
        NCMBUser.requestAuthenticationMail(emailTextBox.text!, error: &error)
        
        if(emailTextBox.text! == confirmationEmailAddress.text!){
            if (error != nil) {
                print(error ?? "")
            }else{
                print("メール完了")
                print(emailTextBox.text!)
                let alert = UIAlertController(title: "完了", message: "メールを送信しました。\nメールの案内に従ってパスワードを設定して下さい。", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default) { (okAction) in
                    self.dismiss(animated: true, completion: nil)
                }
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
                
                //            ログイン情報の保存
                let ud = UserDefaults.standard
                ud.set(true, forKey: "isLogin")
                ud.synchronize()
            }
        }else{
            let alert = UIAlertController(title: "注意", message: "メールアドレスが一致しません", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (okAction) in
                alert.dismiss(animated: true, completion: nil)
            }
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
        
        //                NCMBUser.logInWithMailAddress(inBackground: self.emailTextBox.text, password: self.passwordTextBox.text, block: { (user, error) in
        //                    if error != nil {
        //                        // ログイン失敗時の処理
        //                        let alert = UIAlertController(title: "注意", message: error!.localizedDescription, preferredStyle: .alert)
        //                                   let action = UIAlertAction(title: "OK", style: .default) { (action) in
        //
        //                                       alert.dismiss(animated: true, completion: nil)
        //
        //                                       }
        //                                   alert.addAction(action)
        //                                   self.present(alert, animated: true, completion: nil)
        //                                   print(error as Any)
        //                    }else{
        //                        // ログイン成功時の処理
        //                        let alert = UIAlertController(title: "注意", message: "メールを確認してください", preferredStyle: .alert)
        //                        let action = UIAlertAction(title: "OK", style: .default) { (action) in
        //
        //                                let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        //                                let rootViewController = storyboard.instantiateViewController(withIdentifier: "RootTabBarController")
        //                                UIApplication.shared.keyWindow?.rootViewController = rootViewController
        //                                alert.dismiss(animated: true, completion: nil)
        //                            }
        //
        //                                alert.addAction(action)
        //                                self.present(alert, animated: true, completion: nil)
        //
        ////                                         ログイン状態保持
        //                                        let ud = UserDefaults.standard
        //                                        ud.set(true, forKey: "isLogin")
        //                                        ud.synchronize()
        //                }
        //            })
    }
}


