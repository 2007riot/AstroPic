//
//  NetworkManager.swift
//  AstroPic
//
//  Created by Galina Aleksandrova on 12/01/23.
//

import Foundation
import Combine
import SwiftUI

class NetworkManager: ObservableObject {
    
    @Published var date = Date()
    @Published var photoInfo = PhotoInfo()
    @Published var image: UIImage? = nil
    private var subscriptions = Set<AnyCancellable>()
    
    
    init() {
        
        //when my date changes i assifn oicture to nil
        $date.removeDuplicates()
            .sink { value in
                self.image = nil
            }.store(in: &subscriptions)
        
        
        //to subscribe any changes of my date and fetch a new photoinfo
        
        $date.removeDuplicates()
            .map {
                API.createURL(for: $0)//now i have an url
            }.flatMap { (url) in//creating fetch request
                API.createPublisher(url: url!)
            }
        //in order not to freeze an app we run fetching data on the main loop
            .receive(on: RunLoop.main)
            .assign(to: \.photoInfo, on: self)
            .store(in: &subscriptions)
     
            
        //fetch images and place in my image property only if i have updated photo info(if i have an url)
        $photoInfo.filter { $0.ldPicURL != nil }
            .map { photoInfo -> URL in
                return photoInfo.ldPicURL!
            }.flatMap { (url) in
                URLSession.shared.dataTaskPublisher(for: url)
                    .map(\.data)
                    .catch( { error in
                        return Just(Data())
                    })
            }
            .map { (out) -> UIImage? in
                UIImage(data: out)
            }
            .receive(on: RunLoop.main)
            .assign(to: \.image, on: self)
            .store(in: &subscriptions)
//            .sink { (completion) in
//                switch completion {
//                    case .finished:
//                        print("fetch complete finished")
//                    case .failure(let failure):
//                        print("fetch complete with failure: \(failure.localizedDescription)")
//                }
//            } receiveValue: { (data, response) in
//                if let description = String(data: data, encoding: .utf8) {
//                    print("fetched new data \(description)")
//                }
//            }.store(in: &subscriptions)

    }
    
    }
