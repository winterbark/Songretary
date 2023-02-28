import AudioKit
import Controls
import SoundpipeAudioKit
import SwiftUI
import Foundation

struct TuningForkView: View {
    @State private var isTapped = false
    //@ObservedObject var tuningFork: TuningFork
    @State private var displayNote = "C"
    @State private var displayOctave: Float = 4.0
    @State private var displayFreq: Float = 261.63
    
    var body: some View {
        
        let tuningFork = TuningFork()
        
        VStack {
            // Current note display
            ZStack {
                Circle()
                    .stroke(Color.gray, lineWidth: 8)
                    .frame(width: 350, height: 350)
                // Note info display
                VStack {
//                    Text(tuningFork.getCurrentNoteName())
//                        .font(.system(size: 100))
//                        .fontWeight(.bold)
                    Text(displayNote)
                        .font(.system(size: 100))
                        .fontWeight(.bold)
                    Text(String(format: "%.0f", displayOctave - 1))
                        .font(.system(size: 25))
                    Text(String(displayFreq) + " Hz")
                }
            }.padding(25)
            
//            // **NOTE: Does not work
//            Button(action: {tuningFork.useSharps.toggle()}) {
//                Text("Use Sharps (does not work)")
//            }.padding()
            
            // Octave up/down button
            HStack {
                Button(action: {
                    tuningFork.octaveUp()
                    displayOctave = tuningFork.getOctave()
                }) {
                    Image(systemName: "plus")
                }
                Text("Octave Up")
                
                Button(action: {
                    tuningFork.octaveDown()
                    displayOctave = tuningFork.getOctave()
                }) {
                    Image(systemName: "minus")
                }
                Text("Octave Down")
            }.padding()
            
            // Note buttons
            HStack {
                // Create buttons for each note
                
                // **NOTE: Will not toggle sharps
                ForEach(0..<tuningFork.noteFrequencies.count) { index in
                    Button(action: {
                        tuningFork.tune(tuningFork.noteFrequencies[index])
                        // Change display note
                        displayNote = tuningFork.notesSharp[index]
                        // Change display freq
                        displayFreq = tuningFork.getCurrFreq()
                    }) {
                        Text(tuningFork.getUseSharps() ? tuningFork.notesSharp[index] : tuningFork.notesFlat[index])
                    }
                }
            }
            
            // Toggle button **NOTE: Text toggling not working,
            //   causing oscillator to not start
            Button(action: {
                if tuningFork.isPlaying {
                    tuningFork.stop()
                } else {
                    tuningFork.start()
                }
                //isTapped.toggle()
            }) {
                // Text(isTapped ? "Stop" : "Start")
                Text("Toggle")
                    .frame(width: 100, height: 50)
                    .font(.system(size: 25))
                    .fontWeight(.bold)
            }
        }
    }
}

struct TuningForkView_Preview: PreviewProvider {
    static var previews: some View {
        TuningForkView()
    }
}

public class TuningFork {
    let engine = AudioEngine()
    let player = AudioPlayer()
    // Initialize oscillator at piano middle C (261.63Hz)
    let osc = Oscillator(frequency: 261.63, amplitude: 0.5)
    
    let noteFrequencies: [Float] = [16.35, 17.32, 18.35, 19.45, 20.6, 21.83, 23.12, 24.5, 25.96, 27.5, 29.14, 30.87]
    let notesSharp = ["C", "C♯", "D", "D♯", "E", "F", "F♯", "G", "G♯", "A", "A♯", "B"]
    let notesFlat = ["C", "D♭", "D", "E♭", "E", "F", "G♭", "G", "A♭", "A", "B♭", "B"]
    
    @Published var isPlaying = false
    var octave: Float = 5.0
    var currNoteIndex: Int = 0
    var useSharps: Bool = true
    //@Published var currNoteName: String
    
//    init() {
//        currNoteName = notesSharp[currNoteIndex]
//    }
    
    // Start oscillator and sound engine
    func start() {
        osc.start()
        engine.output = osc
        do {
            try engine.start()
            isPlaying = true
        } catch let err {
            print("#@25 engine did not start\(err.localizedDescription)")
        }
    }
    
    // Stop oscillator and sound engine
    func stop() {
        osc.stop()
        engine.stop()
        isPlaying = false
    }
    
    // Tune frequency
    func tune(_ freq: Float) {
        osc.frequency = (freq * (pow(2, octave)))
        currNoteIndex = noteFrequencies.firstIndex(of: freq) ?? 0
        // currNoteName = notesSharp[currNoteIndex]
    }
    
    // Up one octave
    func octaveUp() {
        octave += 1
        osc.frequency = (osc.frequency * 2)
    }
    
    // Down one octave
    func octaveDown() {
        octave -= 1
        osc.frequency = (osc.frequency / 2)
    }
    
    // Frequency getter
    func getCurrFreq() -> Float {
        return osc.frequency
    }
    
    // Octave getter
    func getOctave() -> Float {
        return octave
    }
    
    func getUseSharps() -> Bool {
        return useSharps
    }
    
    func getCurrentNoteName(useSharps: Bool = true) -> String {
        let noteNames = useSharps ? notesSharp : notesFlat
        let noteNameIndex = currNoteIndex % noteNames.count
        return noteNames[noteNameIndex]
    }
}
