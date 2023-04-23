import Foundation
import AVFoundation

class AudioRecorder: NSObject, ObservableObject, AVAudioRecorderDelegate {
    @Published var audioRecorder: AVAudioRecorder?
    var audioSession: AVAudioSession!
    var audioFileURL: URL?

    override init() {
        super.init()
        audioSession = AVAudioSession.sharedInstance()
        setupAudioRecorder()
    }

    func setupAudioRecorder() {
        do {
            // Set up the audio session category, mode, and activation
            try audioSession.setCategory(.record, mode: .default)
            try audioSession.setActive(true)

            let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.m4a")

            let settings = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 12000,
                AVNumberOfChannelsKey: 1,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]

            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder?.delegate = self
            audioRecorder?.record()
            audioFileURL = audioFilename
        } catch {
            // Handle error
            print("Failed to set up audio recorder: \(error)")
        }
    }

    func startRecording() {
        audioRecorder?.record()
    }

    func stopRecording() {
        audioRecorder?.stop()
    }

    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
