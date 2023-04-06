//
//  AlarmView.swift
//  DissDemoV1
//
//  Created by Emily Kerkhof on 05/02/2023.
//

// TO DO:
// CHANGE TO FULL VOLUME
// Stops when app is closed

import SwiftUI
import Foundation
import AVFoundation // library for playing sound effects
import UIKit
import FirebaseFirestore

var audioPlayer = AVAudioPlayer() // variable for sound effect

struct AlarmView: View {
    @EnvironmentObject var dataManager: DataManager // to alert friends about SOS trigger
    @Environment(\.colorScheme) var colorScheme // changes when in dark mode
    @State var playing = false // is alarm currently playing
    let emergencyString = "999" // for quick dial
    var body: some View {
        NavigationStack {
            ZStack{
                VStack {
                    HStack {
                        Image(systemName: "light.beacon.max")
                            .font(.system(size: 30))
                            .foregroundColor(Color.pink)
                        Text("Alarm")
                            .font(.system(size: 30, design: .monospaced))
                            .bold()
                            .foregroundColor(colorScheme == .dark ? Color.white : Color.black) // change text color based on the color scheme
                    }
                    Spacer()
                    if playing==false {
                        Button("Play Alarm!") {
                            playSound()
                            sendAlertToFriends()
                            self.playing = true // changes button state
                    }.padding(.vertical)
                        .frame(width: 300, height: 200)
                        .background(colorScheme == .dark ? Color.pink.opacity(0.8) : Color.pink.opacity(0.7))
                        .cornerRadius(10)
                        .bold()
                        .foregroundColor(colorScheme == .dark ? Color.white : Color.black) // change text color
                        
                    }
                    else {
                        Button("Stop Alarm") {
                            stopSound()
                            self.playing = false // changes button state
                        }.padding(.vertical)
                            .frame(width: 300, height: 200)
                            .background(colorScheme == .dark ? Color.gray.opacity(0.08) : Color.gray.opacity(0.8) )
                            .cornerRadius(10)
                            .bold()
                            .foregroundColor(colorScheme == .dark ? Color.white : Color.black) // change text color
                    }
                    Spacer()
                    
                    Button(action: {
                        let telephone = "tel://"
                        let formattedString = telephone + emergencyString
                        guard let url = URL(string: formattedString) else { return }
                        UIApplication.shared.open(url)
                        }) {
                            Image(systemName: "phone.arrow.up.right")
                            Text("Quick Dial   ")
                    }.padding(.vertical)
                        .frame(width: 300)
                        .background(colorScheme == .dark ? Color.pink.opacity(0.8) : Color.pink.opacity(0.7))
                        .cornerRadius(10)
                        .bold()
                        .foregroundColor(colorScheme == .dark ? Color.white : Color.black) // change text color
                }
            }
        }
    }
    func playSound() {
        let path = Bundle.main.path(forResource: "alarmSound.mp3", ofType: nil)!
        let url = URL(fileURLWithPath: path)
        do {
            // create your audioPlayer in your parent class as a property
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer.volume = 1.0 // max volume - doeant work
            // change settings to play on silent mode - works :)
            do {
                try AVAudioSession.sharedInstance().setCategory(.playback)
            } catch(let error) {
                print(error.localizedDescription)
            }
            audioPlayer.play() // play the alarm sound effect
            audioPlayer.numberOfLoops = -1 // loop continuouslt
        } catch {
            print("couldn't load the file")
        }
    }
    func stopSound() {
        audioPlayer.stop()
    }
    func sendAlertToFriends() {
            let uidFrom = dataManager.account.id
            let type = 1
            let contents = "Your friend has sounded their SOS. Please check on them"

            for friend in dataManager.friends {
                let uidTo = friend.id

                let ref = Firestore.firestore().collection("notifications")
                let data: [String: Any] = [
                    "uidFrom": uidFrom,
                    "uidTo": uidTo,
                    "type": type,
                    "opened": false,
                    "contents": contents,
                    "timestamp": Timestamp()
                ]

                ref.addDocument(data: data) { error in
                    if let error = error {
                        print("Error sending notification: \(error.localizedDescription)")
                    } else {
                        print("Notification sent to friend: \(uidTo)")
                    }
                }
            }
        }
}

struct AlarmView_Previews: PreviewProvider {
    static var previews: some View {
        AlarmView()
    }
}




