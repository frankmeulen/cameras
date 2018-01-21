//
//  CameraCell.swift
//  Infi_test
//
//  Created by Frank van der Meulen on 21-01-18.
//  Copyright © 2018 Frank van der Meulen. All rights reserved.
//

import UIKit

class CameraCell: UITableViewCell {
    
    
    @IBOutlet weak var CameraNaam: UILabel!
    @IBOutlet weak var cameraNummer: UILabel!
    @IBOutlet weak var cameraLatitude: UILabel!
    @IBOutlet weak var cameraLongitude: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
