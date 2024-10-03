//
//  AuthorizationInterface.swift
//  telegramClient2
//
//  Created by Akash on 4/26/24.
//

import SwiftUI
import TDLibKit

struct AuthorizationInterface: View {
    @State var client: TelegramClient
    
    @Binding var presentSheet: Bool
    
    @State var text = ""
    
    @Binding var loggedIn: Bool
    
    @State var phoneNumber = ""
    @State var firstName = ""
    @State var lastName = ""
    
    var body: some View {
        VStack {
            switch client.authState {
            case .authorizationStateWaitCode(let codeInfoWrapper):
                TextField("Enter code", text: $text)
                    .onSubmit {
                        print("Sent code")
                        presentSheet = false
                        loggedIn = client.sendCode(code: text)
                    }
                // Text("Code info: \(codeInfoWrapper.codeInfo.type)")
            case .authorizationStateWaitPhoneNumber:
                TextField("Enter phone number", text: $phoneNumber)
                    .onSubmit {
                        presentSheet = false
                        presentSheet = true
                    }
            case .authorizationStateWaitRegistration(_):
                TextField("First name", text: $firstName).padding()
                TextField("Last name", text: $lastName).padding()
                Button(action: {
                    client.registerUser(firstName: firstName, lastName: lastName)
                }) {
                    Text("Register")
                }
                
            case .authorizationStateWaitEmailCode(_):
                TextField("Enter code", text: $text)
                    .onSubmit {
                        print("Sent code")
                        presentSheet = false
                        loggedIn = client.sendEmailCode(code: text)
                    }
            default:
                ProgressView().task {
                    presentSheet = false
                }
            }
        }.padding()
    }
}
