//
//  CountdownView.swift
//  DissDemoV1
//
//  Created by Emily Kerkhof on 05/02/2023.
//

import SwiftUI

struct CountdownView: View {
    var body: some View {
        ZStack{
            Color.blue.ignoresSafeArea()
            VStack{
                Text("Countdown Page").font(.title).bold()
                Text("Set a time for getting home - if not deactivated automatically contact friends / emergency services.")
                    .multilineTextAlignment(.center)
            }
        }
    }
}

struct CountdownView_Previews: PreviewProvider {
    static var previews: some View {
        CountdownView()
    }
}
