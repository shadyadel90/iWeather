//
//  ContentView.swift
//  iWeather
//
//  Created by Shady Adel on 12/12/2023.
//

import CoreLocation
import SwiftUI

struct ContentView: View {
    @State private var location: String = ""
    @State private var Forecast: Forecast? = nil
    let dateFormatter = DateFormatter()
    init(){
        //dateFormatter.dateFormat = "E, MMM, d"
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .short
    }
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    TextField("Enter Location", text: $location)
                        .textFieldStyle(.roundedBorder)
                    Button(action:{
                        getWeatherForecast(for: location)
                    },
                           label: {
                        Image(systemName: "magnifyingglass.circle.fill")
                            .font(.title2)
                    })
                }
                if let forecast = Forecast {
                    List(forecast.list, id: \.dt) { day in
                        VStack (alignment: .leading){
                            Text("\(dateFormatter.string(from: day.dt))")
                            HStack {
                                Image(systemName: "cloud.fill")
                                    .frame(width: 75, height: 75)
                                    .font(.title)
                                VStack(alignment: .leading) {
                                    Text(day.weather[0].description.capitalized)
                                    HStack {
                                        Text("Min: \(day.main.temp_min, specifier: "%.0f")" )
                                        Text("High: \(day.main.temp_max,specifier: "%.0f")")
                                    }
                                    HStack {
                                        Text("Humidty: \(day.main.humidity)%")
                                        Text("Clouds: \(day.clouds.all)%")
                                    }
                                }
                            }
                        }
                        
                    }
                    .listStyle(PlainListStyle())
                }
                else { Spacer() }
                
            }
            .padding()
            .navigationTitle("iWeather")
        }
        
    }
    func getWeatherForecast(for location: String) {
        let apiService = APIService.shared
        
        CLGeocoder().geocodeAddressString(location) { (placemarks, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            if let lat = placemarks?.first?.location?.coordinate.latitude,
               let lon = placemarks?.first?.location?.coordinate.longitude {
                apiService.getJSON(urlString: "https://api.openweathermap.org/data/2.5/forecast?lat=\(lat)&lon=\(lon)&exclude=current,minutely,hourly,alerts&appid=c5090874e99fa8571275aa43443cdee9",
                                   dateDecodingStrategy: .secondsSince1970) { (result: Result<Forecast,APIService.APIError>) in
                    switch result {
                    case .success(let forecast):
                        Forecast = forecast
                        //                        for day in forecast.list {
                        //                            print(dateFormatter.string(from: day.dt))
                        //                            print("   Max: ", day.main.temp_max)
                        //                            print("   Min: ", day.main.temp_min)
                        //                            print("   Humidity: ", day.main.humidity)
                        //                            print("   Description: ",day.weather[0].description)
                        //                            print("   Clouds: ", day.clouds)
                        //                            print("   pop: ", day.pop)
                        //                            print("   IconURL: ", day.weather[0].weatherIconURL)
                        //                        }
                    case .failure(let apiError):
                        switch apiError {
                        case .error(let errorString):
                            print(errorString)
                        }
                    }
                }
            }
        }
        
    }
}

#Preview {
    ContentView()
}
