//
//  WeatherApiServices.swift
//  WeatherAppMVC
//
//  Created by ramchandra on 16/02/18.
//  Copyright © 2018 ramchandra. All rights reserved.
//

import Foundation

class WeatherApiServices {
    static let sww = "Oops... Something went wrong!\nPlease try again."
    class func fetchWeatherData(urlString: String, success: @escaping ([WeatherItem], String) -> Void, failure: @escaping (String) -> Void) {
        NetworkManager.requestForURL(reqUrl: URL(string: urlString)!, method: .get, parameters: nil, success: { response in
            if let code = response.value(forKey: "cod") as? String, code == "200" {
                if let arrData = response.value(forKey: "list") as? [NSDictionary] {
                    success(arrData.map { WeatherItem($0) }, response.value(forKeyPath: "city.name") as? String ?? "NA")
                } else {
                    failure(response.value(forKey: "message") as? String ?? sww)
                }
            } else {
                failure(response.value(forKey: "message") as? String ?? sww)
            }
        }, failure: { error in
            failure(error?.localizedDescription ?? sww)
        })
    }
}
