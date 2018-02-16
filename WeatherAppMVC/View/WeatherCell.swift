//
//  WeatherCell.swift
//  WeatherAppMVC
//
//  Created by ramchandra on 16/02/18.
//  Copyright © 2018 ramchandra. All rights reserved.
//

import UIKit

class WeatherCell: UITableViewCell {

    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var imageWeather: UIImageView!
    @IBOutlet weak var labelMaxTemp: UILabel!
    @IBOutlet weak var labelMinTemp: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
