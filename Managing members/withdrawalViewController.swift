//
//  withdrawalViewController.swift
//  Original App ver.2
//
//  Created by 石井　翔 on 2020/09/08.
//  Copyright © 2020 石井　翔. All rights reserved.
//

import UIKit
import NCMB

class withdrawalViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var userIdBox: UITextField!
    @IBOutlet var password: UITextField!
    
    @IBOutlet var withdrawalButton: UIButton!
    
    
    var userPass: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userIdBox.delegate = self
        password.delegate = self
        
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func cancelMember(){
        let user = NCMBUser.current()
        
        //        文字数が正しい時
        if (userIdBox.text?.count)! < 0{
            print("文字数が足りません")
            let alert = UIAlertController(title: "注意", message: "文字数が足りません", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (okAction) in
                self.dismiss(animated: true, completion: nil)
            }
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            
        }else{
            //            文字が正常に入力された時
            
            let userId = user?.userName!
            //            let userPassword = user?.password
            let pss = UserDefaults.standard
            userPass = pss.string(forKey: "password")
            print(userId!,":",type(of: userId!))
            print(userPass!,":",type(of: userPass!))
            print(userIdBox.text!,":",type(of: userIdBox.text!))
            print(password.text!,":",type(of: password.text!))
            
            //        ユーザーの情報も取ってくる

           
            
            
            if (userIdBox.text! == userId!) && (password.text! == userPass!) {
                let alert = UIAlertController(title: "注意", message: "本当に退会しても良いですか？退会した場合、再度このアカウントをご利用いただくことができません", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default) { (okAction) in
                    //                     退会成功
                    if let user = NCMBUser.current() {
                    user.setObject(false, forKey: "active")
                    user.setObject(true, forKey: "withdrawal")
                    user.saveInBackground({ (error) in
                        if error != nil {
                            
                        } else {
                            // userのアクティブ状態を変更できたらログイン画面に移動
                            let storyboard = UIStoryboard(name: "LogIn", bundle: Bundle.main)
                            let rootViewController = storyboard.instantiateViewController(withIdentifier: "RootNavigationController")
                            UIApplication.shared.keyWindow?.rootViewController = rootViewController
                            
                            // ログイン状態の保持
                            let ud = UserDefaults.standard
                            ud.set(false, forKey: "isLogin")
                            ud.synchronize()
                        }
                    })
                     }else{
                         // userがnilだった場合ログイン画面に移動
                         let storyboard = UIStoryboard(name: "LogIn", bundle: Bundle.main)
                         let rootViewController = storyboard.instantiateViewController(withIdentifier: "RootNavigationController")
                         UIApplication.shared.keyWindow?.rootViewController = rootViewController
                         
                         // ログイン状態の保持
                         let ud = UserDefaults.standard
                         ud.set(false, forKey: "isLogin")
                         ud.synchronize()
                     }
                    //                   退会処理
//
//                    user?.deleteInBackground({ (err) in
//                        if err != nil {
//
//                            //                                エラーがあったら
//                            print(err?.localizedDescription)
//                            let alert = UIAlertController(title: "注意", message: err?.localizedDescription, preferredStyle: .alert)
//                            let okAction = UIAlertAction(title: "OK", style: .default) { (okAction) in
//
//                                self.dismiss(animated: true, completion: nil)
//                            }
//                            alert.addAction(okAction)
//                            self.present(alert, animated: true, completion: nil)
//
//                        } else {
//
//                            let alert = UIAlertController(title: "完了", message: "退会処理が完了しました", preferredStyle: .alert)
//                            let okAction = UIAlertAction(title: "OK", style: .default) { (okAction) in
//
//                                //                              userのアクティブ状態を変更できたらログイン画面に移動
//                                let storyboard = UIStoryboard(name: "LogIn", bundle: Bundle.main)
//                                let rootViewController = storyboard.instantiateViewController(withIdentifier: "RootNavigationController")
//                                UIApplication.shared.keyWindow?.rootViewController = rootViewController
//
//                                //                                    //                             ログアウト状態の保持
//                                //                                    let ud = UserDefaults.standard
//                                //                                    ud.set(false, forKey: "isLogin")
//                                //                                    ud.synchronize()
//                            }
//                            alert.addAction(okAction)
//                            self.present(alert, animated: true, completion: nil)
//                        }
//                    })
                }
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (cancelAction) in
                    self.dismiss(animated: true, completion: nil)
                    
                }
                alert.addAction(okAction)
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
            }else{
                let alert = UIAlertController(title: "注意", message: "ユーザーIDあるいはパスワードが違います", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default) { (okAction) in
                    self.dismiss(animated: true, completion: nil)
                }
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }
            
        }
        
        
        
    }
    
}
