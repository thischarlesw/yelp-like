//
//  FavCell.swift
//  Yelp
//
//  Created by Charles Wang on 3/3/20.
//  Copyright © 2020 Charles Wang. All rights reserved.
//

import UIKit

class FavCell: UITableViewCell {
    @IBOutlet weak var restaurantLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
