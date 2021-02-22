//
//  PostViewController.swift
//  Original App ver.2
//
//  Created by 石井　翔 on 2020/09/16.
//  Copyright © 2020 石井　翔. All rights reserved.
//

import UIKit
import Cosmos
import NCMB
import NYXImagesKit
import UITextView_Placeholder



class PostViewController: UIViewController,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    let placeholderImage = UIImage(named: "photo-placeholder")
    var resizedImage: UIImage!
    
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var postTextView: UITextView!
    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var cosmosView: CosmosView!
    @IBOutlet weak var placeNameTextField: UITextField!
    
    
    
    var latitude: Double!
    var longitude: Double!
    let udLat = UserDefaults.standard
    let udLong = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        postImageView.image = placeholderImage
        postButton.isEnabled = false
        postTextView.placeholder = "おすすめ理由を書く"
        postTextView.delegate = self
        postButton.layer.cornerRadius = postButton.frame.width * 0.1
        postButton.clipsToBounds = true
        postButton.backgroundColor =  #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1).withAlphaComponent(0.5)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        pickNumbersFromUserDefalts()
        imagePickerWhenViewWillAppearCalled()
        print(latitude!)
        print(longitude!)
        
    }
    
    private func pickNumbersFromUserDefalts(){
        let udLat = UserDefaults.standard
        let udLong = UserDefaults.standard
        latitude = udLat.double(forKey: "latitude")
        longitude = udLong.double(forKey: "longitude")
        confirmContent()
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        resizedImage = selectedImage.scale(byFactor: 0.2)
        postImageView.image = resizedImage
        
        picker.dismiss(animated: true, completion: nil)
        
        confirmContent()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        confirmContent()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.resignFirstResponder()
    }
    
    
    @IBAction func selectImage(){
        let alert = UIAlertController(title: "画像選択", message: "シェアする画像を選択してください", preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { (action) in
            alert.dismiss(animated: true, completion: nil)
        }
        
        
        let cameraAction = UIAlertAction(title: "カメラで撮影", style: .default) { (action) in
            //            カメラ起動
            if UIImagePickerController.isSourceTypeAvailable(.camera) == true{
                
                let picker = UIImagePickerController()
                
                picker.sourceType = .camera
                picker.delegate = self
                self.present(picker, animated: true, completion: nil)
            }else{
                print("この端末ではカメラは使用できません")
                
                let alert = UIAlertController(title: "注意", message: "この端末ではカメラは使用できません", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default) { (action) in
                    alert.dismiss(animated: true, completion: nil)
                }
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
                
            }
            
        }
        
        let photoLibraryAction = UIAlertAction(title: "フォトライブラリ", style: .default) { (action) in
            //            アルバム起動
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) == true{
                let picker = UIImagePickerController()
                picker.sourceType = .photoLibrary
                picker.delegate = self
                self.present(picker, animated: true, completion: nil)
            }else{
                print("この端末ではフォトライブラリを使用できません")
                let alert = UIAlertController(title: "注意", message: "この端末ではフォトライブラリを使用できません", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default) { (action) in
                    alert.dismiss(animated: true, completion: nil)
                }
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }
            
        }
        
        alert.addAction(cancelAction)
        alert.addAction(cameraAction)
        alert.addAction(photoLibraryAction)
        let screenSize = UIScreen.main.bounds
        // ここで表示位置を調整
        // xは画面中央、yは画面下部になる様に指定
        alert.popoverPresentationController?.sourceView = self.view
        alert.popoverPresentationController?.sourceRect = CGRect(x: screenSize.size.width/2, y: screenSize.size.height, width: 0, height: 0)
        self.present(alert, animated: true, completion: nil)
        confirmContent()
        
    }
    
    func imagePickerWhenViewWillAppearCalled(){
        let alert = UIAlertController(title: "画像選択", message: "シェアする画像を選択してください", preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { (action) in
            alert.dismiss(animated: true, completion: nil)
        }
        
        
        let cameraAction = UIAlertAction(title: "カメラで撮影", style: .default) { (action) in
            //            カメラ起動
            if UIImagePickerController.isSourceTypeAvailable(.camera) == true{
                
                let picker = UIImagePickerController()
                
                picker.sourceType = .camera
                picker.delegate = self
                self.present(picker, animated: true, completion: nil)
            }else{
                print("この端末ではカメラは使用できません")
                
                let alert = UIAlertController(title: "注意", message: "この端末ではカメラは使用できません", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default) { (action) in
                    alert.dismiss(animated: true, completion: nil)
                }
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
                
            }
            
        }
        
        let photoLibraryAction = UIAlertAction(title: "フォトライブラリ", style: .default) { (action) in
            //            アルバム起動
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) == true{
                let picker = UIImagePickerController()
                picker.sourceType = .photoLibrary
                picker.delegate = self
                self.present(picker, animated: true, completion: nil)
            }else{
                print("この端末ではフォトライブラリを使用できません")
                let alert = UIAlertController(title: "注意", message: "この端末ではフォトライブラリを使用できません", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default) { (action) in
                    alert.dismiss(animated: true, completion: nil)
                }
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }
            
        }
        
        alert.addAction(cancelAction)
        alert.addAction(cameraAction)
        alert.addAction(photoLibraryAction)
        if UIDevice.current.userInterfaceIdiom == .pad {
            alert.popoverPresentationController?.sourceView = self.view
            let screenSize = UIScreen.main.bounds
            alert.popoverPresentationController?.sourceRect = CGRect(x: screenSize.size.width/2, y: screenSize.size.height, width: 0, height: 0)
        }
        self.present(alert, animated: true, completion: nil)
        confirmContent()
        
    }
    
    
    
    
    
    @IBAction func postFunction(){
        
        //        撮影した画像をデータ化した時に右90度回転してしまう問題の解消
        
        UIGraphicsBeginImageContext(resizedImage.size)
        let rect = CGRect(x: 0, y: 0, width: resizedImage.size.width, height: resizedImage.size.height)
        resizedImage.draw(in: rect)
        resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let data = resizedImage.pngData()
        //        ここを変更（ファイル名ないので）
        
        let file = NCMBFile.file(with: data) as! NCMBFile
        file.saveInBackground({ (error) in
            if error != nil{
                //                       アラート
                let alert = UIAlertController(title: "画像アップロードエラー", message: error!.localizedDescription, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                    
                })
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            } else{
                //                画像アップロードが成功
                
                let postObject = NCMBObject(className: "Post")
                
                if self.postTextView.text.count == 0{
                    print("入力されていません")
                    let alert = UIAlertController(title: "注意", message: "入力されていません", preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .default) { (action) in
                        alert.dismiss(animated: true, completion: nil)
                    }
                    alert.addAction(action)
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                
                
                postObject?.setObject(self.postTextView.text!, forKey: "text")
                postObject?.setObject(NCMBUser.current(), forKey: "user")
                postObject?.setObject(self.placeNameTextField.text!, forKey: "placeName")
                postObject?.setObject(self.cosmosView.rating, forKey: "star")
                postObject?.setObject(self.latitude, forKey: "latitude")
                postObject?.setObject(self.longitude, forKey: "longitude")
                
                let url = "https://mbaas.api.nifcloud.com/2013-09-01/applications/HGYdG7jKStu9dgRH/publicFiles/" + file.name
                postObject?.setObject(url, forKey: "imageUrl")
                postObject?.saveInBackground({ (error) in
                    if error != nil{
                        //                          アラート
                        
                        
                    }else{
                        self.postImageView.image = nil
                        self.postImageView.image = UIImage(named: "photo-placeholder")
                        self.postTextView.text = nil
                        self.cosmosView.rating = 0
                        self.placeNameTextField.text = nil
                        let alert = UIAlertController(title: "完了", message: "投稿が完了しました", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK", style: .default) { (okAction) in
                            let UINavigationController = self.tabBarController?.viewControllers?[0];
                            self.tabBarController?.selectedViewController = UINavigationController;
                        }
                        alert.addAction(okAction)
                        self.present(alert, animated: true, completion: nil)
                        
                    }
                })
            }
            
        }){(progress) in
            print(progress)
        }
        
    }
    
    
    
    func confirmContent(){
        if postTextView.text.count > 0 && postImageView.image != nil && cosmosView.rating > 0 && placeNameTextField.text!.count > 0 {
            print("変更")
            postButton.isEnabled = true
            postButton.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        }else{
            postButton.isEnabled = false
            
        }
    }
    
    @IBAction func cancel(){
        if postTextView.isFirstResponder == true{
            postTextView.resignFirstResponder()
        }
        let alert = UIAlertController(title: "投稿内容の破棄", message: "入力中の投稿内容を破棄しますか？", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
            self.postTextView.text = nil
            self.postImageView.image = UIImage(named: "photo-placeholder")
            self.cosmosView.rating = 0
            self.placeNameTextField.text = nil
            self.confirmContent()
        })
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        })
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    
}



