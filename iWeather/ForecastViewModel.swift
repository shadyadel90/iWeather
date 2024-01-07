//
//  ForecastViewModel.swift
//  iWeather
//
//  Created by Shady Adel on 13/12/2023.
//

import Foundation

struct ForecastViewModel {
    
    let forecast: Forecast.WeatherInfo
    var systemUnit: Int
    
    private static var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        return dateFormatter
    }
    
    private static var numberFormatter: NumberFormatter {
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = 0
        return numberFormatter
    }
    
    private static var numberFormatter2: NumberFormatter {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .percent
        return numberFormatter
    }
    
    func convert(_ temp: Double) -> Double {
        let celsius = temp - 273.5
        if systemUnit == 0 {
            return celsius
        } else {
            return celsius * 9 / 5 + 32
        }
        
    }
    
    var day: String {
        return Self.dateFormatter.string(for: forecast.dt)!
        
    }
    
    var overview: String {
        forecast.weather[0].description.capitalized
    }
    
    var high: String {
        return "H: \(Self.numberFormatter.string(for: convert(forecast.main.temp_max)) ?? "0")°"
    }
    
    var low: String {
        return "L: \(Self.numberFormatter.string(for: convert(forecast.main.temp_min)) ?? "0")°"
    }
    
    var pop: String {
        return "💧 \(Self.numberFormatter2.string(for: forecast.pop) ?? "0%")"
    }
    
    var clouds: String {
        return "☁️ \(forecast.clouds.all)%"
    }
    
    var humidity: String {
        return "Humidity: \(forecast.main.humidity)%"
    }
    
    var weatherIconURL: URL {
        let urlString = "https://openweathermap.org/img/wn/\(forecast.weather[0].icon)@2x.png"
        return URL(string: urlString)!
    }
}
