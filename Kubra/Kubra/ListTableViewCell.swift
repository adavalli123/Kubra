//
//  ListTableViewCell.swift
//  Kubra
//
//  Created by Srikanth Adavalli on 4/25/17.
//  Copyright © 2017 Srikanth Adavalli. All rights reserved.
//

import UIKit

class ListTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(name: String, userName: String, address: String) {
        self.nameLabel.text = name
        self.userNameLabel.text = userName
        self.addressLabel.text = address
    }
}
