//
//  APODListView.swift
//  AstroPic
//
//  Created by Galina Aleksandrova on 13/01/23.
//

import SwiftUI

struct APODListView: View {
    
    @ObservedObject var manager = MultiNetworkManager()
    var body: some View {
        NavigationView {
        List {
            ForEach(manager.infos) { info in
                NavigationLink(destination: APODDetailView(photoInfo: info, manager: self.manager)) {
                    APODRow(photoInfo: info)
                }
                
                .onAppear {
                    //fetching more when the last row is shown
                    if let index = self.manager.infos.firstIndex(where: { $0.id == info.id}),
                       index == self.manager.infos.count - 1 && self.manager.daysFromToday == self.manager.infos.count - 1 {
                        self.manager.getMoreData(for: 10)
                    }
                }
            }
            
            //            Rectangle()
            //                .fill(Color.gray.opacity(0.2))
            //                .frame(height: 50)
            //                .onAppear {
            //                    print("appearing")
            //                    if self.manager.infos.count > 10 {
            //                        self.manager.getMoreData(for: 5)
            //                    }
            //                }
            ForEach(0..<15) { _ in
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
            }
        }.navigationTitle("Picture of the day")
    }
    }
}

struct APODListView_Previews: PreviewProvider {
    static var previews: some View {
        APODListView()
    }
}
