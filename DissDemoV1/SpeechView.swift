//
//  SpeechView.swift
//  DissDemoV1
//
//  Created by Emily Kerkhof on 05/02/2023.
//

import SwiftUI

struct SpeechView: View {
    var body: some View {
        ZStack{
            Color.yellow.ignoresSafeArea()
            VStack{
                Text("Speech Page").font(.title).bold()
                Text("Pre-recorded phrases soundboard with a male voice. OR text to speech if not too anamatronic ...")
                    .multilineTextAlignment(.center)
            }
        }
    }
}

struct SpeechView_Previews: PreviewProvider {
    static var previews: some View {
        SpeechView()
    }
}
