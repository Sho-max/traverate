//
//  ResendPasswordViewController.swift
//  Original App ver.2
//
//  Created by 石井　翔 on 2020/10/25.
//  Copyright © 2020 石井　翔. All rights reserved.
//

import UIKit
import NCMB

class ResendPasswordViewController: UIViewController,UITextFieldDelegate {
    
    
    @IBOutlet weak var MailAddress: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var confirmationEmailAddress: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sendButton.layer.cornerRadius = sendButton.frame.size.width * 0.1
        sendButton.clipsToBounds = true
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func resendMail(_ sender: Any) {
        
        
        var error : NSError? = nil
        if(self.MailAddress.text! == self.confirmationEmailAddress.text!){
            if (error != nil) {
                print(error ?? "")
            }else{
                NCMBUser.requestPasswordReset(forEmail: self.MailAddress.text, error: &error)
                
                print("メール完了")
                let alert = UIAlertController(title: "完了", message: "メールを送りました。\nメールの案内に従ってパスワードを\n変更してください", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default) { (okAction) in
                    self.dismiss(animated: true, completion: nil)
                }
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }
            
        }else{
            let alert = UIAlertController(title: "注意", message: "メールアドレスが一致しません", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (okAction) in
                alert.dismiss(animated: true, completion: nil)
            }
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    
}
