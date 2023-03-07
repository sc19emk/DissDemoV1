//
//  SpeechView.swift
//  DissDemoV1
//
//  Created by Emily Kerkhof on 05/02/2023.
// need to refactor!

import SwiftUI
import Foundation
import AVFoundation // library for playing sound effects
import UIKit

struct VoiceBoxView: View {
    @State var select: Int = 0 // selected conversation (none)
    
    
    var body: some View {
        VStack{
            NavigationStack {
                Text("Vocie Box Page").font(.title).bold()
                Text("Pre-recorded phrases soundboard with a male voice")
                    .multilineTextAlignment(.center)
                Spacer()
                NavigationLink {
                    TranscriptView()
                } label: {
                    Text("Dialog 1 - Short Conversation")
                }.simultaneousGesture(TapGesture().onEnded{
                    selectConvo1()
                })
            }
        }
    }
    
    func selectConvo1() {
        playDialog1()
        select=1
        
    }
    
    func playDialog1() {
        let path = Bundle.main.path(forResource: "ShortConvo1.mp3", ofType: nil)!
        let url = URL(fileURLWithPath: path)
        do {
            // create your audioPlayer in your parent class as a property
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer.volume = 1.0 // max volume
            // change settings to play on silent mode
            do {
                try AVAudioSession.sharedInstance().setCategory(.playback)
            } catch(let error) {
                print(error.localizedDescription)
            }
            audioPlayer.play() // play the alarm sound effect
        } catch {
            print("couldn't load the file")
        }
    }
}



struct TranscriptView: View {
    @State var playing = true
    
    var body: some View {
        VStack{
            Text("Dialog 1 Page")
            Group{
                Text("Male: Hello?")
                Text("You: Hey!")
                Text("Male: Hi! How are you? How’s your night been?")
                Text("You: Yeah good thanks, I enjoyed it – I’ve just left now so thought I’d call")
                Text("Male: Ah so are you headed back?")
                Text("You: Yeah I’ve just started walking")
                Text("Male: Great – I’ll come meet you. I won't be long!")
                Text("Female: Perfect – I’ll see you soon!")
                Text("Male: Bye!")
                Text("You: Goodbye")

            }
            Text("Transcript ends")
            Spacer()
            
            if playing==true {
                Button("Stop Dialog!") {
                    stopSound()
                    self.playing = false // changes button state
                }
            }
        }
    }

    func stopSound() {
        audioPlayer.stop()
    }
}

        
        
struct VoiceBoxView_Previews: PreviewProvider {
    static var previews: some View {
        VoiceBoxView()
    }
}
