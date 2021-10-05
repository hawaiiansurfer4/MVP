//
//  ScannerTableViewCell.swift
//  MVP
//
//  Created by Sean Murphy on 9/9/21.
//

import UIKit

class ScannerTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        descriptionLabel.adjustsFontForContentSizeCategory = true
        descriptionLabel.sizeToFit()
        descriptionLabel.numberOfLines = 2
        titleLabel.sizeToFit()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
