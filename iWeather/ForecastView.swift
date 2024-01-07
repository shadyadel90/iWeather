//
//  ContentView.swift
//  iWeather
//
//  Created by Shady Adel on 12/12/2023.
//

import CoreLocation
import SDWebImageSwiftUI
import SwiftUI

struct ForecastView: View {
    
    @StateObject private var ForecastVm = ForecastListViewModel()
    
    var body: some View {
        ZStack {
            
            NavigationView {
                VStack {
                    Picker(selection: $ForecastVm.systemUnit, label: Text("Picker")) {
                        Text("°C").tag(0)
                        Text("°F").tag(1)
                    }
                    .pickerStyle(.segmented)
                    .frame(width: 100)
                    .padding(.vertical)
                    HStack {
                        TextField("Enter Location", text: $ForecastVm.location,
                                  onCommit: ForecastVm.getWeatherForecast
                        )
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .overlay(alignment: .trailing){
                                Button(action: {
                                    ForecastVm.location = ""
                                    ForecastVm.getWeatherForecast()
                                }, label: {
                                    Image(systemName: "xmark.circle")
                                        .foregroundStyle(.gray)
                                })
                                .padding(.horizontal)
                            }
                        Button {
                            ForecastVm.getWeatherForecast()
                        } label: {
                            Image(systemName: "magnifyingglass.circle.fill")
                                .font(.title3)
                        }
                    }
                    List(ForecastVm.forecasts, id: \.day) { day in
                        VStack(alignment: .leading) {
                            Text(day.day)
                                .fontWeight(.bold)
                            HStack(alignment: .top) {
                                WebImage(url: day.weatherIconURL).placeholder(Image(systemName: "arrow.down.circle.dotted"))
                                    .resizable()
                                    .frame(width: 90)
                                    .scaledToFit()
                                
                                VStack(alignment: .leading) {
                                    Text(day.overview)
                                        .font(.title2)
                                    HStack {
                                        Text(day.high)
                                        Text(day.low)
                                    }
                                    HStack {
                                        Text(day.clouds)
                                        Text(day.pop)
                                    }
                                    Text(day.humidity)
                                }
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
                }
                .padding(.horizontal)
                .navigationTitle("iWeather")
                .alert("Whoops!", isPresented: $ForecastVm.showError)
                {}
            message: {
                Text("\(ForecastVm.errorString)\n Please Try Again!")
            }
                
            }
            if ForecastVm.isLoading {
                ZStack {
                    Color(.white)
                        .opacity(0.3)
                        .ignoresSafeArea()
                    ProgressView("Fetching Weather")
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color(.systemBackground))
                        )
                        .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/ )
                }
            }
            
        }
    }
}

#Preview {
    ForecastView()
}
