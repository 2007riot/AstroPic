//
//  PicOfTodayView.swift
//  AstroPic
//
//  Created by Galina Aleksandrova on 12/01/23.
//

import SwiftUI

struct PicOfTodayView: View {
    
    @ObservedObject var manager = NetworkManager()
    @State private var showSwitchDate: Bool = false
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            
            Button {
                self.showSwitchDate.toggle()
            } label: {
                Image (systemName: "calendar")
                Text("switch date")
            }
            .padding(.trailing)
            .frame(maxWidth: .infinity, alignment: .trailing)
            .popover(isPresented: $showSwitchDate) {
                SelectDateView(manager: manager)
            }
            if manager.image != nil {
                    Image(uiImage: self.manager.image!)
                        .resizable()
                        .scaledToFit()
                
                    
            } else {
                LoadingAnimationBox()
                    
            }
            ScrollView {
                VStack (alignment: .leading) {
                    Text(manager.photoInfo.date).font(.title)
                    Text(manager.photoInfo.title).font(.headline)
                    Text(manager.photoInfo.description)
                }
                .padding()
            }
            
        }
    }
}

struct PicOfTodayView_Previews: PreviewProvider {
    static var previews: some View {
        let view = PicOfTodayView()
        view.manager.photoInfo = PhotoInfo.createDefault()
        view.manager.image = UIImage(named: "previewImage")
        return view
    }
}
