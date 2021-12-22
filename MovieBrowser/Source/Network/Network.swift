//
//  Network.swift
//  SampleApp
//
//  Created by Struzinski, Mark - Mark on 9/17/20.
//  Copyright © 2020 Lowe's Home Improvement. All rights reserved.
//

import UIKit

struct EndPoints {
    static let baseURL = "https://api.themoviedb.org/3/"
    static let search = "search/movie"
    static let posterPath = "https://image.tmdb.org/t/p/w500/"
}

struct Network {
    
    static let apiKey = "5885c445eab51c7004916b9c0313e2d3"
    
    func getMovies(request: MovieSearchRequest, callback: @escaping (Result<SearchResult, MovieError>) -> Void) {
        
        if let url = URL(string: EndPoints.baseURL + EndPoints.search) {
            
            var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
            components?.queryItems = request.convertToURLQueryItems()
            URLSession.shared.dataTask(with: components!.url!) { data, response, error in
                    if let error = error {
                        callback(.failure(.transportError(error)))
                        return
                    }
                    
                    if let response = response as? HTTPURLResponse, !(200...299).contains(response.statusCode) {
                        callback(.failure(.serverError(statusCode: response.statusCode)))
                        return
                    }
                    
                    guard let data = data else {
                        callback(.failure(.noData))
                        return
                    }
                    
                    do {
                        let searchResult = try JSONDecoder().decode(SearchResult.self, from: data)
                        callback(.success(searchResult))
                    } catch let error {
                        callback(.failure(.decodingError(error)))
                    }
                }.resume()
        }
    }
}

extension Network {
    enum MovieError: Error {
        case transportError(Error)
        case serverError(statusCode: Int)
        case noData
        case decodingError(Error)
    }
}

struct MovieSearchRequest: Encodable {
    let api_key = Network.apiKey
    let query: String
}

extension Encodable {
    func convertToURLQueryItems() -> [URLQueryItem]?
    {
        do {
            let encoder = try JSONEncoder().encode(self)
            let requestDictionary = (try? JSONSerialization.jsonObject(with: encoder, options: .allowFragments)).flatMap{$0 as? [String: Any?]}
            
            if(requestDictionary != nil)
            {
                var queryItems: [URLQueryItem] = []
                
                requestDictionary?.forEach({ (key, value) in
                    
                    if(value != nil)
                    {
                        let strValue = value as? String
                        if(strValue != nil && strValue?.count != 0)
                        {
                            queryItems.append(URLQueryItem(name: key, value: strValue))
                        }
                    }
                })
                return queryItems
            }
        } catch let error {
            debugPrint(error)
        }
        return nil
    }
}


