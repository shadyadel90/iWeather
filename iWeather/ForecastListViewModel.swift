//
//  ForecastListViewModel.swift
//  iWeather
//
//  Created by Shady Adel on 13/12/2023.
//

import CoreLocation
import Foundation
import SwiftUI

class ForecastListViewModel: ObservableObject {
    
    @Published var showError = false
    @Published var errorString = ""
    @Published var isLoading = true
    @Published var forecasts: [ForecastViewModel] = []
    @AppStorage("location") var storageLocation: String = ""
    @Published var location = ""
    @AppStorage("systemUnit") var systemUnit: Int = 0 {
        didSet {
            for i in 0..<forecasts.count {
                forecasts[i].systemUnit = systemUnit
            }
        }
    }
    
    init(){
        location = storageLocation
        getWeatherForecast()
    }
    
    func getWeatherForecast() {
        storageLocation = location
        UIApplication.shared.endEditing()
        if location == "" {
            forecasts = []
        }
        else {
            isLoading = true
            let apiService = ApiServiceCombine.shared
            CLGeocoder().geocodeAddressString(location) { (placemarks, geocodingError) in
                if let geocodingError = geocodingError as? CLError{
                    switch geocodingError.code {
                        
                    case .locationUnknown, .geocodeFoundNoResult, .geocodeFoundPartialResult:
                        self.errorString = "Geocoding error: Location maybe Unknown or not Found Please Try Again"
                    default:
                        self.errorString = "Geocoding error: \(geocodingError.localizedDescription)"
                    }
                    self.isLoading = false
                    self.showError = true
                    return
                }
                
                guard let location = placemarks?.first?.location else {
                    self.isLoading = false
                    self.showError = true
                    self.errorString = "Location not found."
                    print("Location not found.")
                    return
                }
                
                let urlString = "https://api.openweathermap.org/data/2.5/forecast?lat=\(location.coordinate.latitude)&lon=\(location.coordinate.longitude)&exclude=current,minutely,hourly,alerts&appid=c5090874e99fa8571275aa43443cdee9"
                
                apiService.getJSON(urlString: urlString, dateDecodingStrategy: .secondsSince1970) { (result: Result<Forecast, ApiServiceCombine.APIError>) in
                    switch result {
                    case .success(let forecast):
                        DispatchQueue.main.async {
                            self.forecasts = forecast.list.map { ForecastViewModel(forecast: $0, systemUnit: self.systemUnit) }
                        }
                    case .failure(let apiError):
                        self.showError = true
                        self.errorString = "\(apiError)"
                        print(apiError)
                    }
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2 ) {
                self.isLoading = false
            }
            
        }
    }
}
