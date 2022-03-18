//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by CheChenLiu on 2022/1/5.
//

import UIKit
import CoreLocation

struct ApiKey {
    let apiKey: String = "Your Api Key"
}

class CurrentWeatherViewController: UIViewController, CLLocationManagerDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var localTimeLabel: UILabel!
    @IBOutlet weak var personFeelsLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var dataView: UIView!
    @IBOutlet weak var forecastReportButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    
    private let locationManager = CLLocationManager()
    private var currentLocation: CLLocation?
    private var currentCityName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearBar()
        setupLocation()
        setupUI()
    }
    
    private func setupSearBar() {
        
        searchBar.delegate = self
        searchBar.isHidden = true
        searchBar.placeholder = "Enter City Name"
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
        
        if let searchString = searchBar.text,
           !searchString.isEmpty {
            fetchDataFromCity(cityName: searchString)
            updateFrameWhenSearchButtonClicked()
        }
        searchBar.text = ""
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        updateFrameWhenSearchButtonClicked()
        view.endEditing(true)
    }
    
    @IBAction func clickedSearchButton(_ sender: UIBarButtonItem) {
        searchBar.isHidden = false
        countryLabel.isHidden = true
        cityLabel.isHidden = true
    }
    
    @IBAction func clickedLocationButton(_ sender: UIBarButtonItem) {
        fetchDataWithCoordinate()
        updateFrameWhenSearchButtonClicked()
    }
    
    private func updateFrameWhenSearchButtonClicked() {
        searchBar.isHidden = true
        countryLabel.isHidden = false
        cityLabel.isHidden = false
    }
    
    private func setupLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        if !locations.isEmpty {
            currentLocation = locations.first
            locationManager.stopUpdatingLocation()
            fetchDataWithCoordinate()
        } else {
            print("something error in func locationManager")
        }
    }
    
    private func fetchDataFromCity(cityName: String) {
        
        let key = ApiKey()
        
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(cityName)&appid=\(key.apiKey)&lang=zh-tw&units=metric"
        
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .secondsSince1970
                
                if let data = data,
                   let content = String(data: data, encoding: .utf8) {
                    
                    print("content = \(content)")
                    
                    do {
                        let currentWeather = try decoder.decode(CurrentWeather.self, from: data)
                        print("currentWeather = \(currentWeather)")
                        self.updateFrame(currentInfo: currentWeather)
                    } catch  {
                        print(error)
                    }
                }
            }.resume()
        }
    }
    
    private func fetchDataWithCoordinate() {
        
        guard let currentLocation = currentLocation else { return }
        
        let lat = currentLocation.coordinate.latitude
        let lon = currentLocation.coordinate.longitude
        
        print("lat = \(lat),lon = \(lon)")
        
        let key = ApiKey()
        
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(key.apiKey)&lang=zh-tw&units=metric"
        
        if let url = URL(string: urlString) {
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .secondsSince1970
                
                if let data = data,
                   let content = String(data: data, encoding: .utf8) {

                    print("content = \(content)")
                    
                    do {
                        let currentWeather = try decoder.decode(CurrentWeather.self, from: data)
                        print("currentWeather = \(currentWeather)")
                        self.updateFrame(currentInfo: currentWeather)
                    } catch  {
                        print(error)
                    }
                }
            }.resume()
        }
    }
    
    private func updateFrame(currentInfo: CurrentWeather) {
        
        let suffix = currentInfo.weather.first?.icon.suffix(1)
        
        DispatchQueue.main.async {
            self.countryLabel.text = currentInfo.sys.country
            self.cityLabel.text = currentInfo.name
            self.temperatureLabel.text = "\(currentInfo.main.temp) °C"
            self.weatherLabel.text = "\(currentInfo.weather.first?.main ?? "")"
            self.weatherDescriptionLabel.text = "\(currentInfo.weather.first?.description ?? "")"
            self.dateLabel.text = self.dateFormatter(date: currentInfo.dt, currentInfo: currentInfo)
            self.localTimeLabel.text = self.timeFormatter(time: currentInfo.dt, currentInfo: currentInfo)
            self.personFeelsLabel.text = "\(currentInfo.main.personFeels) °C"
            self.windSpeedLabel.text = "\(currentInfo.wind.speed) m/s"
            self.humidityLabel.text = "\(currentInfo.main.humidity ?? 0) %"
            
            if suffix == "d" {
                self.setupMorningGradientBackground()
            } else {
                self.setupNightGradientBackground()
            }
        }
    }
    
    private func dateFormatter(date: Date?, currentInfo: CurrentWeather) -> String {
        
        guard let date = date else {
            return "date error"
        }
        
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        
        let timeZone = currentInfo.timezone
        
        formatter.timeZone = TimeZone(secondsFromGMT: timeZone)

        return formatter.string(from: date)
    }
    
    private func timeFormatter(time: Date?, currentInfo: CurrentWeather) -> String {
        
        guard let time = time else {
            return "time error"
        }
        
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        
        let timeZone = currentInfo.timezone
        
        formatter.timeZone = TimeZone(secondsFromGMT: timeZone)

        return formatter.string(from: time)
    }
    
    private func setupMorningGradientBackground() {
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [
            CGColor(srgbRed: 1, green: 127/255, blue: 80/255, alpha: 1),
            CGColor(srgbRed: 0.4, green: 0.1, blue: 0.1, alpha: 1)
        ]
        
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func setupNightGradientBackground() {
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [
            CGColor(srgbRed: 0.5, green: 0.5, blue: 0.6, alpha: 1),
            CGColor(srgbRed: 0, green: 0, blue: 139/255, alpha: 1)
        ]
        
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func setupUI() {
        dataView.layer.cornerRadius = 20
        dataView.alpha = 0.6
        dataView.layer.borderWidth = 1
        forecastReportButton.layer.cornerRadius = 20
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let controller = segue.destination as? ForecastWeatherTableViewController else { return }
        
        controller.cityName = self.cityLabel.text
    }
}
