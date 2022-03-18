//
//  ForecastWeatherTableViewCell.swift
//  WeatherApp
//
//  Created by CheChenLiu on 2022/3/1.
//

import UIKit

class ForecastWeatherTableViewCell: UITableViewCell {
    
    @IBOutlet weak var forecastTimeLabel: UILabel!
    @IBOutlet weak var forecastWeatherIconImageView: UIImageView!
    @IBOutlet weak var forecastTempLabel: UILabel!
    @IBOutlet weak var forecastHumidityLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
