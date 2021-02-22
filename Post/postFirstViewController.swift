//
//  postFirstViewController.swift
//  Original App ver.2
//
//  Created by 石井　翔 on 2020/09/12.
//  Copyright © 2020 石井　翔. All rights reserved.
//

import UIKit
import NCMB

class postFirstViewController: UIViewController {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        movesPos()
    }
    
    
    
    func movesPos(){
        self.performSegue(withIdentifier: "toSlelectionOfPost", sender: nil)
    }
    
    
    
    
    
    
}
