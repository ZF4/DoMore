//
//  ContentView.swift
//  Limit
//
//  Created by Zachary Farmer on 12/15/24.
//

import SwiftUI
import SwiftData
import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            // Existing main content wrapped in a NavigationView
            NavigationView {
                HomeScreen()
            }
            .tabItem {
                Label("Home", systemImage: "house.fill")
            }
            
            // Additional tab views
            NavigationView {
                StatsView()
            }
            .tabItem {
                Label("Stats", systemImage: "chart.bar.fill")
            }
            
            NavigationView {
                SettingsView()
            }
            .tabItem {
                Label("Settings", systemImage: "gear")
            }
        }
        .tint(.black)
    }
}

#Preview {
    ContentView()
        .environmentObject(MyModel())
}
