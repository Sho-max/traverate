//
//  TimelineViewController.swift
//  Original App ver.2
//
//  Created by 石井　翔 on 2020/09/10.
//  Copyright © 2020 石井　翔. All rights reserved.
//

import UIKit
import NCMB
import Kingfisher
import SwiftDate
import Cosmos
import Hero



class TimelineViewController: UIViewController{
    
    var selectedPost: Post?
    var posts = [Post]()
    var blockUserIdArray = [String]()
    
    
    
    var selectedPlaceName: String!
    var selectedImageViewUrl: String!
    var starRating: Double!
    var selectedReview: String!
    var latitude: Double!
    var longitude: Double!
    
    
    @IBOutlet var TimelineTableView: UITableView!
    private let activityIndicator = UIActivityIndicatorView(style: .gray)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let height: CGFloat = 50 //whatever height you want to add to the existing height
        let bounds = self.navigationController!.navigationBar.bounds
        self.navigationController?.navigationBar.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height + height)
        
        
        //NCMB期限切れ対策
        guard let currentUser = NCMBUser.current() else {
            //ログインに戻る
            //ログアウト登録成功
            let storyboard = UIStoryboard(name: "LogIn", bundle: Bundle.main)
            let RootViewController = storyboard.instantiateViewController(withIdentifier: "RootNavigationController")
            UIApplication.shared.keyWindow?.rootViewController = RootViewController
            //ログアウト状態の保持
            let ud = UserDefaults.standard
            ud.set(false, forKey: "isLogin")
            ud.synchronize()
            return
        }
        TimelineTableView.dataSource = self
        TimelineTableView.delegate = self
        
        let nib = UINib(nibName: "TimelineTableViewCell", bundle: Bundle.main)
        
        TimelineTableView.register(nib, forCellReuseIdentifier: "cell")
        TimelineTableView.tableFooterView = UIView()
        TimelineTableView.rowHeight = 289
        TimelineTableView.layer.cornerRadius = 4
        TimelineTableView.clipsToBounds = true
        
        setRefreshControl()
        getBlockUser()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadTimeline()
        getBlockUser()
        
    }
    
    
    func loadTimeline() {
        guard let currentUser = NCMBUser.current() else {
            //            ログインに戻る
            
            //                      ログアウト成功
            let storyboard = UIStoryboard(name: "LogIn", bundle: Bundle.main)
            let rootViewController = storyboard.instantiateViewController(withIdentifier: "RootNavigationController")
            UIApplication.shared.keyWindow?.rootViewController = rootViewController
            
            //                ログイン状態保持
            let ud = UserDefaults.standard
            ud.set(false, forKey: "isLogin")
            
            return
        }
        
        
        
        let query = NCMBQuery(className: "Post")
        
        //        ユーザーの情報も取ってくる
        query?.includeKey("user")
        
        //        降順
        query?.order(byDescending: "createDate")
        
        
        //        オブジェクトの取得
        query?.findObjectsInBackground({ (result, error) in
            if error != nil {
                print(error!.localizedDescription)
            }else{
                // 投稿を格納しておく配列を初期化(これをしないとreload時にappendで二重に追加されてしまう)
                self.posts = [Post]()
                for postObject in result as! [NCMBObject] {
                    // ユーザー情報をUserクラスにセット
                    let user = postObject.object(forKey: "user") as! NCMBUser
                    // 退会済みユーザーの投稿を避けるため、activeがfalse以外のモノだけを表示
                    if user.object(forKey: "active") as? Bool != false {
                        // 投稿したユーxザーの情報をUserモデルにまとめる
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
                        
                        // bookmarkの状況(自分が過去にbookmarkしているか？)によってデータを挿入
                        let alreadyBookmarked = postObject.object(forKey: "bookmark") as? [String]
                        if alreadyBookmarked?.contains(currentUser.objectId) == true {
                            post.bookmark = true
                        } else {
                            post.bookmark = false
                        }
                        //                                           ブロックしてない民の投稿のdirectionとuserImageだけ表示
                        if self.blockUserIdArray.firstIndex(of: post.user.objectId) == nil{
                            //                                                配列に加える
                            self.posts.append(post)
                            
                            //ブロックした相手の投稿だったら見れないってアラート出す
                            
                        } else{
                            let alertText = "ブロックしたユーザーの投稿です"
                            let alertController = UIAlertController(title: "この投稿は表示できません", message: alertText, preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                            })
                            alertController.addAction(okAction)
                            self.present(alertController, animated: true, completion: nil)
                        }
                    }
                }
                //                                        投稿のデータが揃ったらTableViewをリロード
                self.TimelineTableView.reloadData()
            }
        })
    }
    
    
    func setRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(reloadTimeline(refreshControl:)), for: .valueChanged)
        TimelineTableView.addSubview(refreshControl)
    }
    
    @objc func reloadTimeline(refreshControl: UIRefreshControl) {
        refreshControl.beginRefreshing()
        //           self.loadFollowingUsers()
        // 更新が早すぎるので2秒遅延させる
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            refreshControl.endRefreshing()
        }
    }
    
}

