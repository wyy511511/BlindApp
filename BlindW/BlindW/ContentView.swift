////
////  ContentView.swift
////  BlindW
////
////  Created by 511 on 10/13/22.
////
import SwiftUI
import CoreHaptics
import AVKit

struct  ContentView: View {
    @State private var engine: CHHapticEngine? //class
    @State var audioPlayer: AVAudioPlayer!
    


    var  body: some View {
        VStack{
            HStack{
                Text( "complex!" )
                    .padding()
                    .onTapGesture(perform: complexSuccess)
                Text( "simple!" )
                    .padding()
                    .onTapGesture(perform: simpleSuccess)
                
            }
            
            
            
            
            
            
        }

    }


    func simpleSuccess(){
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)

    }

    func prepareHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }

        do {
            engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            print("There was an error creating the engine: \(error.localizedDescription)")
        }
    }

    func complexSuccess(){
        prepareHaptics()
        // guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }

        var events = [CHHapticEvent]()

        // let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)
        // let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 1)

        // let start = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 0)

        // events.append(start)

        for i in stride(from: 0.1, to: 1.0, by: 0.1) {
            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: Float(1 - i))
            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: Float(1 - i))

            let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: i)//i+1

            events.append(event)
        }

        do{
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Failed to play pattern: \(error.localizedDescription).")
        }
        // let pattern = try! CHHapticPattern(events: events, parameters: [])
        // let player = try! engine?.makePlayer(with: pattern)
        // try? player?.start(atTime: 0)
    }



}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

//
//import SwiftUI
//
//struct ContentView: View {
//    var body: some View {
//        VStack {
//            Image(systemName: "globe")
//                .imageScale(.large)
//                .foregroundColor(.accentColor)
//            Text("Hello, world!")
//        }
//        .padding()
//    }
//}
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
