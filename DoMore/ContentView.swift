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
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        TabView {
            //MARK: Home View
            NavigationView {
                HomeScreen()
            }
            .tabItem {
                Label("Home", systemImage: "house.fill")
            }
            
            //MARK: Stat View
            NavigationView {
                StatsView()
            }
            .tabItem {
                Label("Stats", systemImage: "chart.bar.fill")
            }
            
            //MARK: Community View
            NavigationView {
                LeaderboardList()
            }
            .tabItem {
                Label("Community", systemImage: "person.2.fill")
            }
            
            //MARK: Settings View
            NavigationView {
                SettingsView()
            }
            .tabItem {
                Label("Settings", systemImage: "gear")
            }
        }
        .tint(colorScheme == .dark ? .white : .black)
    }
}

#Preview {
    ContentView()
        .environmentObject(MyModel())
}
