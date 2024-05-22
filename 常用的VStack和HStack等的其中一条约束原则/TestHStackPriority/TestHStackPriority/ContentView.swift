//
//  ContentView.swift
//  TestHStackPriority
//
//  Created by 千千 on 5/13/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        HStack(spacing: 0) {
            Color.red
            Text("Would you like to drink something?")
            Color.blue
        }
        HStack(spacing: 0) {
            Color.red
            Text("Would you like to drink something?")
                .layoutPriority(1)
            Color.blue
        }
    }
}

#Preview {
    ContentView()
}
