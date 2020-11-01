//
//  BranchTableViewCell.swift
//  BankLocator
//
//  Created by Pritam on 1/11/20.
//

import UIKit

class BranchTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var aliasLabel: UILabel!
    
    public func configure(barnch: Branch) {
        nameLabel.text = barnch.name
        addressLabel.text = barnch.address
        aliasLabel.backgroundColor = barnch.type.backgroundColor
        aliasLabel.text = barnch.type.alias
        
        aliasLabel.layer.cornerRadius = (aliasLabel.frame.height / 2)
        aliasLabel.layer.masksToBounds = true
    }
}
