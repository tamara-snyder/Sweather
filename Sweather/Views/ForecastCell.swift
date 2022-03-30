//
//  ForecastCell.swift
//  Sweather
//
//  Created by Tamara Snyder on 3/30/22.
//

import UIKit

class ForecastCell: UITableViewCell {
	
	@IBOutlet weak var forecastDay: UILabel!
	@IBOutlet weak var forecastText: UILabel!
	@IBOutlet weak var forecastImage: UIImageView!
	@IBOutlet weak var forecastTempRange: UILabel!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
