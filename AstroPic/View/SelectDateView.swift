//
//  SelectDateView.swift
//  AstroPic
//
//  Created by Galina Aleksandrova on 12/01/23.
//

import SwiftUI

struct SelectDateView: View {
    @State private var date = Date()
    @ObservedObject var manager: NetworkManager
    @Environment(\.presentationMode) var presentation
    var body: some View {
        VStack {
            Text("select a day").font(.headline)
            
            DatePicker(selection: $date, in: ...Date(), displayedComponents: .date) {
                Text("select a date")
            }
            .labelsHidden()
            .datePickerStyle(.wheel)
            
            Button {
                self.manager.date = self.date
                self.presentation.wrappedValue.dismiss()
            } label: {
                Text("Done")
            }
        }
    }
}

struct SelectDateView_Previews: PreviewProvider {
    static var previews: some View {
        SelectDateView(manager: NetworkManager())
    }
}
