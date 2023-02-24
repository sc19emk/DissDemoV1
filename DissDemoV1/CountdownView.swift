//
//  CountdownView.swift
//  DissDemoV1
//
//  Created by Emily Kerkhof on 05/02/2023.
//

import SwiftUI

struct CountdownView: View {
    var body: some View {
        VStack {
            Text("Countdown").font(.title).bold()
            ProgressView(value: 5, total: 15)
            HStack {
                VStack(alignment: .leading) {
                    Text("Seconds Elapsed")
                        .font(.caption)
                    Label("300", systemImage: "hourglass.bottomhalf.fill")
                }
                Spacer()
                VStack(alignment: .trailing) {
                    Text("Seconds Remaining")
                        .font(.caption)
                    Label("600", systemImage: "hourglass.tophalf.fill")
                }
            }
        }.padding()
    }
}

struct CountdownView_Previews: PreviewProvider {
    static var previews: some View {
        CountdownView()
    }
}
