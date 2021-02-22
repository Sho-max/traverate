//
//  SignInViewController.swift
//  Original App ver.2
//
//  Created by 石井　翔 on 2020/09/07.
//  Copyright © 2020 石井　翔. All rights reserved.
//

import UIKit
import NCMB
import FBSDKLoginKit

class SignInViewController: UIViewController, UITextFieldDelegate{
    
    @IBOutlet var userIdBox: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var forgetPassword: UIButton!
    @IBOutlet var signInButton: UIButton!
    @IBOutlet var cancelButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userIdBox.delegate = self
        password.delegate = self
        signInButton.layer.cornerRadius = signInButton.frame.size.width * 0.1
        signInButton.clipsToBounds = true
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    @IBAction func signIn(){
        
        if (userIdBox.text?.count)! > 0 && (password.text?.count)! > 0 {
            
//            let user = NCMBUser()
//            let alert = UIAlertController(title: "注意", message: "これは退会されたアカウントです", preferredStyle: .alert)
//            let action = UIAlertAction(title: "OK", style: .default) { (action) in
//                self.dismiss(animated: true, completion: nil)
//            }
//            alert.addAction(action)
//            self.present(alert, animated: true, completion: nil)
//            
            logInMethod()
            
        }else{
            let alert = UIAlertController(title: "注意", message: "文字数が足りません", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default) { (action) in
            }
            
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            
        }
    }
    
    func logInMethod(){
        NCMBUser.logInWithUsername(inBackground: userIdBox.text!, password: password.text!) { (user, error) in
            
            if error != nil{
                print(error!.localizedDescription)
                let alert = UIAlertController(title: "注意", message: "入力情報に誤りがあります", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default) { (action) in
                    alert.dismiss(animated: true, completion: nil)
                }
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }else{
                //                    ログイン成功
                let passUd = UserDefaults.standard
                passUd.set(self.password.text, forKey: "password")
                passUd.synchronize()
                let alert = UIAlertController(title: "完了", message: "ログインしました。", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default) { (action) in
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                    let rootViewController = storyboard.instantiateViewController(withIdentifier: "RootTabBarController")
                    UIApplication.shared.keyWindow?.rootViewController = rootViewController
                    alert.dismiss(animated: true, completion: nil)
                }
                
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
                
                //                 ログイン状態保持
                let ud = UserDefaults.standard
                ud.set(true, forKey: "isLogin")
                ud.synchronize()
            }
        }
    }
    
    @IBAction func cancel(){
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    //class LoginViewController : UIViewController {
    //
    //    @IBAction func FacebookLoginBtn(sender: AnyObject) {
    //
    //        let fbManager = LoginManager()
    //        let permission = ["email", "public_profile"]
    //
    //        fbManager.LogIn(permissions: permission, from: self, handler: { (result, error) in
    //            if(error != nil){
    //                if(result!.isCancelled){
    //
    //                    // Facebookのログインがキャンセルされた場合
    //                    print("Facebookのログインがキャンセルされました")
    //
    //                } else {
    //
    //                    // その他のエラーが発生した場合
    //                    print("エラーが発生しました：\(String(describing: error))")
    //
    //                }
    //
    //            } else {
    //
    //                // 会員登録とログイン後の処理
    //                if(result!.token?.userID != nil){
    //                    let facebookInfo = NCMBFacebookParameters(id: result!.token?.userID as! String, accessToken: result!.token!.tokenString, expirationDate: result!.token!.expirationDate)
    //
    //                    let user = NCMBUser()
    //                    user.signUpWithFacebookToken(facebookParameters: facebookInfo, callback: { result in
    //                        switch result{
    //                        case let .failure(error):
    //
    //                            //会員登録に失敗した場合の処理
    //                            print("Facebookの会員登録とログインに失敗しました：\(error)");
    //
    //                        case .success:
    //
    //                            //会員登録に成功した場合の処理
    //                            print("Facebookの会員登録とログインに成功しました：\(String(describing: user.objectId))");
    //
    //                        }
    //                    })
    //                } else {
    //
    //                    //エラー発生時の処理
    //                    print("エラーが発生しました：\(String(describing: error))")
    //                    self.label.text = "エラーが発生しました：\(String(describing: error))"
    //
    //                }
    //
    //             }
    //        })
    //    }
    //}
    
    
}
