//
//  FavoriteButton.swift
//  akash and cameron
//
//  Created by keckuser on 4/15/24.
//

import SwiftUI

struct FavoriteButton: View {
    
    @EnvironmentObject var songService: SongService
    
    @EnvironmentObject var auth: SongAuth
    
    @Binding var buttonTapped: Bool
    
    @State var title: String
    
    
    var body: some View {
        
        HStack {
            ZStack {
                image(Image(systemName: "star.fill"), show: buttonTapped)
                image(Image(systemName: "star"), show: !buttonTapped)
            }
        }
    }
    
    
    func image(_ image: Image, show: Bool) -> some View {
        image
            .foregroundStyle(buttonTapped ? Color(red: 255/255, green: 215/255, blue: 0/255) : .gray)
            .font(Font.custom("SpecialElite-Regular", size: 20))
            .scaleEffect(show ? 1 : 0)
            .opacity(show ? 1 : 0)
            .animation(.interpolatingSpring(stiffness: 200, damping: 30, initialVelocity: 5), value: show)
    }
}

struct FavoriteButton_Previews: PreviewProvider {
    @State static var buttonTapped = true
    
    static var previews: some View {
        FavoriteButton(buttonTapped: $buttonTapped, title: "test")
    }
}
