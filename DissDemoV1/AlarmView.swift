//
//  AlarmView.swift
//  DissDemoV1
//
//  Created by Emily Kerkhof on 05/02/2023.
//

import SwiftUI
import AVFoundation


struct AlarmView: View {
    var body: some View {
        VStack{
            Text("Alarm Page").font(.title).bold()
            Text("Loud SOS alarm - to attract attention. - When pressed could record location- send an alert to friends.- **After 10 seconds calls 999?**")
                .multilineTextAlignment(.center)
        }
    }
}

struct AlarmView_Previews: PreviewProvider {
    static var previews: some View {
        AlarmView()
    }
}
