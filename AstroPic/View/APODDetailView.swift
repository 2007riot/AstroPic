//
//  APODDetailView.swift
//  AstroPic
//
//  Created by Galina Aleksandrova on 16/01/23.
//

import SwiftUI

struct APODDetailView: View {
    init(photoInfo: PhotoInfo,manager: MultiNetworkManager) {
        print("init detail for \(photoInfo.date)")
        self.photoInfo = photoInfo
        self.manager = manager
    }
    
    @ObservedObject var manager: MultiNetworkManager
    let photoInfo: PhotoInfo
    var body: some View {
        VStack {
            if photoInfo.image != nil {
                
                    Image(uiImage: self.photoInfo.image!)
                        .resizable()
                        .scaledToFit()
                        .overlay (
                NavigationLink(destination: InteractiveImageView(image: photoInfo.image!)) {
                    Image(systemName: "magnifyingglass.circle.fill")
                        .font(.title)
                        .padding()
                        .foregroundColor(.blue)
                }, alignment: .bottomTrailing)
                    .buttonStyle(.plain)
                
            } else {
                LoadingAnimationBox()
                
            }
            ScrollView {
                VStack (alignment: .leading) {
                    Text(photoInfo.title).font(.headline)
                    Text(photoInfo.description)
                }
                .padding()
            }
        }
        .navigationTitle(photoInfo.date)
        .navigationBarTitleDisplayMode(.inline)
        //fetching image only when user taps on navigation link
        .onAppear {
            self.manager.fetchImage(for: self.photoInfo)
        }
    }
}
struct APODDetailView_Previews: PreviewProvider {
    static var previews: some View {
        APODDetailView(photoInfo: PhotoInfo.createDefault(), manager: MultiNetworkManager())
    }
}
