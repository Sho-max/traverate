//
//  myPageViewController.swift
//  Original App ver.2
//
//  Created by 石井　翔 on 2020/09/09.
//  Copyright © 2020 石井　翔. All rights reserved.
//

import UIKit
import NCMB
import Kingfisher

class myPageViewController: UIViewController,UITextViewDelegate {
    
    var posts = [Post]()
    
    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var userDisplayName: UILabel!
    @IBOutlet var userIntroduction: UITextView!
    @IBOutlet weak var bookmarkTableView: UITableView!
    @IBOutlet weak var bookmarkLabel: UILabel!
    
       var selectedPlaceName: String!
       var selectedImageViewUrl: String!
       var starRating: Double!
       var selectedReview: String!
       var latitude: Double!
       var longitude: Double!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bookmarkTableView.delegate = self
        bookmarkTableView.dataSource = self
      
        userIntroduction.delegate = self
        userImageView.layer.cornerRadius = userImageView.bounds.width / 2.0
        userImageView.layer.masksToBounds = true
        
        let nib = UINib(nibName: "bookmarkTableViewCell", bundle: Bundle.main)
               
        bookmarkTableView.register(nib, forCellReuseIdentifier: "cell")
        bookmarkTableView.tableFooterView = UIView()
        
        bookmarkTableView.rowHeight = 70
    
    
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
            
            setNameBookmark()
            loadPosts()
            
            if let user = NCMBUser.current(){
                userDisplayName.text = user.object(forKey: "displayName") as? String
                userIntroduction.text = user.object(forKey: "introduction") as? String
                    
                self.navigationItem.title = user.userName
                    
                    
                    
                    
                    
                    let file = NCMBFile.file(withName: user.objectId, data: nil) as! NCMBFile
                    file.getDataInBackground { (data, error) in
                        if error != nil{
                            print(error)
                        }else{
                            if data != nil{
                                let image = UIImage(data: data!)
                                self.userImageView.image = image
                        }
                    }
                }
            }else{
    //            NCMBUser.current()がnilだったとき
                let storyboard = UIStoryboard(name: "LogIn", bundle: Bundle.main)
                        let rootViewController = storyboard.instantiateViewController(withIdentifier: "RootNavigationController")
                        UIApplication.shared.keyWindow?.rootViewController = rootViewController
                    
                //                ログイン状態保持
                        let ud = UserDefaults.standard
                        ud.set(false, forKey: "isLogin")
                        ud.synchronize()
                                    
            }
        }
     override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
    
    private func setNameBookmark(){
        
        let userName = NCMBUser.current()?.userName
        if (userName != nil){
            bookmarkLabel.text = "\(userName!)さんの投稿はこちら"
        }
        
    }
        

        func loadPosts() {
                let query = NCMBQuery(className: "Post")
                let user = NCMBUser.current()!
                query?.includeKey("user")
            
                query?.findObjectsInBackground({ (result, error) in
                    if error != nil {
//                        アラートを入れる
                        
                    } else {
                        
                        self.posts = [Post]()
                        
                        for postObject in result as! [NCMBObject] {
                            
                          if user.object(forKey: "active") as? Bool != false{
                            // ユーザー情報をUserクラスにセット
                            let user = postObject.object(forKey: "user") as! NCMBUser
                            let userModel = User(objectId: user.objectId, userName: user.userName)
                            userModel.displayName = user.object(forKey: "displayName") as? String
                            
                            // 投稿の情報を取得
                            let imageUrl = postObject.object(forKey: "imageUrl") as! String
                            let text = postObject.object(forKey: "text") as! String
                            let placeName = postObject.object(forKey: "placeName") as! String
                            let star = postObject.object(forKey: "star") as! Double
                            let latitude = postObject.object(forKey: "latitude") as! Double
                            let longitude = postObject.object(forKey: "longitude") as! Double
                            
                            
                            // 2つのデータ(投稿情報と誰が投稿したか?)を合わせてPostクラスにセット
                            let post = Post(user: userModel, objectId: postObject.objectId, imageUrl: imageUrl, text: text, createDate: postObject.createDate, placeName: placeName, star: star, longitude: longitude, latitude: latitude)
                           
                            if(user.objectId == NCMBUser.current()?.objectId ){
                                   self.posts.append(post)
                            }
                        }
                        }
                        self.bookmarkTableView.reloadData()
                        
                    }
                })
            }
            
         
    

}

extension myPageViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! bookmarkTableViewCell
//                内容
                  cell.tag = indexPath.row
    
                    let imageUrl = posts[indexPath.row].imageUrl
                    cell.viewImage.kf.setImage(with: URL(string: imageUrl))
                    let placeName = posts[indexPath.row].placeName
                    cell.placeName.text = placeName
                    let starRating = posts[indexPath.row].star
                    cell.starRating.rating = starRating
        
        return cell
        
    }
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//          selectedPlaceName = bookmarks[indexPath.row].placeName
//          selectedImageViewUrl = bookmarks[indexPath.row].imageUrl
//          selectedReview = bookmarks[indexPath.row].text
//          starRating = bookmarks[indexPath.row].star
//          latitude = bookmarks[indexPath.row].latitude
//          longitude = bookmarks[indexPath.row].longitude
//
//          self.performSegue(withIdentifier: "toDetail", sender: nil)
//      }
      
      override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
          if(segue.identifier == "toDetail"){
              let DetailViewController: placrDetailViewController = ((segue.destination as? placrDetailViewController)!)
              DetailViewController.passedPlaceName = selectedPlaceName
              DetailViewController.passedImageUrl = selectedImageViewUrl
              DetailViewController.passedStarRating = starRating
              DetailViewController.reviewText = selectedReview
              DetailViewController.passedLatitude = latitude
              DetailViewController.passedLongitude = longitude
             
          }
    
    
}
}
//extension myPageViewController: bookmarkTableViewCellDelegate{
//    func pushedTheDeleteButton(button: UIButton) {
//        print("success")
//         let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
//
//                   let deleteAction = UIAlertAction(title: "削除する", style: .destructive) { (action) in
//                       //            SVProgressHUD.show()
//                       let query = NCMBQuery(className: "Post")
//
//                    query?.getObjectInBackground(withId: NCMBUser.current()?.objectId, block: { (post, error) in
//                           if error != nil {
//
//
//                           } else {
//                               // 取得した投稿オブジェクトを削除
//                               post?.deleteInBackground({ (error) in
//                                   if error != nil {
//
//                                   } else {
//                                       // 再読込
//                                       self.loadPosts()
//                                       //SVProgressHUD.dismiss()
//                                   }
//                               })
//                           }
//                       })
//               }
//
//        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { (action) in
//            alertController.dismiss(animated: true, completion: nil)
//        }
//
//                         自分の投稿なので、削除ボタンを出す
//            alertController.addAction(deleteAction)
//            alertController.addAction(cancelAction)
//        if UIDevice.current.userInterfaceIdiom == .pad {
//            alertController.popoverPresentationController?.sourceView = self.view
//            let screenSize = UIScreen.main.bounds
//            alertController.popoverPresentationController?.sourceRect = CGRect(x: screenSize.size.width/2, y: screenSize.size.height, width: 0, height: 0)
//        }
//            self.present(alertController, animated: true, completion: nil)
//
//
//    }

//}
