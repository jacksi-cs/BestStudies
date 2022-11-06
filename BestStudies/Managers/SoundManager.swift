// Project: SoundManager.swift
// EID: Jac23662
// Course: CS371L


import Foundation
import SwiftUI
import AVKit

class SoundManager {
    
    static let shared = SoundManager()
    
    var player: AVAudioPlayer?
    
    enum SoundOption : String {
        case chillButton
        case buttonNoise
    }
    
    func playButtonSound(sound: SoundOption) {
        let soundIsOn = UserDefaults.standard.bool(forKey: "soundOn")
        if(!soundIsOn) {
            return
        }
        
        guard let url = Bundle.main.url(forResource: sound.rawValue, withExtension: ".mp3") else { return }
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.volume = UserDefaults.standard.float(forKey: "soundVolume")
            player?.play()
        } catch let error {
            print("Error Playing Sound. \(error.localizedDescription)")
        }
    }
}
