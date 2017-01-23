//
//  AssetTableViewCell.swift
//  3DTouchDemo
//
//  Created by Juan Catalan on 1/21/17.
//  Copyright © 2017 Bitcrafters, Inc. All rights reserved.
//

import UIKit

class AssetTableViewCell: UITableViewCell {

    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var detail: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var favorite: UILabel!
    
    var asset: Asset {
        willSet(newAsset) {
            name.text = newAsset.name
            detail.text = newAsset.detail
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy"
            date.text = dateFormatter.string(from: newAsset.date)
            if newAsset.favorite {
                favorite.text = "❤️"
                favorite.isHidden = false
            } else {
                favorite.isHidden = true
            }
            thumbnail.image = UIImage(data: newAsset.imageData)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.asset = Asset()
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
