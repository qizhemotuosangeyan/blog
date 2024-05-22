//
//  ContentView.swift
//  TabViewDemo Watch App
//
//  Created by 千千 on 5/7/24.
//


import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            // 第一个 Tab
            VStack {
                Image(systemName: "house.fill")
                    .resizable()
                    .scaledToFit()
                    .padding()
                Text("Home")
            }
            .tabItem {
                Label("Home", systemImage: "house.fill")
            }

            // 第二个 Tab
            VStack {
                Image(systemName: "person.fill")
                    .resizable()
                    .scaledToFit()
                    .padding()
                Text("Profile")
            }
            .tabItem {
                Label("Profile", systemImage: "person.fill")
            }

            // 第三个 Tab
            VStack {
                Image(systemName: "gearshape.fill")
                    .resizable()
                    .scaledToFit()
                    .padding()
                Text("Settings")
            }
            .tabItem {
                Label("Settings", systemImage: "gearshape.fill")
            }
        }
    }
    
}

#Preview {
    ContentView()
}
