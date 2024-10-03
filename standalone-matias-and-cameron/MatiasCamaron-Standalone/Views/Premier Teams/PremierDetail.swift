//
//  PremierDetail.swift
//  MatiasCamaron-Standalone
//
//  Created by Matias Martinez on 24/01/24.
//  Purpose of the file: display the detail page of every Premier League Team.

import SwiftUI

struct PremierDetail: View {
    @Environment(ModelData.self) var modelData
    @State var animated = false

    var premier: Premier
    var premierIndex: Int {
        modelData.premierTeams.firstIndex(where: { $0.id == premier.id })!
    }    
    var body: some View {
        @Bindable var modelData = modelData
        ScrollView {
        
            mapView(coordinate: premier.locationCoordinate)
                .frame(width: 400, height: 200)
                .mapStyle(.imagery(elevation: .realistic))
            
            LogoImage(image: premier.image)
                .frame(alignment: .center)
                .padding()
                .offset(y: animated ? -70:500)
                .animation(.easeOut(duration: 1), value: animated)
            
            
            VStack(alignment: .leading) {
                
                FavoriteButton(isSet: $modelData.premierTeams[premierIndex].isFavorite)
                    .offset(y: -140)
                HStack {
                    Text(premier.name)
                        .font(.title)
                        .offset(x: animated ? 0:400, y: -130)
                        .animation(.easeInOut(duration: 2), value: animated)
                }
                HStack {
                    Text(premier.city)
                        .offset(y: -120)
                    Spacer()
                    Text(premier.stadium)
                        .offset(y: -120)
                }
                .font(.subheadline)
                .foregroundStyle(.secondary)
                Divider()
                    .offset(y: -120)
                Text("About \(premier.name)")
                    .font(.title2)
                    .offset(y: -120)
                    .offset(x: animated ? 0:400)
                    .animation(.easeInOut(duration: 1), value: animated)
                
                Text(premier.description)
                    .offset(y: -120)
                    .offset(x: animated ? 0:400)
                    .animation(.easeInOut(duration: 1), value: animated)
                    .onAppear{animated.toggle()}
                Divider()
                    .offset(y: -120)
                Group {
                    Text("Common starting 11 for \(premier.name):")
                    Text(premier.players.joined(separator: ", "))
                } .offset(y: -120)
                ZStack {
                    Group {
                        HexagonBackground()
                            .offset(x: 125, y: -75)
                        Image("appicon")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .offset(y: -65)
                    } .offset(y: -20)
                }
            }
            .padding()
            Spacer()
        }
        .navigationTitle(premier.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}
#Preview {
    PremierDetail(premier: ModelData().premierTeams[0])
        .environment(ModelData())
}
