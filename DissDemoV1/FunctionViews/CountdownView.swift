/// CountdownView.swift
// DissDemoV1
//
// Created by Emily Kerkhof on 05/02/2023.
//

import SwiftUI // for view and other structures
import AVFoundation // to play sound files
import FirebaseFirestore // for storing countdown data

struct CountdownView: View {
    @ObservedObject var dataManager: DataManager // to keep track of the time set
    @StateObject var timerModel: TimerModel
    @Environment(\.colorScheme) var colorScheme // changes when in dark mode
    @State var selection: [String] = [0, 0].map { "\($0)" } // time entered by the user
    @State var data: [(String, [String])] = [            ("Hours", Array(0...12).map { "\($0)" }),            ("Minutes", Array(0...59).map { "\($0)" }),        ]

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect() // connecting to built-in Timer class, using phone's clock
    
    init(dataManager: DataManager) {
        self.dataManager = dataManager
        self._timerModel = StateObject(wrappedValue: TimerModel(dataManager: dataManager))
    }
    
    var body: some View {
        VStack {
            ZStack {
                VStack {
                    if timerModel.running {
                        Text(timerModel.time) //displays current countdown's time set/remaining
                            .font(.system(size:70, weight: .medium, design: .monospaced)) // customizing font
                    } else {
                        VStack {
                            HStack {
                                Image(systemName: "timer.square")
                                    .font(.system(size: 30))
                                    .foregroundColor(Color.orange)
                                Text("Countdown")
                                    .font(.system(size: 30, design: .monospaced))
                                    .bold()
                                    .foregroundColor(colorScheme == .dark ? Color.white : Color.black) // change text color based on the color scheme
                            }
                            Spacer()
                            HStack {
                                Spacer()
                                Text("Hours").bold()
                                Spacer()
                                Text("Minutes").bold()
                                Spacer()
                            }
                            TimePicker(data: data, selection: $selection).frame(height: 300).padding()
                            Text ("") //displays current countdowns's time set/remaining
                                .font(.system(size:1)) // customizing font
                                .alert("Playing SOS Alarm", isPresented: $timerModel.alert) { // alert when countdown ends
                                Button("Stop", role:.cancel) {
                                    timerModel.stopSound() // stops alarm from sounding
                                }
                            }
                        }
                    }
                }
            }
            
            let timeSelected = (Float(selection[0])!)*60.0 + Float(selection[1])!
            
            VStack(spacing: 30) {
                Button("Start") {
                    timerModel.start(minutes: timeSelected) // start countdown button
                }   .disabled(timerModel.running)
                    .padding()
                    .frame(width: 300)
                    .background(Color.orange.opacity(0.6))
                    .cornerRadius(10)
                Button ("Cancel", action: timerModel.cancel) // cancel countdown button
                    .disabled(!timerModel.running)
                    .padding()
                    .frame(width: 300)
                    .background(Color.gray.opacity(0.6))
                    .cornerRadius(10)
            }
            
        }.onReceive(timer) { _ in
            timerModel.countdown()
        } // uses the system timer to keep the timer object correct
    }
}

// creating the timer object
extension CountdownView {
    class TimerModel: ObservableObject {
        var dataManager: DataManager
        init(dataManager: DataManager) {
            self.dataManager = dataManager
        }

        @Published var running = false // is timer running
        @Published var alert = false // is timer showing alert / ended
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
            guard running else {return } // only allowed to run when countdown is active. stops alarm sounding endlessly
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
                sendAlertToFriends(dataManager: dataManager)
                return // ends countdown
            }
            
            // if timer is still running
            self.minutes = Float(minutes) // calculating the number of minutes remaining
            print(duration) // measured in seconds
            
            // if less than an hour remains
            if duration < 3600.0 {
                self.time = String(format: "%d:%02d", minutes, seconds) // display remaining time...
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
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer.play()
                audioPlayer.numberOfLoops = -1
            } catch {
                print("couldn't load the file")
            }
        }
        // stopping the alarm sound
        func stopSound() {
            audioPlayer.stop()
        }
        func secondsToHoursMinutesSeconds(_ seconds: Int) -> (Int, Int, Int) {
            return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
        }
        func sendAlertToFriends(dataManager: DataManager) {
            let uidFrom = dataManager.account.id
            let type = 3
            let contents = "Your friend's countdown has just finished and sounded an alarm. Please check on them."

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
                        ForEach(0..<Int(self.data[column].1.count), id: \.self) { row in
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

struct ContentView: View {
    @StateObject var dataManager = DataManager()
    var body: some View {
        CountdownView(dataManager: dataManager)
    }
}
