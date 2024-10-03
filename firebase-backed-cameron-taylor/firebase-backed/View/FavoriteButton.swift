//
//  FavoriteButton.swift
//  firebase-backed
//
//  Created by Taylor Musso on 3/23/24.
//  created using https://www.youtube.com/watch?v=KL50qKi66EQ
//

import SwiftUI

struct FavoriteButton: View {
    @Binding var buttonTapped: Bool
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
            .foregroundStyle(buttonTapped ? Color(red: 140/255, green: 120/255, blue: 80/255) : .gray)
            .font(Font.custom("SpecialElite-Regular", size: 20))
            .scaleEffect(show ? 1 : 0)
            .opacity(show ? 1 : 0)
            .animation(.interpolatingSpring(stiffness: 200, damping: 30, initialVelocity: 5), value: show)
    }
}

struct FavoriteButton_Previews: PreviewProvider {
    @State static var buttonTapped = true
    
    static var previews: some View {
        FavoriteButton(buttonTapped: $buttonTapped)
    }
}
