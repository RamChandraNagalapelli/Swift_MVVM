//
//  DayView.swift
//  WeatherAppMVC
//
//  Created by ramchandra on 16/02/18.
//  Copyright © 2018 ramchandra. All rights reserved.
//

import UIKit

class DayView: UIView {

    @IBOutlet var labelCity: UILabel!
    @IBOutlet var labelDescription: UILabel!
    @IBOutlet var labelTemp: UILabel!
    @IBOutlet var imageWeather: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        labelCity.text = "NA"
        labelDescription.text = "NA"
        labelTemp.text = "#° C"
        self.bounds.size.height = UIScreen.main.bounds.width / 4 + 75
        layoutIfNeeded()
    }

}
