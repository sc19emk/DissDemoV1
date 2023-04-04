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
    @State var playing = false // is alarm currently playing
    let emergencyString = "999" // for quick dial
    var body: some View {
        NavigationStack {
            
            ZStack{
                Color.black.ignoresSafeArea()
                
                RoundedRectangle(cornerRadius: 0, style: .continuous)
                    .foregroundStyle(.linearGradient(colors: [.red, .pink], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(width: 650, height: 400)
                    .rotationEffect(.degrees(-10))
                    .offset(y: -620)
                
                VStack {
                    
                    Text("Alarm Page").font(.title).bold()
                        .multilineTextAlignment(.center)
                        .offset(y: -160)
                    Spacer()
                    if playing==false {
                        Button("Play Alarm!") {
                            playSound()
                            sendAlertToFriends()
                            self.playing = true // changes button state
                            
                        }.fixedSize()
                        .frame(width: 340, height: 220)
                        .background(.linearGradient(colors: [.pink, .red], startPoint: .topLeading, endPoint: .bottomTrailing))
                        .foregroundColor (.white)
                        .accentColor(.pink)
                        .cornerRadius(10)
                        
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
                        .background(.linearGradient(colors: [.pink, .red], startPoint: .topLeading, endPoint: .bottomTrailing))
                        .foregroundColor (.white)
                        .accentColor(.red)
                        .cornerRadius(20)
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




