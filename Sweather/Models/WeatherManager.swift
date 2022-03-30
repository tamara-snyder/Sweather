//
//  WeatherManager.swift
//  Sweather
//
//  Created by Tamara Snyder on 3/30/22.
//

import Foundation
import CoreLocation

struct WeatherManager {
	// Enter your API key here:
	let weatherURL = "https://api.openweathermap.org/data/2.5/forecast?appid={YOUR_API_KEY_HERE}&units=imperial"
	var delegate: WeatherManagerDelegate?
	
	func fetchWeather(cityName: String) {
		let formattedCityName = formatCityName(cityName: cityName)
		
		let urlString = "\(weatherURL)&q=\(formattedCityName)"
		performRequest(with: urlString)
	}
	
	func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
		let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
		performRequest(with: urlString)
	}
	
	func formatCityName(cityName: String) -> String {
		return cityName.components(separatedBy: " ").joined(separator: "+")
	}
	
	// Networking steps
	func performRequest(with urlString: String) {
		// 1. Create a URL
		if let url = URL(string: urlString) {
			
			// 2. Create a URLSession
			let session = URLSession(configuration: .default)
			
			// 3. Give the session a task
			let task = session.dataTask(with: url) { (data, response, error) in
				if error != nil {
					delegate?.didFailWithError(error: error!)
					return
				}
				
				if let safeData = data {
					if let weather = parseJSON(safeData) {
						delegate?.didUpdateWeather(self, weather: weather)
					}
				}
			}
			
			// 4. Start the task
			task.resume()
		}
	}
	
	func parseJSON(_ weatherData: Data) -> [WeatherModel]? {
		let decoder = JSONDecoder()
		
		do {
			let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
			
			var weatherArray = [WeatherModel]()
			
			for i in 0..<decodedData.list.count {
				let id = decodedData.list[i].weather[0].id
				let name = decodedData.city.name
				let temp = decodedData.list[i].main.temp
				let time = decodedData.list[i].dt
				let lowTemp = decodedData.list[i].main.temp_min
				let highTemp = decodedData.list[i].main.temp_max
				let description = decodedData.list[i].weather[0].description
				let weather = WeatherModel(cityName: name, conditionId: id, temperature: Double(temp), time: time, lowTemp: Double(lowTemp), highTemp: Double(highTemp), conditionDescription: description)
				
				weatherArray.append(weather)
			}
			
			return weatherArray
		} catch {
			delegate?.didFailWithError(error: error)
			return nil
		}
	}
}
