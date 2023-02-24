//
//  AlarmView.swift
//  DissDemoV1
//
//  Created by Emily Kerkhof on 05/02/2023.
//

import SwiftUI
import Foundation
import AVFoundation // library for playing sound effects
import UIKit

var audioPlayer = AVAudioPlayer() // variable for sound effect

struct AlarmView: View {
    @State var playing = false // is alarm currently playing
    let emergencyString = "999" // for quick dial
    var body: some View {
        VStack{
            NavigationStack {
                Text("Alarm Page").font(.title).bold()
                    .multilineTextAlignment(.center)
                Spacer()
                if playing==false {
                    Button("Play Alarm!") {
                        playSound()
                        self.playing = true // changes button state
                    }.fixedSize()
                    .frame(width: 340, height: 220)
                    .background(Color.red)
                    .foregroundColor (.white)
                    .accentColor(.pink)
                    .cornerRadius(20)
                    
                }
                else {
                    Button("Stop Alarm") {
                        stopSound()
                        self.playing = false // changes button state
                    }.fixedSize()
                    .frame(width: 340, height: 220)
                    .background(Color.blue)
                    .foregroundColor (.white)
                    .accentColor(.red)
                    .cornerRadius(20)
                }
                Spacer()
                
                Button(action: {
                    let telephone = "tel://"
                    let formattedString = telephone + emergencyString
                    guard let url = URL(string: formattedString) else { return }
                    UIApplication.shared.open(url)
                    }) {
                        Image(systemName: "phone.connection.fill")
                        Text("Quick Dial   ")
                }
                    .fixedSize()
                    .frame(width: 340, height: 100)
                    .background(Color.red)
                    .foregroundColor (.white)
                    .accentColor(.red)
                    .cornerRadius(20)
            }
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




