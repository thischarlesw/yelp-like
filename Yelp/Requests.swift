//
//  Requests.swift
//  Yelp
//
//  Created by Charles Wang on 3/3/20.
//  Copyright © 2020 Charles Wang. All rights reserved.
//

import Foundation

class Requests {
    static let shared = Requests()
    
    let yelp = "https://api.yelp.com/v3/businesses/search"

    func getBusiness(search: String? = "restaurants", _ lat: Double, _ long: Double, _ offset: Int?, _ completion: @escaping (Yelp?) -> Void) {
        guard let url = URL(string: yelp) else { return }

        let searchTerm          = URLQueryItem(name: "term", value: search)
        let latitude            = URLQueryItem(name: "latitude", value: String(lat))
        let longitude           = URLQueryItem(name: "longitude", value: String(long))
        var queries = [searchTerm, latitude, longitude]

        if let offset = offset {
            let offsetQuery = URLQueryItem(name: "offset", value: String(offset))
            queries.append(offsetQuery)
        }


        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        components?.queryItems = queries
        guard let absURL = components?.url?.absoluteURL else { return }

        var request = URLRequest(url: absURL)
        let token = "Bearer itoMaM6DJBtqD54BHSZQY9WdWR5xI_CnpZdxa3SG5i7N0M37VK1HklDDF4ifYh8SI-P2kI_mRj5KRSF4_FhTUAkEw322L8L8RY6bF1UB8jFx3TOR0-wW6Tk0KftNXXYx"
        request.setValue(token, forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            if let response = response {
                let code = (response as! HTTPURLResponse).statusCode
                print(code)
            }
            if let error = error?.localizedDescription {
                print(error)
            }
            let yelp = try? JSONDecoder().decode(Yelp.self, from: data)
            completion(yelp)
        }
        task.resume()
    }
}

class Yelp: Codable {
    let total       : Int?
    let businesses  : [Businesses]?
}
class Businesses: Codable {
    let name        : String?
    let rating      : Double?
    let image_url   : String?
    let id          : String?
}
