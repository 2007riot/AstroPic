//
//  url helper.swift
//  AstroPic
//
//  Created by Galina Aleksandrova on 12/01/23.
//

import Foundation


extension URL {
    func withQuery(_ query: [String: String]) -> URL? {
        // adds query to URL in correct format
        var components = URLComponents(url: self, resolvingAgainstBaseURL: true)
        components?.queryItems = query.map { URLQueryItem(name: $0.0, value: $0.1)}
        return components?.url
    }
}
