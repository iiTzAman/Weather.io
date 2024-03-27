//
//  WeatherData.swift
//  Weather.io
//
//  Created by Aman Giri on 2024-03-27.
//

import UIKit

struct WeatherData: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Codable {
    let temp: Double
    let feels_like: Double
    
}

struct Weather: Codable {
    let id: Int
    let description: String
}
