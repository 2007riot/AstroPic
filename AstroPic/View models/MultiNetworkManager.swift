//
//  MultiNetworkManager.swift
//  AstroPic
//
//  Created by Galina Aleksandrova on 13/01/23.
//
import Combine
import Foundation
import SwiftUI


class MultiNetworkManager: ObservableObject {
    
    @Published var infos = [PhotoInfo]()
    private var subscriptions = Set<AnyCancellable>()
    @Published var daysFromToday: Int = 0
    
    init() {
        
        //publisher that omits also errors
//        let times = 0..<10
//        times.publisher
        $daysFromToday
            .map { daysFromToday in
                API.createDate(daysFromToday: daysFromToday)
            }.map { date in
                return API.createURL(for: date)!
                //now to use in our publisher
            }.flatMap { (url) in
                return API.createPublisher(url: url)
            }.scan([]) { (partialValue, newValue) in
                return partialValue + [newValue]
            }
        //to sort infos by date, using tryMap because it works better with funcs that can throw errors
            .tryMap({ (infos) in
                infos.sorted { $0.formattedDate > $1.formattedDate }
            })
            
        //catching errors
            .catch { (error) in
                //so when we catch an error we return an empty array
                Just([PhotoInfo]())
            }.eraseToAnyPublisher()
            .receive(on: RunLoop.main)
            .assign(to: \.infos, on: self) //now we put our information that we fetch into array and can use
            .store(in: &subscriptions)
        getMoreData(for: 20)
    }
    
    //getting more data on scrolling
    func getMoreData(for times: Int) {
        for _ in 0..<times {
            self.daysFromToday += 1
        }
    }
    
    //fetching images
    func fetchImage(for photoInfo: PhotoInfo) {
        //fetchImage from photoInfo.url
        //set image to photoInfo.image
        guard photoInfo.image == nil, let url = photoInfo.hdPicURL else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("fetch image error \(error.localizedDescription)")
            } else if let data = data, let image = UIImage(data: data), let index = self.infos.firstIndex(where: {$0.id == photoInfo.id}) {
                DispatchQueue.main.async {
                    self.infos[index].image = image
                }
                
                
            }
        }
        task.resume()
    }
}
