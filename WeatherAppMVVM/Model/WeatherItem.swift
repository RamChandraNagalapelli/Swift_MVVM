//
//  WeatherItem.swift
//  WeatherAppMVC
//
//  Created by ramchandra on 16/02/18.
//  Copyright © 2018 ramchandra. All rights reserved.
//

import Foundation

struct WeatherItem {
    var city: String
    var descripton: String
    var icon: String
    var temp: Double
    var minTemp: Double
    var maxTemp: Double
    var date: Date

    init(_ data: NSDictionary) {
        city = data.value(forKey: "name") as? String ?? ""
        let weather = (data.value(forKey: "weather") as? [NSDictionary])?.first
        descripton = weather?.value(forKeyPath: "description") as? String ?? ""
        icon = weather?.value(forKeyPath: "icon") as? String ?? ""
        temp = data.value(forKeyPath: "main.temp") as? Double ?? 0
        minTemp = data.value(forKeyPath: "main.temp_min") as? Double ?? 0
        maxTemp = data.value(forKeyPath: "main.temp_max") as? Double ?? 0
        temp = data.value(forKeyPath: "main.temp") as? Double ?? 0
        let dt = data.value(forKey: "dt") as? TimeInterval ?? 0
        date = Date(timeIntervalSince1970: dt)
    }
}
