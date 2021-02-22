//
//  myPageEditViewController.swift
//  Original App ver.2
//
//  Created by 石井　翔 on 2020/09/08.
//  Copyright © 2020 石井　翔. All rights reserved.
//

import UIKit
import NCMB
import FBSDKLoginKit
import NYXImagesKit
import UITextView_Placeholder

class myPageEditViewController: UIViewController,UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, LoginButtonDelegate{
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        
    }
    

    @IBOutlet var withdrawal: UIButton!
    @IBOutlet var signOut: UIButton!
    @IBOutlet var userImage: UIImageView!
    @IBOutlet var userNameText: UITextField!
    @IBOutlet var userIDText: UITextField!
    @IBOutlet var introduction: UITextView!
 
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        introduction.placeholder = "キャプションを書く"
        
        if let user = NCMBUser.current(){
        userNameText.text = user.object(forKey:"displayName") as? String
        userIDText.text = user.userName
        introduction.text = user.object(forKey: "introduction") as? String
        userNameText.delegate = self
        userIDText.delegate = self
        introduction.delegate = self
                   
            let userId = NCMBUser.current()?.userName
                   userIDText.text = userId
                   
            userImage.layer.cornerRadius = userImage.bounds.width * 0.35
                userImage.layer.masksToBounds = true
                   
                   let file = NCMBFile.file(withName: NCMBUser.current().objectId, data: nil) as! NCMBFile
                          file.getDataInBackground { (data, error) in
                    if error != nil{
                                print(error)
                              }else{
                            if data != nil{
                                      let image = UIImage(data: data!)
                                      self.userImage.image = image
                                  
                              }
                          }
                      }
        }else{
            let storyboard = UIStoryboard(name: "LoginIn", bundle: Bundle.main)
                               let rootViewController = storyboard.instantiateViewController(withIdentifier: "RootNavigationController")
                               UIApplication.shared.keyWindow?.rootViewController = rootViewController
                           
//                                       ログイン状態保持
                        let ud = UserDefaults.standard
                        ud.set(false, forKey: "isLogin")
                        ud.synchronize()
                                           
                   }
      
//        fbButton()
        
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
           textField.resignFirstResponder()
           return true
       }

       func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
           textView.resignFirstResponder()
           return true
       }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
       let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
       let resizedImage = selectedImage.scale(byFactor: 0.4)
       
       picker.dismiss(animated: true, completion: nil)
       
       let data = UIImage.pngData(resizedImage!)
        let file = NCMBFile.file(withName: NCMBUser.current()?.objectId, data: data()) as! NCMBFile
        file.saveInBackground({ (error) in
            if error != nil{
                print(error)
            }else{
                self.userImage.image = resizedImage
            }
        }) { (progress) in
            print(progress)
        }
        
    }
    @IBAction func selectImage(){
            let actionController = UIAlertController(title: "画像の選択", message: "画像を選択してください", preferredStyle: .actionSheet)
            let cameraAction = UIAlertAction(title: "カメラ", style: .default) { (action) in
    //            カメラ起動
                if UIImagePickerController.isSourceTypeAvailable(.camera) == true{
                let picker = UIImagePickerController()
                picker.sourceType = .camera
                picker.delegate = self
                self.present(picker, animated: true, completion: nil)
                }else{
                    let alert = UIAlertController(title: "注意", message: "この端末ではカメラは使用できません", preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .default) { (action) in
                        alert.dismiss(animated: true, completion: nil)
                    }
                    alert.addAction(action)
                    self.present(alert, animated: true
                    , completion:   nil)
                    print("この端末ではカメラは使用できません")
                }
            }
            let albumAction = UIAlertAction(title: "フォトライブラリ", style: .default) { (action) in
    //            アルバム起動
                if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) == true{
                let picker = UIImagePickerController()
                picker.sourceType = .photoLibrary
                picker.delegate = self
                self.present(picker, animated: true, completion: nil)
                }else{
                    let alert = UIAlertController(title: "注意", message: "この端末ではアルバムは使用できません", preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .default) { (action) in
                        alert.dismiss(animated: true, completion: nil)
                    }
                    alert.addAction(action)
                    self.present(alert, animated: true, completion: nil)
                    print("この端末ではアルバムは使用できません")
                }
            }
            let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { (action) in
                actionController.dismiss(animated: true, completion: nil)
            }
            actionController.addAction(cameraAction)
            actionController.addAction(albumAction)
           if UIDevice.current.userInterfaceIdiom == .pad {
                actionController.popoverPresentationController?.sourceView = self.view
                let screenSize = UIScreen.main.bounds
                actionController.popoverPresentationController?.sourceRect = CGRect(x: screenSize.size.width/2, y: screenSize.size.height, width: 0, height: 0)
           }
            self.present(actionController,animated: true, completion: nil)
        }
    
       
        
        @IBAction func saveInfo(){
            let user = NCMBUser.current()
            user?.setObject(userNameText.text, forKey: "displayName")
            user?.setObject(userIDText.text, forKey: "userName")
            user?.setObject(introduction.text, forKey:"introduction")
            
            user?.saveInBackground({ (error) in
                if error != nil{
                    print(error)
                     self.dismiss(animated: true, completion: nil)
                }else{
                    self.dismiss(animated: true, completion: nil)
                    let alert = UIAlertController(title: "完了", message: "変更内容が保存されました", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default) { (okAction) in
                        self.navigationController?.popViewController(animated: true)
                        
                    }
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                      
                }
                
               
                
            })
        }
        
       
    
    @IBAction func logOut(){

        let alert = UIAlertController(title: "注意", message: "本当にログアウトしますか", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (okAction) in
              NCMBUser.logOutInBackground { (error) in
                                  if error != nil{
                                      print(error)
                                  }else{
//                                        ログアウト成功
                    let storyboard = UIStoryboard(name: "LogIn", bundle: Bundle.main)
                    let rootViewController = storyboard.instantiateViewController(withIdentifier: "RootNavigationController")
                    UIApplication.shared.keyWindow?.rootViewController = rootViewController
                      
//                                  ログアウト状態保持
                    let ud = UserDefaults.standard
                    ud.set(false, forKey: "isLogin")
                    ud.synchronize()
                                
                            }
                    }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (cancelAction) in
                
                self.dismiss(animated: true, completion: nil)
              
        }
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
                  
          
    }
    
    @IBAction func cancelMember(){
        let alert = UIAlertController(title: "注意", message: "退会する場合は次の画面で必要事項を入力してください", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (okAction) in
            self.performSegue(withIdentifier: "toNext", sender: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (cancelAction) in
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    

//   @IBAction func fbButton(){
//        //        FBログイン
//                  let loginButton = FBLoginButton(); loginButton.center = view.center; view.addSubview(loginButton)
//
//                  if let token = AccessToken.current, !token.isExpired { // User is logged in, do work such as go to next view controller. }
//              }
//
//              loginButton.permissions = ["public_profile", "email"]
//
//
//    }
//
//
    
}
