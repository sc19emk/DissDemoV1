//
//  AlarmView.swift
//  DissDemoV1
//
//  Created by Emily Kerkhof on 05/02/2023.
//

import SwiftUI
import Foundation
import AVFoundation // library for playing sound effects

var audioPlayer = AVAudioPlayer() // variable for sound effect
var playing = false

struct AlarmView: View {
    var body: some View {
        VStack{
            Text("Alarm Page").font(.title).bold()
            //Text("Loud SOS alarm - to attract attention. - When pressed could record location- send an alert to friends.- **After 10 seconds calls 999?**")
                .multilineTextAlignment(.center)

            Button("Alarm!") {
                playSound()
            }
                .controlSize(.large)
                .buttonStyle(.borderedProminent)
                .accentColor(.red)
            
            Button("stop alarm") {
                stopSound()
            }
                .controlSize(.large)
                .buttonStyle(.borderedProminent)
                .accentColor(.blue)
        }
    }
    func playSound() {
        let path = Bundle.main.path(forResource: "alarmSound.mp3", ofType: nil)!
        let url = URL(fileURLWithPath: path)
        do {
            // create your audioPlayer in your parent class as a property
            // audioPlayer.numberOfLoops = -1 isnt working...?
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer.play()
            audioPlayer.numberOfLoops = -1
        } catch {
            print("couldn't load the file")
        }
    }
    func stopSound() {
        audioPlayer.stop()
    }
}

struct AlarmView_Previews: PreviewProvider {
    static var previews: some View {
        AlarmView()
    }
}