extension TimelineViewController:TimelineTableViewCellDelegate{
    func didTapBlockButton(tableViewCell: UITableViewCell, button: UIButton) {
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "削除する", style: .destructive) { (action) in
            //            SVProgressHUD.show()
            let query = NCMBQuery(className: "Post")
            
            query?.getObjectInBackground(withId: self.posts[tableViewCell.tag].objectId, block: { (post, error) in
                if error != nil {
                    
                    
                } else {
                    // 取得した投稿オブジェクトを削除
                    post?.deleteInBackground({ (error) in
                        if error != nil {
                            
                        } else {
                            // 再読込
                            self.loadTimeline()
                            //SVProgressHUD.dismiss()
                        }
                    })
                }
            })
        }
        //報告しますか？ってアラートのアクション
        let reportAction = UIAlertAction(title: "報告する", style: .destructive) { (action) in
            
            
            let alert = UIAlertController(title: "完了", message: "この投稿を報告しました。\nご協力ありがとうございました。", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default) { (action) in
                alert.dismiss(animated: true, completion: nil)
            }
            
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            
            
            
        }
        //ブロックしますか？ってアラートのアクション
        let blockAction = UIAlertAction(title: "ブロック", style: .destructive) { (action) in
            
            //ブロックした人をNCMBに入れる(setObjectで作ってる)
            let blockObject = NCMBObject(className: "Block")
            
            blockObject?.setObject(NCMBUser.current(), forKey: "user")
            blockObject?.setObject(self.posts[tableViewCell.tag].user.objectId, forKey: "blockUserID")
            //それをsaveInBackgroundで読み込んでる
            blockObject?.saveInBackground({ (error) in
                if error != nil {
                    
                } else {
                    self.getBlockUser()
                    self.loadTimeline()
                }
            })
            //PKHUDで"このユーザーをブロックしました。"ってアラートを出す
            
            
        }
        //キャンセルのアクション
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { (action) in
            alertController.dismiss(animated: true, completion: nil)
        }
        if posts[tableViewCell.tag].user.objectId == NCMBUser.current().objectId {
            // 自分の投稿なので、削除ボタンを出す
            alertController.addAction(deleteAction)
            
        } else {
            // 他人の投稿なので、報告ボタン、ブロックボタンを出す
            alertController.addAction(reportAction)
            alertController.addAction(blockAction)
            
            
        }
        //キャンセルのアクション
        alertController.addAction(cancelAction)
        if UIDevice.current.userInterfaceIdiom == .pad {
            alertController.popoverPresentationController?.sourceView = self.view
            let screenSize = UIScreen.main.bounds
            alertController.popoverPresentationController?.sourceRect = CGRect(x: screenSize.size.width/4, y: screenSize.size.height/4, width: 10, height: 100)
        }
        self.present(alertController, animated: true, completion: nil)
    }
    
    func getBlockUser() {
        //classの中で、Blockをここで指定してる
        let query = NCMBQuery(className: "Block")
        
        //includeKeyでBlockの子クラスである会員情報を持ってきている
        query?.includeKey("user")
        //whereKeyでuserに絞り込んでる(whereは絞り込み、includeは指定)
        query?.whereKey("user", equalTo: NCMBUser.current())
        query?.findObjectsInBackground({ (result, error) in
            if error != nil {
                //エラーの処理
                print("getBlockUser読み込み失敗")
                print(error)
            } else {
                //ブロックされたユーザーのIDが含まれる + removeall()は初期化していて、データの重複を防いでいる
                self.blockUserIdArray.removeAll()
                for blockObject in result as! [NCMBObject] {
                    //この部分で①の配列にブロックユーザー情報が格納
                    self.blockUserIdArray.append(blockObject.object(forKey:"blockUserID") as! String)
                    
                }
                self.loadTimeline()
            }
        })
        self.loadTimeline()
    }
    
    
    func didTapBookmarkButton(tableViewCell: UITableViewCell, button: UIButton) {
        
        
        
        guard let currentUser = NCMBUser.current() else {
            //            ログインに戻る
            
            //                      ログアウト成功
            let storyboard = UIStoryboard(name: "LogIn", bundle: Bundle.main)
            let rootViewController = storyboard.instantiateViewController(withIdentifier: "RootNavigationController")
            UIApplication.shared.keyWindow?.rootViewController = rootViewController
            
            //                ログイン状態保持
            let ud = UserDefaults.standard
            ud.set(false, forKey: "isLogin")
            
            return
        }
        
        
        if posts[tableViewCell.tag].bookmark == false || posts[tableViewCell.tag].bookmark == nil {
            let query = NCMBQuery(className: "Post")
            query?.getObjectInBackground(withId: posts[tableViewCell.tag].objectId, block: { (post, error) in
                post?.addUniqueObject(NCMBUser.current().objectId, forKey: "bookmark")
                post?.saveEventually({ (error) in
                    if error != nil {
                        print(error!.localizedDescription)
                    } else {
                        self.loadTimeline()
                    }
                })
            })
        } else {
            let query = NCMBQuery(className: "Post")
            query?.getObjectInBackground(withId: posts[tableViewCell.tag].objectId, block: { (post, error) in
                if error != nil {
                    print(error!.localizedDescription)
                } else {
                    post?.removeObjects(in: [currentUser.objectId], forKey: "bookmark")
                    post?.saveEventually({ (error) in
                        if error != nil {
                            
                        } else {
                            self.loadTimeline()
                        }
                    })
                }
            })
        }
        
        
    }
    
}

