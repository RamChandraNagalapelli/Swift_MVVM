//
//  WeatherItemViewModel.swift
//  WeatherAppMVVM
//
//  Created by ramchandra on 16/02/18.
//  Copyright © 2018 ramchandra. All rights reserved.
//

import Foundation

class WeatherItemViewModel {

    let baseUrl = "http://api.openweathermap.org/data/2.5/forecast"
    let appId = "***************************"
    let latitude = 23.0170775
    let longitude = 72.5263869

    var currentWeatherIconUrl: URL?
    var currentTemp: String = ""
    var currentWeatherDescription: String = ""
    var cityName: String = ""

    var arrWeatherItems: [WeatherItem] = [] {
        didSet {
            let weatherData = arrWeatherItems.first
            let icon = weatherData?.icon ?? ""
            currentWeatherIconUrl = URL(string: "http://openweathermap.org/img/w/" + icon + ".png")
            currentTemp = (weatherData?.temp.rounded(toPlaces: 2).string ?? "#") + "° C"
            currentWeatherDescription = weatherData?.descripton ?? ""
        }
    }

    var numberOfItems: Int {
        return arrWeatherItems.count
    }

    lazy var dateFormatter = DateFormatter()

    func getWeatherData(_ completionHandler: @escaping (String?) -> Void) {
        let urlString = baseUrl + "?lat=\(latitude)&lon=\(longitude)" + "&appid=\(appId)" + "&units=metric"
        WeatherApiServices.fetchWeatherData(urlString: urlString, success: { (weatherArray, city) in
            self.cityName = city
            self.arrWeatherItems = weatherArray
            completionHandler(nil)
            }, failure: { errMessage in
                self.cityName = ""
                self.arrWeatherItems = []
                completionHandler(errMessage)
        })
    }

    func dateString(atIndex index: Int) -> String {
        guard numberOfItems > index else { return "" }
        dateFormatter.amSymbol = "am"
        dateFormatter.pmSymbol = "pm"
        dateFormatter.dateFormat = "EEEE, hh:mma"
        return dateFormatter.string(from: arrWeatherItems[index].date)
    }

    func imageUrl(atIndex index: Int) -> URL {
        guard numberOfItems > index else { return URL(string: "")! }
        let icon = arrWeatherItems[index].icon
        return URL(string: "http://openweathermap.org/img/w/" + icon + ".png")!
    }

    func minTemp(atIndex index: Int) -> String {
        guard numberOfItems > index else { return "" }
        return arrWeatherItems[index].minTemp.roundedString + "°"
    }

    func maxTemp(atIndex index: Int) -> String {
        guard numberOfItems > index else { return "" }
        return arrWeatherItems[index].maxTemp.roundedString + "°"
    }
}
