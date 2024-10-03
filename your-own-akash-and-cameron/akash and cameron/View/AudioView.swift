//
//  SongView.swift
//  akash and cameron
//
//  Created by keckuser on 4/30/24.
//

import SwiftUI
import TDLibKit
import Foundation

struct AudioView: View {
    
    @EnvironmentObject var client: TelegramClient
    
    @State var title: String
    
    @State var audio: MessageAudio?
    @State var toLoad = true
    
    @State var attempt = 0
    
    func loadAudio(iterations: Int) async { 
        let i = iterations + 1
        do {
            let messageCache = try await client.getBotChat(start: Int64(attempt), limit: QUANTITY_SEARCHED) ?? [Message]()
            if let message = messageCache.first {
                switch message.content {
                case .messageAudio(let msgAudio):
                    audio = msgAudio
                default:
                    break
                }
            }
        } catch {
            print(error)
            if i < 5 {
                await loadAudio(iterations: i)
            } else {
                print("FAILED to load messages")
            }
        }
        toLoad = false
    }
    
    var body: some View {
        VStack {
            if let audioExists = audio {
                AudioManagerView(audio: audioExists.audio)
                
                Text(audioExists.caption.text)
                
                Button("Click if wrong audio") {
                    audio = nil
                    attempt += 1
                }
            } else {
                if toLoad {
                    ProgressView().task {
                        await loadAudio(iterations: 0)
                    }.offset(y: -100)
                } else {
                    Text("Failed to load audio")
                    
                    Button(action: {
                        toLoad = true
                    }) {
                        Text("Try again")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }
            }
        }.background(.white)
    }
}
