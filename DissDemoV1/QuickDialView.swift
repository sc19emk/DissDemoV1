//
//  QuickDialView.swift
//  DissDemoV1
//
//  Created by Emily Kerkhof on 05/02/2023.
//

import SwiftUI

struct QuickDialView: View {
    var body: some View {
        ZStack{
            Color.red.ignoresSafeArea()
            VStack{
                Text("Quick Dial Page")
                let numberString = "07984063432"
                let emergencyString = "999"
                
                Button(action: {
                    let telephone = "tel://"
                    let formattedString = telephone + numberString
                    guard let url = URL(string: formattedString) else { return }
                    UIApplication.shared.open(url)
                    }) {
                    Text(numberString)
                }
                Button(action: {
                    let telephone = "tel://"
                    let formattedString = telephone + emergencyString
                    guard let url = URL(string: formattedString) else { return }
                    UIApplication.shared.open(url)
                    }) {
                    Text(emergencyString)
                }
            }
        }
    }
}

struct QuickDialView_Previews: PreviewProvider {
    static var previews: some View {
        QuickDialView()
    }
}
