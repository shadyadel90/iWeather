//
//  Forecast.swift
//  iWeather
//
//  Created by Shady Adel on 12/12/2023.
//

import Foundation

struct Forecast: Codable {
    
    let list: [WeatherInfo]
    
    struct WeatherInfo: Codable {
        let dt: Date
        let main: Main
        let weather: [Weather]
        let clouds: Clouds
        let pop: Double
        
        struct Main: Codable {
            let temp_min: Double
            let temp_max: Double
            let humidity: Int
        }
        
        struct Weather: Codable {
            let id: Int
            let main: String
            let description: String
            let icon: String
            
        }
        
        struct Clouds: Codable {
            let all: Int
        }
    }
    

    
}

