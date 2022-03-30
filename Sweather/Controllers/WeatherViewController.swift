//
//  ViewController.swift
//  Sweather
//
//  Created by Tamara Snyder on 3/30/22.
//

import UIKit

import UIKit
import CoreLocation

protocol WeatherManagerDelegate {
	func didUpdateWeather(_ weatherManager: WeatherManager, weather: [WeatherModel])
	func didFailWithError(error: Error)
}

class WeatherViewController: UIViewController {

	@IBOutlet weak var conditionImageView: UIImageView!
	@IBOutlet weak var dateLabel: UILabel!
	@IBOutlet weak var temperatureLabel: UILabel!
	@IBOutlet weak var cityLabel: UILabel!
	@IBOutlet weak var searchTextField: UITextField!
	@IBOutlet weak var tableView: UITableView!

	var weatherManager = WeatherManager()
	let locationManager = CLLocationManager()
	var weatherModel: [WeatherModel]?
	
	override func viewDidLoad() {
		super.viewDidLoad()

		searchTextField.delegate = self
		weatherManager.delegate = self
		locationManager.delegate = self
		tableView.dataSource = self
		
		locationManager.requestWhenInUseAuthorization()
		locationManager.requestLocation()
		// For something like a fitness app, you might use
		// locationManager.startUpdatingLocation() to keep track of movement
		
		tableView.register(UINib(nibName: "ForecastCell", bundle: nil),
			forCellReuseIdentifier: "Forecast")
		tableView.backgroundColor = UIColor(white: 1, alpha: 0.6)
	}
	
	@IBAction func updateWeather(_ sender: UIButton) {
		locationManager.requestLocation()
	}
	
}

// MARK: - UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate {
	@IBAction func searchPressed(_ sender: UIButton) {
		searchTextField.endEditing(true)
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		searchTextField.endEditing(true)
		return true
	}
	
	func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
		if textField.text != "" {
			return true
		} else {
			return false
		}
	}
	
	func textFieldDidEndEditing(_ textField: UITextField) {
		// Use search text field text here
		if let city = searchTextField.text {
			weatherManager.fetchWeather(cityName: city)
		}
		searchTextField.text = ""
	}
}

// MARK: - WeatherManagerDelegate

extension WeatherViewController: WeatherManagerDelegate {
	
	func didUpdateWeather(_ weatherManager: WeatherManager, weather: [WeatherModel]) {
		DispatchQueue.main.async {
			self.temperatureLabel.text = weather[0].temperatureString
			self.cityLabel.text = weather[0].cityName
			self.conditionImageView.image = UIImage(systemName: weather[0].conditionName)
			self.dateLabel.text = weather[0].dateFormatted
			
			self.weatherModel = weather
			self.tableView.reloadData()
		}
	}
	
	func didFailWithError(error: Error) {
		print(error)
	}
}

// MARK: - CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate {
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		if let location = locations.last {
			locationManager.stopUpdatingLocation()
			let lat = location.coordinate.latitude
			let lon = location.coordinate.longitude
			weatherManager.fetchWeather(latitude: lat, longitude: lon)
		}
	}
	
	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		print("Failed to find user's location: \(error.localizedDescription)")
	}
}

// MARK: - UITableViewDataSource

extension WeatherViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 40
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Forecast", for: indexPath)
			as! ForecastCell
		
		cell.forecastDay?.text = weatherModel?[indexPath.row].timeFormatted ?? ""
		cell.forecastText?.text = weatherModel?[indexPath.row].conditionDescription
		cell.forecastImage?.image = UIImage(systemName: weatherModel?[indexPath.row].conditionName ?? "cloud.bolt.fill")
		cell.forecastTempRange?.text = "\(weatherModel?[indexPath.row].lowTempString ?? "...")°-\(weatherModel?[indexPath.row].highTempString ?? "...")°"
		return cell
	}
}
