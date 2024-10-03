//
//  SongPlay.swift
//  akash and cameron
//
//  Created by keckuser on 4/15/24.
//
import SwiftUI
import AVKit
import AVFoundation

struct PlayerViewController: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let defaultUrl = "~/Documents/asb/cmsi2022/a4/your-own-akash-and-cameron/'akash and cameron'/Dondi.mp4"
        let player = AVPlayer(url: URL(fileURLWithPath: Bundle.main.path(forResource: "Dondi", ofType: "mp4") ?? defaultUrl))
        let vc = AVPlayerViewController()
        vc.player = player
        return vc
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        // Update the view controller if needed
    }
}

struct PlaySong: View {
    var body: some View {
        Text("")
    }
}
