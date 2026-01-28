//
//  MessageCell.swift
//  Flash Chat iOS13
//
//  Created by Sanyukta Adhate on 27/01/26.
//  Copyright © 2026 Angela Yu. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {

    
    
    @IBOutlet weak var messageField: UIView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var youAvatar: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        messageField.layer.cornerRadius = messageField.frame.size.height / 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
