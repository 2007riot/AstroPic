//
//  PhotoInfo.swift
//  AstroPic
//
//  Created by Galina Aleksandrova on 12/01/23.
//

import Foundation
import SwiftUI

struct PhotoInfo: Codable, Identifiable {
    var title: String
    var description: String
    var ldPicURL: URL?
    var copyright: String?
    var date: String
    var hdPicURL: URL?
    var image: UIImage? = nil
    let id = UUID()
    
    //to be able to sort date we need to convert them to strings
    var formattedDate: Date {
        let dateFormatter = API.createFormatter()
        return dateFormatter.date(from: self.date) ?? Date()
    }
    
    //when you use the exact same names for json keys
    enum CodingKeys: String, CodingKey {
        case title = "title"
        case description = "explanation"
        case ldPicURL = "url"
        case copyright = "copyright"
        case date = "date"
        case hdPicURL = "hdurl"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decode(String.self, forKey: .title)
        self.description = try container.decode(String.self, forKey: .description)
        self.ldPicURL = try container.decodeIfPresent(URL.self, forKey: .ldPicURL)
        self.copyright = try container.decodeIfPresent(String.self, forKey: .copyright)
        self.date = try container.decode(String.self, forKey: .date)
        self.hdPicURL = try container.decodeIfPresent(URL.self, forKey: .hdPicURL)
    }
    
    //for testing purposes
    init() {
        self.description = ""
        self.title = ""
        self.date = ""
    }
    
    //for a preview
    
    static func createDefault() -> PhotoInfo {
        var photoInfo = PhotoInfo()
        photoInfo.title = "Stardust in Perseus"
        photoInfo.description = "This cosmic expanse of dust, gas, and stars covers some 6 degrees on the sky in the heroic constellation Perseus. At upper left in the gorgeous skyscape is the intriguing young star cluster IC 348 and neighboring Flying Ghost Nebula with clouds of obscuring interstellar dust cataloged as Barnard 3 and 4. At right, another active star forming region NGC 1333 is connected by dark and dusty tendrils on the outskirts of the giant Perseus Molecular Cloud, about 850 light-years away. Other dusty nebulae are scattered around the field of view, along with the faint reddish glow of hydrogen gas. In fact, the cosmic dust tends to hide the newly formed stars and young stellar objects or protostars from prying optical telescopes. Collapsing due to self-gravity, the protostars form from the dense cores embedded in the molecular cloud. At the molecular cloud's estimated distance, this field of view would span over 90 light-years."
        photoInfo.date = "2023-01-12"
        photoInfo.image  = UIImage(named: "previewImage")
    return photoInfo
    }
}
