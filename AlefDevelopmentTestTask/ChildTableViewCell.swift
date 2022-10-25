//
//  ChildTableViewCell.swift
//  AlefDevelopmentTestTask
//
//  Created by Артур Фомин on 25.10.2022.
//

import UIKit

class ChildTableViewCell: UITableViewCell {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    
    
    //MARK: - let/var
    
    var didDelete: ((UITableViewCell) -> Void)?
    
    //MARK: - Lifecycle methods

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    //MARK: - IBActions
    
    @IBAction func deletePressed(_ sender: UIButton) {
        didDelete?(self)
    }
    
}

