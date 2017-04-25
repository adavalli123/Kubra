//
//  DetailTableViewCell.swift
//  Kubra
//
//  Created by Srikanth Adavalli on 4/25/17.
//  Copyright © 2017 Srikanth Adavalli. All rights reserved.
//

import UIKit

class DetailTableviewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    
    func configure(title: String, body: String) {
        self.titleLabel.text = title
        self.bodyLabel.text = body
    }
}
