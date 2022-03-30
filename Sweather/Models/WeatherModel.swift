//
//  WeatherModel.swift
//  Sweather
//
//  Created by Tamara Snyder on 3/30/22.
//

import Foundation

struct WeatherModel {
	let cityName: String
	let conditionId: Int
	let temperature: Double
	let time: Int
	let lowTemp: Double
	let highTemp: Double
	let conditionDescription: String
	
	var dateFormatted: String {
		let date = NSDate(timeIntervalSince1970: TimeInterval(time))
		let formatter = DateFormatter()
		formatter.dateFormat = "EEEE',' MMMM d" // e.g. "Tuesday, March 29"
		return formatter.string(from: date as Date)
	}
	
	var temperatureString: String {
		return String(format: "%.1f", temperature)
	}
	
	var timeFormatted: String {
		let date = NSDate(timeIntervalSince1970: TimeInterval(time))
		let formatter = DateFormatter()
		
		formatter.dateFormat = "EEEE',' h a" // e.g. "Wednesday, 3 PM"
		return formatter.string(from: date as Date)
	}
	
	var lowTempString: String {
		return String(format: "%.1f", lowTemp)
	}
	
	var highTempString: String {
		return String(format: "%.1f", highTemp)
	}
	
	var conditionName: String {
		switch conditionId {
		case 200...202:
			return "cloud.bolt.rain.fill"
		case 210...221:
			return "cloud.bolt.fill"
		case 230...232:
			return "cloud.bolt.rain.fill"
		case 300...321:
			return "cloud.drizzle.fill"
		case 500...501:
			return "cloud.rain.fill"
		case 502...531:
			return "cloud.heavyrain.fill"
		case 600...622:
			return "snowflake"
		case 711:
			return "smoke.fill"
		case 721:
			return "sun.haze.fill"
		case 701...741:
			return "cloud.fog.fill"
		case 731...762:
			return "sun.dust.fill"
		case 771:
			return "wind"
		case 781:
			return "tornado"
		case 800:
			return "sun.max.fill"
		case 801...803:
			return "cloud.sun.fill"
		case 804:
			return "cloud.fill"
		default:
			return "cloud.sun.fill"
		}
	}
}

