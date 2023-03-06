//
//  CountdownView.swift
//  DissDemoV1
//
//  Created by Emily Kerkhof on 05/02/2023.
//

import SwiftUI
import AVFoundation

struct CountdownView: View {
    @StateObject private var timerModel = TimerModel() // creating an instance of the timer model object
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect() // connecting to built in Timer class
    
    var body: some View {
        VStack {
            
            Spacer()
            Text ("\(timerModel.time)") //displays current countdowns's time set/remaining
                .font(.system(size:100, weight: .medium, design: .monospaced)) // customising font
                .alert("Playing SOS Alarm", isPresented: $timerModel.alert) { // alert when countdown ends
                    Button("Stop", role:.cancel) {
                        timerModel.stopSound() // stops alarm from sounding
                    }
                }
            
            Slider(value: $timerModel.minutes, in: 0...60, step: 5) // creating the slider, in=range, step=interval
                .padding()
                .disabled(timerModel.running) // if timer is running, cannot access slider
                .tint(.black) // need to change for night appearence
            
            HStack(spacing: 50) {
                Button("Start") {
                    timerModel.start(minutes: timerModel.minutes) // start countdown button
                }   .disabled(timerModel.running)
                    .tint(.black)
                    .font(.title2)
                Button ("Cancel", action: timerModel.cancel) // cancel countdown button
                    .tint(.red)
                    .disabled(timerModel.running==false)
                    .font(.title2)
            }
            Spacer()
            
        }.onReceive(timer) { _ in
            timerModel.countdown()
        } // uses the system timer to keep the timer object correct
    }
}

// creating the timer object
extension CountdownView {
    final class TimerModel: ObservableObject {
        @Published var running = false // is timer running
        @Published var alert = false // is timer showing alert / ended
        @Published var time: String = "5:00" // default starting time
        @Published var minutes: Float = 5.0 {
            didSet {
                self.time = "\(Int(minutes)):00" // if time has been set, format like this
            }
        }
        private var startTime = 0
        private var endDate = Date()
        
        // function that starts the countdown, using the time interval set and the current date to calculate the end time
        func start(minutes:Float) {
            self.startTime = Int(minutes)
            self.endDate = Date()
            self.running = true
            self.endDate = Calendar.current.date(byAdding: .minute, value: Int(minutes), to:endDate)!
        }
        
        // function to update the time displayed on the countdown clock
        func countdown() {
            guard running else {return } // only allowed to run when countdown is active
            let currentDate = Date ()
            let duration = endDate.timeIntervalSince1970 - currentDate.timeIntervalSince1970
            let date = Date(timeIntervalSince1970: duration)
            let calendar = Calendar.current
            let minutes = calendar.component(.minute, from: date)
            let seconds = calendar.component(.second, from: date)
            
            // if timer is over!
            if duration <= 0 {
                self.running = false
                self.time = "0:00"
                self.alert = true
                self.playSound() // plays alarm from SOS
                return
            }
            
            self.minutes = Float(minutes) // creating countdown slider
            self.time = String(format: "%d:%02d", minutes, seconds)
        }
        
        // function to stop the current countdown
        func cancel() {
            self.minutes = Float(startTime)
            self.running = false
            self.time = "\(Int(minutes)):00"
        }
        
        // alarm sound for when the countdown ends
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
        // stoping the alarm sound
        func stopSound() {
            audioPlayer.stop()
        }
    }
}


struct CountdownView_Previews: PreviewProvider {
    static var previews: some View {
        CountdownView()
    }
}
