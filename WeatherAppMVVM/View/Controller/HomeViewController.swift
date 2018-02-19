//
//  HomeViewController.swift
//  WeatherAppMVC
//
//  Created by ramchandra on 16/02/18.
//  Copyright © 2018 ramchandra. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    let weatherItemViewModel = WeatherItemViewModel()

    @IBOutlet weak var tableViewWeather: UITableView!
    @IBOutlet weak var dayView: DayView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewWeather.dataSource = self
        tableViewWeather.delegate = self
        tableViewWeather.tableFooterView = UIView()
        tableViewWeather.rowHeight = UITableViewAutomaticDimension
        tableViewWeather.estimatedRowHeight = 60
        getWeatherData()
    }

    func getWeatherData() {
        weatherItemViewModel.getWeatherData { [weak self] errMessage in
            DispatchQueue.main.async {
                self?.reloadDayView()
                self?.tableViewWeather.reloadData()
                if let errMessage = errMessage {
                    self?.showAlert(title: "Alert", message: errMessage, buttons: ["Ok"], actions: nil)
                }
            }
        }
    }

    func reloadDayView() {
        dayView.labelCity.text = weatherItemViewModel.cityName
        dayView.labelTemp.text = weatherItemViewModel.currentTemp
        dayView.labelDescription.text = weatherItemViewModel.currentWeatherDescription
        let imageUrl = weatherItemViewModel.currentWeatherIconUrl
        dayView.imageWeather.setImage(fromUrl: imageUrl!)
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherItemViewModel.numberOfItems
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell") as? WeatherCell else {
            return UITableViewCell()
        }
        cell.labelTime.text = weatherItemViewModel.dateString(atIndex: indexPath.row)
        cell.labelMaxTemp.text = weatherItemViewModel.maxTemp(atIndex: indexPath.row)
        cell.labelMinTemp.text = weatherItemViewModel.minTemp(atIndex: indexPath.row)
        let imageUrl = weatherItemViewModel.imageUrl(atIndex: indexPath.row)
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
