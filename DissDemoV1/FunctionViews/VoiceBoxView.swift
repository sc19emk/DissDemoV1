//
//  SpeechView.swift
//  DissDemoV1
//
//  Created by Emily Kerkhof on 05/02/2023.
//  Navigation bars stacking ;<

import SwiftUI
import Foundation
import AVFoundation // library for playing sound effects
import UIKit

struct VoiceBoxView: View {
    var body: some View {
        VStack{
            NavigationStack {
                Text("Vocie Box Page").font(.title).bold()
                Text("Pre-recorded phrases soundboard with a male voice")
                    .multilineTextAlignment(.center)
                Spacer()
                NavigationLink {
                    TranscriptView(convoChoice: 1)
                } label: {
                    Text("1: SHORT - BOYFRIEND")
                }.simultaneousGesture(TapGesture().onEnded{
                    playConvo(convoChoice: 1)
                })
                NavigationLink {
                    TranscriptView(convoChoice: 2)
                } label: {
                    Text("2: LONG - BOYFRIEND")
                }.simultaneousGesture(TapGesture().onEnded{
                    playConvo(convoChoice: 2)
                })
                NavigationLink {
                    TranscriptView(convoChoice: 3)
                } label: {
                    Text("3: SHORT - FRIEND")
                }.simultaneousGesture(TapGesture().onEnded{
                    playConvo(convoChoice: 3)
                })
                
                Spacer()
            }
        }
    }
    func playConvo(convoChoice: Int) {
        let pathname = allTranscripts[convoChoice-1].pathname
        let path = Bundle.main.path(forResource: pathname, ofType: nil)!
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
    var convoChoice: Int = 0 // set default to 10
    init(convoChoice: Int) {
            self.convoChoice = convoChoice // initialise by passing convo choice in
    }
    
    var body: some View {
        VStack{
            // minus one as the transcript array is 0 indexed
            // set the summary as the title
            Text(allTranscripts[convoChoice-1].summary)
                .font(.title)
                .bold()
            // show the voice actor demographics
            Text(allTranscripts[convoChoice-1].voiceActor)
                .italic()
                .foregroundColor(.gray)
            Spacer()
            // Loop over conversation and disaply on screen
            ForEach(0...allTranscripts[convoChoice-1].length-1, id: \.self) { line in
                HStack{
                    // seperating the male and female / you lines
                    Text(allTranscripts[convoChoice-1].text[0][line])
                        .foregroundColor(Color.gray)
                    Spacer()
                }
                HStack{
                    Spacer()
                    Text(allTranscripts[convoChoice-1].text[1][line])
                        .foregroundColor(Color.pink)
                        .multilineTextAlignment(.trailing)
                        .bold()
                }
            }
            Spacer()
            // button to pause the conversation audio
            if playing==true {
                Button("Pause Conversation") {
                    audioPlayer.pause()
                    self.playing = false // changes button state
                }
            }
            // button to resume once paused
            else if playing==false {
                Button("Resume Conversation") {
                    audioPlayer.play()
                    self.playing = true // changes button state
                }
            }
        }
    }
}

struct Transcript: Identifiable {
    var id : Int
    var voiceActor : String
    var summary : String
    var text : [[String]]
    var length : Int
    var pathname : String
}

var allTranscripts = [
    Transcript(id: 1, voiceActor: "21 Year Old Male from Liverpool", summary: "Short Conversation with Boyfriend", text:text1, length: 5, pathname: "ShortConvo1.mp3"),
    Transcript(id: 2, voiceActor: "23 Year Old Male from Cambridge", summary: "Long Conversation with Boyfriend", text:text2, length:10, pathname: "ShortConvo1.mp3"),
    Transcript(id: 3, voiceActor: "22 Year Old Male from London", summary: "Short Conversation with Friend", text:text3, length:8, pathname: "ShortConvo1.mp3")
]

// array 1 is male transcript, array 2 is female / your responses
var text1 = [["Hello?","Hi! How are you? How's your night been?","Ah so are you headed back?", "Great – I’ll come to meet you. I won't be long!", "Bye!"],["Hey!", "Yeah good thanks, I enjoyed it – I’ve just left now so thought I’d call","Yeah I’ve just started walking", "Thank you – I’ll see you soon!", "Goodbye!"]]
var text2 = [["Hello?", "Hey, how was your day?", "It was okay, I’ve just been busy with work, and then went to the gym. I’m glad you had fun though! Have you eaten yet?", "Great, me neither – I was waiting for you to get back to order a takeaway. My treat.", "Cool, what food do you want? I was thinking maybe italian", "Okay, perfect. Are you on your way back now then?", "Ah okay, be careful. Where are you now?", "Right - I can come and meet you if you like?", "Okay no problem. I’ll see you soon.", "Goodbye"],["Hey!","It was good thanks – really nice catching up with everyone. How was yours?","No – I was going to have something at home.", "That sounds perfect.", "Yeah let’s do pizza", "Yes, I’m just walking.", "I’m [on ___ street / near ___ landmark]", "[Yes please / No thanks]", "Yes see you soon.", "Bye"]]
var text3 = [["Hello?", "Hey – are you on your way back yet? We’re all waiting for you!", "Yeah of course, so are you on your way?", "Great. So where are you?", "Cool, not too far.", "We can come and meet you if you want?", "Okay no problem. I’ll see you soon.", "Bye!"],["Hey!", "Awh I didn’t know you were waiting!", "Yes yes don’t worry. I’m coming back now.", "I’m on ___ street / Near ___ landmark", "Yeah I’ll be about __ minutes.", "Yes please / No thanks", "Yes see you soon.", "Bye"]]
        
struct VoiceBoxView_Previews: PreviewProvider {
    static var previews: some View {
        VoiceBoxView()
    }
}
