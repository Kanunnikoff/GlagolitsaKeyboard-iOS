//
//  MainView.swift
//  GlagolitsaKeyboard
//
//  Created by Дмитрiй Канунниковъ on 13.09.2022.
//

import SwiftUI

struct MainView: View {
    
    @State private var text = ""
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                VStack(spacing: 20) {
                    
                    Text("To enable the keyboard, follow the ​following​​ steps:\n• in Device Settings go to General -> Keyboard -> Keyboards -> ​New​ keyboards\n• enable the keyboard named 'Glagolitic'")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.subheadline)
                    
                    Text("The keyboard contains ​all letters of the Glagolitic alphabet.")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.subheadline)
                    
                    Text("Some letters are available by long holding corresponding letters with similar pronunciations.")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.subheadline)
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .overlay(
                    RoundedRectangle(
                        cornerRadius: 15,
                        style: .continuous
                    )
                    .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                )
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: 15,
                        style: .continuous
                    )
                )
                
                TextField("Check Input", text: $text, axis: .vertical)
                    .lineLimit(...5)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.sentences)
                    .font(.body)
#if os(iOS)
                    .padding(10)
                    .overlay(
                        RoundedRectangle(
                            cornerRadius: 10,
                            style: .continuous
                        )
                        .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                    )
#endif
                
                Spacer()
            }
            .padding()
            .navigationTitle("Glagolitic")
        }
    }
}

#if DEBUG
struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
#endif
