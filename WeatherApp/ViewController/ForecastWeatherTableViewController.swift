//
//  WeatherTableViewController.swift
//  WeatherApp
//
//  Created by CheChenLiu on 2022/1/5.
//

import UIKit

class ForecastWeatherTableViewController: UITableViewController { 
    
    private var forecastWeatherInfo: ForecastWeather?
    private var forecastWeatherRow = [ForecastList]()
    var cityName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchForecastWeatherData(cityName: cityName ?? "")
    }
    
    private func fetchForecastWeatherData(cityName: String) {
        
        let urlString = "https://api.openweathermap.org/data/2.5/forecast?q=\(cityName)&units=Metric&appid=\(ApiKey().apiKey)"
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .secondsSince1970
            
            guard let data = data,
                  let content = String(data: data, encoding: .utf8) else { return }
            
            print("content = \(content)")
            
            do {
                let forecastWeather = try decoder.decode(ForecastWeather.self, from: data)
                print("forecastWeather = \(forecastWeather)")
                self.forecastWeatherInfo = forecastWeather
                DispatchQueue.main.async {
                    self.forecastWeatherRow = self.forecastWeatherInfo?.list ?? []
                    self.tableView.reloadData()
                    print("dataReload")
                }
            } catch {
                print(error)
            }
        }.resume()
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecastWeatherRow.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(ForecastWeatherTableViewCell.self)", for: indexPath) as? ForecastWeatherTableViewCell else {
            print("something error in cell")
            return UITableViewCell() }

        cell.forecastTimeLabel.text = "\(timeFormate(date: forecastWeatherRow[indexPath.row].dt))"
        cell.forecastTempLabel.text = "\(tempFormate(temp: forecastWeatherRow[indexPath.row].main.temp))°C"
        cell.forecastHumidityLabel.text = "💧 \(humidityFormate(humidity: forecastWeatherRow[indexPath.row].main.humidity))%"
        cell.forecastWeatherIconImageView.image = UIImage(named: forecastWeatherRow[indexPath.row].weather[0].icon)
        print(forecastWeatherRow[indexPath.row].weather[0].icon)
        
        updateForecastWeatherCellBackground(cell: cell, indexPath: indexPath.row)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    private func updateForecastWeatherCellBackground(cell: ForecastWeatherTableViewCell, indexPath: Int) {
        
        let suffix = forecastWeatherRow[indexPath].weather[0].icon.suffix(1)
        print("suffix = \(suffix)")
        
        if suffix == "d" {
            cell.backgroundColor = .white
            cell.forecastTimeLabel.textColor = .black
            cell.forecastHumidityLabel.textColor = .black
            cell.forecastTempLabel.textColor = .black
        } else if suffix == "n" {
            cell.backgroundColor = .black
            cell.forecastTimeLabel.textColor = .white
            cell.forecastHumidityLabel.textColor = .white
            cell.forecastTempLabel.textColor = .white
        }
    }
    
    private func timeFormate(date: Date) -> String {
        
        guard let forecastWeatherInfo = forecastWeatherInfo else {
            return "something error in forecastWeatherInfo"
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(secondsFromGMT: forecastWeatherInfo.city.timezone)
        dateFormatter.dateFormat = "MM/dd HH:mm"
        
        return dateFormatter.string(from: date)
    }
    
    private func tempFormate(temp: Double) -> Int {
        let tempInt = Int(temp)
        return tempInt
    }
    
    private func humidityFormate(humidity: Double) -> Int {
        let humidityInt = Int(humidity)
        return humidityInt
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
