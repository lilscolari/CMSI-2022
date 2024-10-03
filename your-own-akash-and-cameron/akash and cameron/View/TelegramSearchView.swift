//
//  TelegramSearchView.swift
//  akash and cameron
//
//  Created by Akash on 4/30/24.
//

import SwiftUI
import TDLibKit

struct TelegramSearchView: View {
    var input: String
    
    @EnvironmentObject var client: TelegramClient
    
    @State var messageCache: [Message]?
    @State var loaded = true
    
    @State var awaitingReply = false
    @State var sent = false
    @State var failed = false
    
    func searchTelegram() { // input
        Task {
            if !sent {
                do {
                    try await client.sendBotMessage(text: input)
                    awaitingReply = true
                } catch {
                    print(error)
                    failed = true
                }
            } else {
                print("Unnecessary search attempted")
            }
        }
    }
    
    func load(iterations: Int) async {
        let i = iterations + 1
        do {
            messageCache = try await client.getBotChat(start: Int64(0), limit: QUANTITY_SEARCHED)
            loaded = true
        } catch {
            print(error)
            if i < 5 {
                await load(iterations: i)
            } else {
                print("FAILED to load messages")
                loaded = false
            }
        }
    }
    
    func reloadMessages() {
        messageCache = nil
    }
    
    var body: some View {
        VStack {
            if let messageCacheExists = messageCache {
                if let lastMessage = messageCacheExists.first {
                    if let replyMarkup = lastMessage.replyMarkup {
                        switch replyMarkup {
                        case .replyMarkupInlineKeyboard(let keyboard):
                            OptionsView(
                                msgId: lastMessage.id,
                                replyMarkupKeyboard: keyboard
                            )
                        default:
                            Text("Loaded messages too early...1")
                            ProgressView().task {
                                reloadMessages()
                            }
                        }
                    } else {
                        Text("Loaded messages too early...2")
                        ProgressView().task {
                            reloadMessages()
                        }
                    }
                } else {
                    Text("Loaded messages too early...3")
                    ProgressView().task {
                        reloadMessages()
                    }
                }
                
            } else {
                if awaitingReply {
                    ProgressView().task {
                        await load(iterations: 0)
                    }
                    
                } else {
                    if failed {
                        Text("FAILED to contact bot")
                    } else {
                        ProgressView().task {
                            searchTelegram()
                        }
                    }
                }
            }
        }.background(Color.clear)
    }
}
