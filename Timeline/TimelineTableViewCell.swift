//
//  TimelineTableViewCell.swift
//  Original App ver.2
//
//  Created by 石井　翔 on 2020/09/10.
//  Copyright © 2020 石井　翔. All rights reserved.
//

import UIKit
import Cosmos
import Hero

protocol TimelineTableViewCellDelegate {
//    func didTapBookmarkButton(tableViewCell: UITableViewCell, button: UIButton)
    func didTapBlockButton(tableViewCell: UITableViewCell, button: UIButton)
}

class TimelineTableViewCell: UITableViewCell {

    var delegate: TimelineTableViewCellDelegate?
    
    @IBOutlet weak var cosmosView: CosmosView!
    @IBOutlet var userImage: UIImageView!
    @IBOutlet var userName: UILabel!
    @IBOutlet var viewImage: UIImageView!
//    @IBOutlet var bookmark: UIButton!
    @IBOutlet weak var placeName: UILabel!
    @IBOutlet weak var blockButton: UIButton!
    @IBOutlet weak var reviewTextView: UITextView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        userImage.layer.cornerRadius = userImage.bounds.width / 2
        userImage.clipsToBounds = true
        
        viewImage.layer.cornerRadius = 4
        viewImage.clipsToBounds = true
        
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
//    @IBAction func didTapBookmarkButton(button: UIButton){
//        self.delegate?.didTapBookmarkButton(tableViewCell: self, button: button)
//    }
    
    @IBAction func didTapBlockButton(button: UIButton){
           self.delegate?.didTapBlockButton(tableViewCell: self, button: button)
       }
       
   
}
