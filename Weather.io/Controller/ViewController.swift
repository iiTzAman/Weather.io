//
//  ViewController.swift
//  Weather.io
//
//  Created by Aman Giri on 2024-03-26.
//

import UIKit
import CoreLocation

class ViewController: UIViewController{
    
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var weatherIconImageView: UIImageView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    var weatherFetch = OpenWeatherFetch()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        searchTextField.delegate = self
        weatherFetch.delegate = self
    }
    
    @IBAction func locationButtonPressed(_ sender: Any) {
        locationManager.requestLocation()
    }
    
    
}

//MARK: - UITextFieldDelegate

extension ViewController: UITextFieldDelegate {
    @IBAction func searchButtonPressed(_ sender: UITextField) {
        searchTextField.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if searchTextField.text != "" {
            return true
        }else{
            searchTextField.placeholder = "Enter something here!!"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let textFieldInput = textField.text {
            weatherFetch.fetchWeather(with: textFieldInput)
            textField.text = ""
        }
    }
}

//MARK: - OpenWeatherFetchDelegate

extension ViewController: OpenWeatherFetchDelegate {
    func didGetAnError(error: any Error) {
        print(error)
    }
    
    func didGetWeatherDataDelegate(weatherModelData: WeatherModel) {
        DispatchQueue.main.async {
            self.cityNameLabel.text = weatherModelData.cityName
            self.temperatureLabel.text = String(Int(weatherModelData.temperature))
            self.weatherDescriptionLabel.text = weatherModelData.description
            self.weatherIconImageView.image = UIImage(systemName:weatherModelData.weatherIcon)
        }
    }
}


extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let currentLocation = locations.last {
            let lat = currentLocation.coordinate.latitude
            let lon = currentLocation.coordinate.longitude
            weatherFetch.fetchWeather(latitude: lat, longitude:lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print(error)
    }
}
