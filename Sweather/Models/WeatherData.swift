//
//  WeatherData.swift
//  Sweather
//
//  Created by Tamara Snyder on 3/30/22.
//

import Foundation

struct WeatherData: Codable {
	// Property names must match the JSON
	let city: City
	let list: [List]
}

struct City: Codable {
	let name: String
}

struct List: Codable {
	let dt: Int
	let main: Main
	let weather: [Weather]
}

struct Main: Codable {
	let temp: Double
	let temp_min: Double
	let temp_max: Double
}

struct Weather: Codable {
	let id: Int
	let description: String
}
