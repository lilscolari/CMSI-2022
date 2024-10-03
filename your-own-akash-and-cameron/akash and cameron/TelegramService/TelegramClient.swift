//
//  TelegramClient.swift
//  telegramClient2
//
//  Created by keckuser on 4/24/24.
//

import Foundation
import SwiftUI
import TDLibKit

let API_ID = 24067938
let API_HASH = "d8271c360dc7128d81f59f2c7d9427ce"
let APP_TITLE = "downloader"
let SHORT_NAME = "downloader"
let DIRECTORY = ""

let NUMBER = "15718990626"

//let BOT_NAME = "songdl_bot"
let BOT_NAME = "@Yandex_music_download_bot"

let QUANTITY_SEARCHED = 20

class TelegramClient: ObservableObject {
    
    var manager: TDLibClientManager
    var client: TDLibClient?
    
    var authState = AuthorizationState.authorizationStateWaitTdlibParameters
    var awaitingInput = false
    
    var connectionState = ConnectionState.connectionStateWaitingForNetwork
    @Published var error: ClientError?
    var lastMsg: Message?
    
    var awaitingMsg = false
    
    var ourChatId: Int64?
    //    var inlineQueryId: InlineQueryResult
    
    init() {
        manager = TDLibClientManager()
        client = manager.createClient(updateHandler: {/* data: Data, client: TDLibCLient */
            do {
                let update = try $1.decoder.decode(Update.self, from: $0)
                self.handleUpdate(update: update)
            } catch {
                self.error = ClientError.updateHandlerError
            }
        })
    }
    
    func clickButton(inlineWrapper: InlineWrapper) async -> Bool {
        if let client = client {
            do {
                let chatId = try await getChatId()
                
                //try await client.sendInlineQueryResultMessage(
                //     chatId: chatId,
                //     hideViaBot: false,
                //     messageThreadId: nil,
                //     options: nil,
                //     queryId: nil,
                 //    replyTo: nil,
                 //    resultId: nil
                 //)
                return true
            } catch {
                self.error = catchError(err: error, errMessage: "Clicking button failed")
                print("PROBLEM \(error)")
            }
        }
        return false
    }
    
    func handleUpdate(update: Update) {
        switch update {
        case .updateNewMessage(let newMsg):
            handleMessage(msg: newMsg.message)
            
        case .updateAuthorizationState(let newState):
            self.authState = newState.authorizationState
            print("Authstate: \(authState)")
            self.handleAuthorization()
            
        case .updateConnectionState(let newState):
            self.connectionState = newState.state
            self.handleConnection()
            
        case .updateMessageSendAcknowledged(let msg):
            print("Ack \(msg.chatId)")
            print("Ack \(msg.messageId)")
            
        case .updateMessageSendSucceeded(let msg):
            // print("Suc \(msg.message)")
            print("Suc \(msg.oldMessageId)")
            
        case .updateMessageSendFailed(let msg):
            // print("Fai \(msg.message)")
            print("Fai \(msg.oldMessageId)")
            let service = msg.error
            self.error = ClientError.serviceError(service.code, service.message)
            
        default:
            print("Unhandled Update \(update)")
            break
        }
    }
    
