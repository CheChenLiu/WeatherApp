//
//  ForecastWeatherData.swift
//  WeatherApp
//
//  Created by CheChenLiu on 2022/3/1.
//

import Foundation

struct ForecastWeather: Codable {
    var list: [ForecastList]
    let city: ForecastCity
}

struct ForecastList: Codable {
    var dt: Date
    var main: ForecastListMain
    var weather: [ForecastListWeather]
    var sys: ForecastListSys
}

struct ForecastListMain: Codable {
    var temp: Double
    var tempMin: Double
    var tempMax: Double
    var humidity: Double
    
    enum CodingKeys: String, CodingKey {
        case temp
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case humidity
    }
}

struct ForecastListWeather: Codable {
    var main: String
    var description: String
    var icon: String
}

struct ForecastListSys: Codable {
    var pod: String
}

struct ForecastCity: Codable {
    var id: Int
    var name: String
    var timezone: Int
    var sunrise: Date
    var sunset: Date
}



