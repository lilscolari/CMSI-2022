//
//  OptionsView.swift
//  akash and cameron
//
//  Created by Akash on 4/30/24.
//

import SwiftUI
import TDLibKit

struct OptionsView: View {
    let msgId: Int64
    let replyMarkupKeyboard: ReplyMarkupInlineKeyboard
    
    @EnvironmentObject var client: TelegramClient
    
    @State var optionsWrapper = [InlineWrapper]()
    
    @State var chosenOption: InlineWrapper?
    
    @State var isActiveArray = [Bool]()
    
    
    func wrapOptions() {
        var wrapperArray = [InlineWrapper]()
        
        for row in replyMarkupKeyboard.rows {
            for keyboardButton in row {
                switch keyboardButton.type {
                case .inlineKeyboardButtonTypeCallback(let callback):
                    wrapperArray.append(InlineWrapper(messageId: msgId, text: keyboardButton.text, sendbackData: callback.data, favorited: false))
                    isActiveArray.append(false)
                default:
                    continue
                }
                
            }
        }
        optionsWrapper = wrapperArray
    }
    
    var body: some View {
        NavigationView {
            VStack {
                
                if optionsWrapper.isEmpty {
                    ProgressView().task{
                        wrapOptions()
                    }
                } else {
                    
                    List(0...(optionsWrapper.count-1), id: \.self) { index in
                        let inlineWrapper = optionsWrapper[index]
                        NavigationLink(isActive: $isActiveArray[index]) {
                            LinkView(
                                isActive: $isActiveArray[index],
                                chosenSong: $optionsWrapper[index],
                                offlineSong: Song(
                                    title: inlineWrapper.text,
                                    id: "",
                                    msgId: nil,
                                    playlists: [String]()
                                )
                            )
                            .navigationBarBackButtonHidden(true)
                            .navigationBarItems(leading: BackButton2())
                        } label: {
                            Text(inlineWrapper.text)
                        }
                    }
                    .background(Color.clear)
                    // .scrollContentBackground(.hidden)
                }
            }
        }.background(Color.clear)
        // .scrollContentBackground(.hidden)
    }
}
