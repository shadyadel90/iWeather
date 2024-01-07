//
//  ApiService.swift
//  iWeather
//
//  Created by Shady Adel on 12/12/2023.
//

import Foundation

public class APIService {
    
    // MARK: - Singleton Instance
    public static let shared = APIService()
    
    // MARK: - Custom API Errors
    public enum APIError: Error {
        case error(_ errorString: String)
    }
    
    // MARK: - Fetch JSON Data
    public func getJSON<T: Decodable>(urlString: String,
                                      dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate,
                                      keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys,
                                      completion: @escaping (Result<T,APIError>) -> Void) {
        
        // Validate URL
        guard let url = URL(string: urlString) else {
            completion(.failure(.error(NSLocalizedString("Error: Invalid URL", comment: ""))))
            return
        }
        
        // Create URLRequest with the provided URL
        let request = URLRequest(url: url)
        
        // Perform data task using URLSession
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                // Handle networking error
                completion(.failure(.error("Error: \(error.localizedDescription)")))
                return
            }
            
            guard let data = data else {
                // Handle missing data error
                completion(.failure(.error(NSLocalizedString("Error: Data is corrupt.", comment: ""))))
                return
            }
            
            // Create JSONDecoder and set decoding strategies
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = dateDecodingStrategy
            decoder.keyDecodingStrategy = keyDecodingStrategy
            
            do {
                // Attempt to decode JSON data
                let decodedData = try decoder.decode(T.self, from: data)
                completion(.success(decodedData))
                return
            } catch let decodingError {
                // Handle decoding error
                completion(.failure(APIError.error("Error: \(decodingError.localizedDescription)")))
                return
            }
            
        }.resume() // Start the data task
    }
}