    func authSetParameters(clientExists: TDLibClient) {
        Task {
            do {
                try await clientExists.setTdlibParameters(
                    apiHash: API_HASH,
                    apiId: API_ID,
                    applicationVersion: "1.0",
                    databaseDirectory: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].path + "/TDLibDatabase",
                    databaseEncryptionKey : Data(),
                    deviceModel: "iPhone",
                    filesDirectory: nil,
                    systemLanguageCode: "en",
                    systemVersion: nil,
                    useChatInfoDatabase: false,
                    useFileDatabase: false,
                    useMessageDatabase: false,
                    useSecretChats: false, // Modify if needed
                    useTestDc: false
                )
            } catch {
                self.error = catchError(err: error, errMessage: "Auth: parameters")
            }
        }
    }
    
    func authSendPhone(clientExists: TDLibClient, phoneNumber: String) {
        Task {
            do {
                try await clientExists.setAuthenticationPhoneNumber(
                    phoneNumber: phoneNumber,
                    settings: PhoneNumberAuthenticationSettings(
                        allowFlashCall: false,
                        allowMissedCall: false,
                        allowSmsRetrieverApi: false,
                        authenticationTokens: [], // CHANGE when obtained
                        firebaseAuthenticationSettings: nil,
                        isCurrentPhoneNumber: false
                    )
                )
            } catch {
                self.error = catchError(err: error, errMessage: "Auth: phone number")
            }
        }
    }
    
    func handleAuthorization() {
        print("Authstate: \(self.authState)")
        if let client = client {
            switch authState {
            case .authorizationStateWaitTdlibParameters:
                authSetParameters(clientExists: client)
                
            case .authorizationStateWaitPhoneNumber:
                authSendPhone(clientExists: client, phoneNumber: NUMBER)
                
            case .authorizationStateWaitOtherDeviceConfirmation(let linkConfirmation):
                let link = linkConfirmation.link
                print("Login link: \(link)")
                
            case .authorizationStateWaitCode(_):
                awaitingInput = true
                
            case .authorizationStateReady:
                print("AUTHORIZED")
                
            case .authorizationStateWaitRegistration(_):
                awaitingInput = true
                print("Wants registration")
                
            case .authorizationStateWaitPassword(_):
                awaitingInput = true
                print("Wants password")
                
            default:
                break
            }
            
            
            // repeat
            //                if !authorized {
            //                    handleAuthorization()
            //                }
        }
    }
    
    func registerUser(firstName: String, lastName: String) {
        if let client = client {
            Task {
                do {
                    try await client.registerUser(disableNotification: false, firstName: firstName, lastName: lastName)
                } catch {
                    self.error = catchError(err: error, errMessage: "Registration failed")
                }
            }
        }
    }
    
    func sendEmailCode(code: String) -> Bool {
        awaitingInput = false
        if let client = client {
            Task {
                do {
                    let authWrapper = EmailAddressAuthentication.emailAddressAuthenticationCode(
                        EmailAddressAuthenticationCode(code: code)
                    )
                    try await client.checkAuthenticationEmailCode(code: authWrapper)
                    return true
                } catch {
                    self.error = catchError(err: error, errMessage: "Auth: code")
                    awaitingInput = true
                    return false
                }
            }
        }
        return false
    }
    
    func sendCode(code: String) -> Bool {
        awaitingInput = false
        if let client = client {
            Task {
                do {
                    try await client.checkAuthenticationCode(code: code)
                    return true
                } catch {
                    self.error = catchError(err: error, errMessage: "Auth: code")
                    awaitingInput = true
                    return false
                }
            }
        }
        return false
    }
    
    func handleConnection() {
        switch self.connectionState {
        case .connectionStateReady:
            print("Connected")
            // case .connectionStateWaitingForNetwork:
            
            // case .connectionStateConnectingToProxy:
            
            // case .connectionStateConnecting:
            
            // case .connectionStateUpdating:
            
        default:
            self.error = ClientError.connectionError
        }
    }
    
    func handleMessage(msg: Message) {
        // Check who sent it
        // If it is the bot, continue
        
        Task {
            if msg.isOutgoing {
                return
            }
            
            let chatId = try await getChatId()
            if msg.chatId != chatId {
                return
            }
            
            lastMsg = msg
            // Prepare for all cases. Experiment with the bot.
            // Automatically join channels which it asks to join. Possibly check if it worked
            // Set up a default case in case all else fails
            switch msg.content {
            case .messageText(let text):
                print("Text Message: \(text.text.text)")
            default:
                break
            }
            
            // How to categorize songs? Based on what the bot gives us.
            // That is: Song name, Artist, image, and the song itself.
            // Will we have our own database for albums etc? Idk
        }
        
    }
    
    func getChatId() async throws -> Int64 {
        if let ourChatIdExists = ourChatId {
            return ourChatIdExists
        }
        if let client = client {
            do {
                let chat = try await client.searchPublicChat(username: BOT_NAME)
                print("CHAT ID FOUND: \(chat.id)")
                ourChatId = chat.id
                return chat.id
            } catch {
                throw ClientError.noChatError
            }
        } else {
            throw ClientError.noClientError
        }
    }
    
    func sendBotMessage(text: String) async throws {
        if let client = client {
            do {
                let chatId = try await getChatId()
                let formattedText = FormattedText(entities: [TextEntity](), text: text)
                let inputMessage = InputMessageText(clearDraft: false, linkPreviewOptions: nil, text: formattedText)
                let msgContent = InputMessageContent.inputMessageText(inputMessage)
                let sentMsg = try await client.sendMessage(
                    chatId: chatId,
                    inputMessageContent: msgContent,
                    messageThreadId: nil,
                    options: nil,
                    replyMarkup: nil,
                    replyTo: nil
                )
                
                awaitingMsg = true
            } catch {
                throw ClientError.noClientError // CHANGE
            }
        }
    }
    
    func close() {
        manager.closeClients()
    }
    
    func getMessage(chatId: Int64, msgId: Int64, start: Int64, limit: Int) async throws -> Message? {
        if let client = client {
            do {
                return try await client.getMessage(chatId: chatId, messageId: msgId)
            } catch {
                throw error
            }
        } else {
            throw ClientError.noClientError
        }
    }
    
    func getBotChat(start: Int64, limit: Int) async throws -> [Message]? {
        do {
            let chatId = try await getChatId()
            return try await getChat(chatId: chatId, start: start, limit: limit)
        } catch {
            throw error
        }
    }
    
    func getChat(chatId: Int64, start: Int64, limit: Int) async throws -> [Message] {
        if let client = client {
            do {
                let chatHistory = try await client.getChatHistory(
                    chatId: chatId,
                    fromMessageId: start,
                    limit: limit, // prepare to raise limit
                    offset: 0,
                    onlyLocal: false // Request remote messages from server
                )
                if let messages = chatHistory.messages {
                    return messages
                } else {
                    return [Message]()
                }
                
            } catch {
                throw error
            }
        } else {
            throw ClientError.noClientError
        }
    }
}
