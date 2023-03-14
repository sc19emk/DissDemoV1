//
//  CountdownView.swift
//  DissDemoV1
//
//  Created by Emily Kerkhof on 05/02/2023.
//

import SwiftUI // for view and other structures
import AVFoundation // to play sound files


struct CountdownView: View {
    @StateObject var timerModel = TimerModel() // creating an instance of the timer model object
    @State var currentTime = Date.now
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect() // connecting to built in Timer class, using phones clock
    let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateStyle = .long
            return formatter
    }()
    // test
    @State var data: [(String, [String])] = [
            ("Hours", Array(0...12).map { "\($0)" }),
            ("Minutes", Array(0...59).map { "\($0)" }),
        ]
    
    @State var selection: [String] = [0, 0].map { "\($0)" }
    var maxValue :Float = 60.0 // CURRENTLY UNABLE TO CHANGE BAR LENGTH AFTER DECLERATION... WORK ON?

    
    var body: some View {
        VStack {
            //Spacer()
            ZStack {
                if timerModel.running == true{
                    VStack {
                        Text ("\(timerModel.time)") //displays current countdowns's time set/remaining
                            .font(.system(size:70, weight: .medium, design: .monospaced)) // customising font
                        // Slider currently disabled as cannot update to max time value correctly
//                        Slider(value: $timerModel.minutes, in: 0...maxValue) // creating the slider, in=range, step=interval
//                            .padding()
//                            .disabled(timerModel.running) // if timer is running, cannot access slider
//                            .tint(.red) // need to change for night appearence
                        
                    }
                }
                else{
                    VStack {
                        HStack {
                            Spacer()
                            Text("Hours").bold()
                            Spacer()
                            Text("Minutes").bold()
                            Spacer()
                        }
                        TimePicker(data: data, selection: $selection).frame(height: 300).padding()
                        Text ("") //displays current countdowns's time set/remaining
                            .font(.system(size:1)) // customising font
                            .alert("Playing SOS Alarm", isPresented: $timerModel.alert) { // alert when countdown ends
                            Button("Stop", role:.cancel) {
                                timerModel.stopSound() // stops alarm from sounding
                            }
                        }
                    }
                }
            }
            
            let timeSelected = (Float(selection[0])!)*60.0 + Float(selection[1])!
            
            HStack(spacing: 50) {
                Button("Start") {
                    timerModel.start(minutes: timeSelected) // start countdown button
                }   .disabled(timerModel.running)
                    .tint(.black)
                    .font(.title2)
                Button ("Cancel", action: timerModel.cancel) // cancel countdown button
                    .tint(.red)
                    .disabled(timerModel.running==false)
                    .font(.title2)
            }
            
        }.onReceive(timer) { _ in
            timerModel.countdown()
        } // uses the system timer to keep the timer object correct
    }
    
    
}


// creating the timer object
extension CountdownView {
    
    class TimerModel: ObservableObject {
        var running = false // is timer running
        var alert = false // is timer showing alert / ended
        var startTime = 0
        var date = Date()
        @Published var time: String = "0:15:00" // default starting time
        @Published var minutes: Float = 15.0 {
            didSet {
                self.time = "\(Int(minutes)):00" // if time has been set, format like this
            }
        }
        // function to run the countdown and update time remaining
        
        func countdown() {
            guard running
            else {return } // only allowed to run when countdown is active. stops alarm sounding endlessly
            let currentDate = Date ()
            let duration = date.timeIntervalSince1970 - currentDate.timeIntervalSince1970
            let date = Date(timeIntervalSince1970: duration)
            let calendar = Calendar.current
            let minutes = calendar.component(.minute, from: date)
            let seconds = calendar.component(.second, from: date)
            
            // if timer is over!
            if duration <= 0 {
                self.running = false // stop running
                self.time = "0:00" // set to 0 time remaining
                self.alert = true // show alert
                self.playSound() // plays alarm from SOS
                return // ends countdown
            }
            
            // if timer is still running
            self.minutes = Float(minutes) // calculating the number of minutes remaining
            print(duration) // measured in seconds
            
            // if less than an hour remains
            if duration < 3600.0 {
                //print(seconds)
                self.time = String(format: "%d:%02d", minutes, seconds) // display remaining time...
                // below not formatting correctly
//                if seconds < 10 {
//                    print("less than 10")
//                    self.time = String(format: "%d:0%02d", minutes, seconds) // display remaining time...
//                }
//                else {
//                    print("more than 10")
//                    self.time = String(format: "%d:%02d", minutes, seconds) // add a 0 to seconds display
//                }
                
            }
            // if more than an hour remains
            else {
                let (h, m, s) = secondsToHoursMinutesSeconds(Int(duration))
                if Int(m) < 10 {
                    self.time = String("\(h):0\(m):\(s)") // adjust to add a 0 in front of minutes
                }
                else {
                    self.time = String("\(h):\(m):\(s)") // adjust to show full time remaining
                }
            }
        }
        
        
        // function that starts the countdown, using the time interval set and the current date to calculate the end time
        func start(minutes:Float) {
            self.startTime = Int(minutes)
            self.date = Date()
            self.running = true
            self.date = Calendar.current.date(byAdding: .minute, value: Int(minutes), to:date)!
        }
        
        // function to cancel the current countdown
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
        func secondsToHoursMinutesSeconds(_ seconds: Int) -> (Int, Int, Int) {
            return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
        }
    }
}

struct TimePicker: View  {
    typealias Label = String
    typealias Entry = String
    let data: [ (String, [String]) ]
    @Binding var selection: [Entry]

    var body: some View {
        GeometryReader { geometry in
            HStack {
                ForEach(0..<2) { column in
                    Picker(self.data[column].0, selection: self.$selection[column]) {
                        ForEach(0..<Int(self.data[column].1.count)) { row in
                            Text(verbatim: self.data[column].1[row])
                            .tag(self.data[column].1[row])
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .clipped()
                }
            }
        }
    }
}



struct CountdownView_Previews: PreviewProvider {
    static var previews: some View {
        CountdownView()
    }
}
