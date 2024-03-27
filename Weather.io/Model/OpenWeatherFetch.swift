//
//  OpenWeatherFetch.swift
//  Weather.io
//
//  Created by Aman Giri on 2024-03-27.
//

import UIKit
import CoreLocation

protocol OpenWeatherFetchDelegate {
    func didGetWeatherDataDelegate(weatherModelData: WeatherModel)
    func didGetAnError(error: Error)
}

struct OpenWeatherFetch {
    let baseURL = "https://api.openweathermap.org/data/2.5/weather"
    let apiKey = "ec68d64895689e01a77264de940da489"
    let units = "metric"
    
    var delegate: OpenWeatherFetchDelegate!
    
    var rawURL: String {
        baseURL + "?appid=" + apiKey + "&units=" + units
    }
    
    func fetchWeather(with cityName: String){
        let url = "\(rawURL)&q=\(cityName)"
        startFetchWeather(with: url)
    }
        
    func fetchWeather( latitude : CLLocationDegrees, longitude : CLLocationDegrees ){
        let url = "\(rawURL)&lat=\(latitude)&lon=\(longitude)"
        startFetchWeather(with: url)
    }
    
    func startFetchWeather(with urlFinal : String){
        if let url = URL(string: urlFinal){
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { (data, response, error) in
                
                if let error = error {
                    delegate?.didGetAnError(error: error)
                }
                
                if let rawData = data {
                    if let weatherData = parseJSON(rawData){
                        delegate?.didGetWeatherDataDelegate(weatherModelData: weatherData)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ data: Data) -> WeatherModel! {
        let decoder = JSONDecoder()
        do {
            let weatherData = try decoder.decode(WeatherData.self, from: data)
            let city = weatherData.name
            let temp = weatherData.main.temp
            let id = weatherData.weather[0].id
            let desc = (weatherData.weather[0].description).capitalized
            
            let weatherModel = WeatherModel(cityName: city, temperature: temp, weatherIconId: id, description: desc)
            return weatherModel
        }catch {
            delegate.didGetAnError(error: error)
            return nil
        }
    }
    
}
