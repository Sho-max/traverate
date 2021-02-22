//
//  bookmarkTableViewCell.swift
//  Original App ver.2
//
//  Created by 石井　翔 on 2020/10/14.
//  Copyright © 2020 石井　翔. All rights reserved.
//

import UIKit
import Cosmos

//protocol bookmarkTableViewCellDelegate{
//    func pushedTheDeleteButton(button:UIButton)
//}

class bookmarkTableViewCell: UITableViewCell {

//     var delegate: bookmarkTableViewCellDelegate?
    
    @IBOutlet weak var viewImage: UIImageView!
    @IBOutlet weak var placeName: UILabel!
    @IBOutlet weak var starRating: CosmosView!
//    @IBOutlet weak var deleteMenuButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        viewImage.layer.cornerRadius = viewImage.frame.width * 0.1
        viewImage.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)


    }
//
//    @IBAction func pushedTheDeleteButton(button:UIButton){
//        self.delegate?.pushedTheDeleteButton(button: button)
//}
}
