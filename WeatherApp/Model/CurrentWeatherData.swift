//
//  CurrentWeatherData.swift
//  WeatherApp
//
//  Created by CheChenLiu on 2022/1/5.
//

import Foundation

struct CurrentWeather: Codable {
    var coord: Coordinate
    var weather: [WeatherNow]
    var main: CurrentMain
    var wind: CurrentWind
    var dt: Date
    var sys: CurrentSys
    var name: String
    var timezone: Int
}

struct Coordinate: Codable {
    var lon: Double
    var lat: Double
}

struct WeatherNow: Codable {
    var main: String
    var description: String
    var icon: String
}

struct CurrentMain: Codable {
    var temp: Double
    var personFeels: Double
    var humidity: Int?
    
    enum CodingKeys: String, CodingKey {
        case temp
        case personFeels = "feels_like"
        case humidity
    }
}

struct CurrentWind: Codable {
    var speed: Double
}

struct CurrentSys: Codable {
    var country: String
}
