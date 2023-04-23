import SwiftUI
import AVFoundation
import Alamofire
import NotionSwift

struct ContentView: View {
    @EnvironmentObject var audioRecorder: AudioRecorder
    @EnvironmentObject var whisperNotionManager: WhisperNotionManager
    @State private var isRecording = false

    var body: some View {
        VStack {
            Button(action: {
                if isRecording {
                    audioRecorder.stopRecording()
                    isRecording = false

                    if let audioUrl = audioRecorder.audioFileURL {
                        print(audioUrl)
                        whisperNotionManager.transcribeAudio(audioUrl: audioUrl) { transcript in
                            if let transcript = transcript {
                                whisperNotionManager.addToNotion(text: transcript)
                            }
                        }
                    }
                } else {
                    // Start a new recording session and reset the state
                    audioRecorder.startRecording()
                    isRecording = true
                }
            }) {
                Text(isRecording ? "Push to Notion" : "Record to-do")
                    .font(.title2)
                    .padding()
                    .background(Color.black)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
        }
        .onAppear(perform: {
            audioRecorder.startRecording()
            isRecording = true
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AudioRecorder())
            .environmentObject(WhisperNotionManager())
    }
}