extension TimelineViewController: UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TimelineTableViewCell
        
        //        内容
        cell.delegate = self
        cell.tag = indexPath.row
        
        
        let user = posts[indexPath.row].user
        cell.userName.text = user.displayName
        print(user.objectId)
        let userImageUrl = "https://mbaas.api.nifcloud.com/2013-09-01/applications/HGYdG7jKStu9dgRH/publicFiles/"+user.objectId
        cell.userImage.kf.setImage(with: URL(string: userImageUrl), placeholder: UIImage(named: "placeholder.jpeg"))
        let imageUrl = posts[indexPath.row].imageUrl
        cell.viewImage.kf.setImage(with: URL(string: imageUrl))
        
        let placeName = posts[indexPath.row].placeName
        cell.placeName.text = placeName
        
        let starEvaluation = posts[indexPath.row].star
        cell.cosmosView.rating = starEvaluation
        
        
        let comment = posts[indexPath.row].text
        cell.reviewTextView.text = comment
        
        
        // bookmarkによってブックマークの表示を変える
        //                        if posts[indexPath.row].bookmark == true {
        //                            cell.bookmark.setImage(UIImage(named: "bookmark_filled"), for: .normal)
        //                            } else {
        //                            cell.bookmark.setImage(UIImage(named: "bookmark_outlined"), for: .normal)
        //                        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedPlaceName = posts[indexPath.row].placeName
        selectedImageViewUrl = posts[indexPath.row].imageUrl
        selectedReview = posts[indexPath.row].text
        starRating = posts[indexPath.row].star
        latitude = posts[indexPath.row].latitude
        longitude = posts[indexPath.row].longitude
        
        self.performSegue(withIdentifier: "toDetail", sender: nil)        
    }
    
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
