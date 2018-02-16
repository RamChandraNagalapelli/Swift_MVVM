//
//  HomeViewController.swift
//  WeatherAppMVC
//
//  Created by ramchandra on 16/02/18.
//  Copyright © 2018 ramchandra. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    let baseUrl = "http://api.openweathermap.org/data/2.5/forecast"
    let appId = "1fa136797a15633a60b2ec78f34a1179"
    let latitude = 23.0170775
    let longitude = 72.5263869
    lazy var dateFormatter = DateFormatter()

    var arrWeatherItems: [WeatherItem] = [] {
        didSet {
            DispatchQueue.main.async {
                self.reloadDayView(self.arrWeatherItems.first)
                self.tableViewWeather.reloadData()
            }
        }
    }
    var cityName: String = "" {
        didSet {
            DispatchQueue.main.async {
                self.dayView.labelCity.text = self.cityName
            }
        }
    }

    @IBOutlet weak var tableViewWeather: UITableView!
    @IBOutlet weak var dayView: DayView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewWeather.dataSource = self
        tableViewWeather.delegate = self
        tableViewWeather.tableFooterView = UIView()
        tableViewWeather.rowHeight = UITableViewAutomaticDimension
        tableViewWeather.estimatedRowHeight = 60
        dateFormatter.dateFormat = "EEEE, hh:mm a"
        getWeatherData()
    }

    func getWeatherData() {
        let urlString = baseUrl + "?lat=\(latitude)&lon=\(longitude)" + "&appid=\(appId)" + "&units=metric"
        WeatherApiServices.fetchWeatherData(urlString: urlString, success: { [weak self] (weatherArray, city) in
            self?.cityName = city
            self?.arrWeatherItems = weatherArray
        }, failure: { [weak self] errMessage in
            self?.showAlert(title: "Alert", message: errMessage, buttons: ["Ok"], actions: nil)
        })
    }

    func reloadDayView(_ data: WeatherItem?) {
        dayView.labelTemp.text = (data?.temp.rounded(toPlaces: 2).string ?? "#") + "°"
        dayView.labelDescription.text = data?.descripton ?? ""
        let imageUrl = URL(string: "http://openweathermap.org/img/w/" + (data?.icon ?? "") + ".png")!
        dayView.imageWeather.setImage(fromUrl: imageUrl)
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrWeatherItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell") as? WeatherCell else {
            return UITableViewCell()
        }
        let weatherData = arrWeatherItems[indexPath.row]
        cell.labelTime.text = dateFormatter.string(from: weatherData.date)
        cell.labelMaxTemp.text = weatherData.maxTemp.roundedString + "°"
        cell.labelMinTemp.text = weatherData.minTemp.roundedString + "°"
        let imageUrl = URL(string: "http://openweathermap.org/img/w/" + weatherData.icon + ".png")!
        cell.imageWeather.setImage(fromUrl: imageUrl)
        return cell
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}
