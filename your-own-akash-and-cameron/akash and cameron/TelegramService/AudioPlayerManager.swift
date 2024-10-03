//
//  AudioPlayerManager.swift
//  akash and cameron
//
//  Created by Akash on 4/30/24.
//

import Foundation
import AVKit

class AudioPlayerManager {
    static let shared = AudioPlayerManager()
    
    var player: AVPlayer?
    
    func play(url: URL) {
        player = AVPlayer(url: url)
        player?.play()
    }
    
    func stop() {
        player?.pause()
        player = nil
    }
}
