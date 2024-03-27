//
//  WeatherModel.swift
//  Weather.io
//
//  Created by Aman Giri on 2024-03-27.
//

import UIKit

struct WeatherModel {
    let cityName: String
    let temperature: Double
    let weatherIconId: Int
    let description: String
    
    var weatherIcon: String {
        switch weatherIconId {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud.bolt"
        default:
            return "cloud"
        }
    }
    
}
