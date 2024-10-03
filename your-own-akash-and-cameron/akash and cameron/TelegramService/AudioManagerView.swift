//
//  AudioView.swift
//  akash and cameron
//
//  Created by Akash on 4/30/24.
//

import SwiftUI
import TDLibKit

struct AudioManagerView: View {
    @State var audio: Audio
    @State var audioURL: URL?
    
    var body: some View {
        if let audioURL = audioURL {
            Button("Play Audio") {
                AudioPlayerManager.shared.play(url: audioURL)
            }
            .padding()
            
            Button("Stop Audio") {
                AudioPlayerManager.shared.stop()
            }
            .padding()
        } else {
            ProgressView().task {
                audioURL = URL(string: audio.audio.local.path)
            }
        }
    }
}
