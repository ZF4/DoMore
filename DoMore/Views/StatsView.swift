//
//  StatsView.swift
//  DoMore
//
//  Created by Zachary Farmer on 2/19/25.
//

import SwiftUI
import DeviceActivity

struct StatsView: View {
    @StateObject private var viewModel = StatsViewModel()
    
    var body: some View {
        VStack {
            timeSavedView
            
            VStack(alignment: .leading) {
                Text("FITNESS")
                    .font(.custom("ShareTechMono-Regular", size: 30))
                
                customDivider //DIVIDER
                
                todayFitnesView
                
                customDivider //DIVIDER
                
                lastSevenDaysView
                
                customDivider //DIVIDER
                
                allTimeFitnessView
            }
            .padding(.bottom)
            
            Text("YOU'RE DOING AWESOME")
                .font(.custom("ShareTechMono-Regular", size: 16))
        }
        .onAppear {
            viewModel.fetchHealthDataHistory()
            viewModel.fetchHealthDataToday()
        }
    }
    
    var timeSavedView: some View {
        VStack {
            VStack(alignment: .leading) {
                Text("SCREEN TIME")
                    .font(.custom("ShareTechMono-Regular", size: 30))
                
                customDivider //DIVIDER
                
                Text("TIME SAVED")
                    .font(.custom("ShareTechMono-Regular", size: 20))
            }
            
            HStack(alignment: .lastTextBaseline) {
                Text("\(viewModel.daysBlocked)")
                    .font(.custom("ShareTechMono-Regular", size: 200))
                
                VStack(alignment: .leading) {
                    HStack(alignment: .lastTextBaseline) {
                        Text("\(viewModel.hoursBlocked)")
                            .font(.custom("ShareTechMono-Regular", size: 40))
                        Text("hrs")
                            .font(.custom("ShareTechMono-Regular", size: 20))
                        
                    }
                    
                    HStack(alignment: .lastTextBaseline) {
                        Text("\(viewModel.minutesBlocked)")
                            .font(.custom("ShareTechMono-Regular", size: 40))
                        Text("mins")
                            .font(.custom("ShareTechMono-Regular", size: 20))
                        
                    }
                    
                    Text("days")
                        .font(.custom("ShareTechMono-Regular", size: 40))
                }
            }
        }
    }
    
    var todayFitnesView: some View {
        VStack(alignment: .leading) {
            Text("TODAY")
                .font(.custom("ShareTechMono-Regular", size: 20))
            
            HStack {
                VStack(alignment: .leading) {
                    Text("Steps:")
                        .font(.custom("ShareTechMono-Regular", size: 16))
                    Text("Mins:")
                        .font(.custom("ShareTechMono-Regular", size: 16))
                }
                VStack(alignment: .leading) {
                    Text("\(Int(viewModel.todaysSteps))")
                        .font(.custom("ShareTechMono-Regular", size: 16))
                    Text("\(Int(viewModel.todaysMins))")
                        .font(.custom("ShareTechMono-Regular", size: 16))
                }
            }
        }
    }
    
    var lastSevenDaysView: some View {
        VStack(alignment: .leading) {
            Text("LAST SEVEN DAYS")
                .font(.custom("ShareTechMono-Regular", size: 20))
            
            HStack {
                VStack(alignment: .leading) {
                    Text("Steps:")
                        .font(.custom("ShareTechMono-Regular", size: 16))
                    Text("Mins:")
                        .font(.custom("ShareTechMono-Regular", size: 16))
                }
                VStack(alignment: .leading) {
                    Text("\(viewModel.lastSevenDaysSteps)")
                        .font(.custom("ShareTechMono-Regular", size: 16))
                    Text("\(viewModel.lastSevenDaysMins)")
                        .font(.custom("ShareTechMono-Regular", size: 16))
                }
            }
        }
    }
    
    var allTimeFitnessView: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("TOTAL WHILE USING APP")
                    .font(.custom("ShareTechMono-Regular", size: 20))
            }
            
            HStack {
                VStack(alignment: .leading) {
                    Text("Steps:")
                        .font(.custom("ShareTechMono-Regular", size: 16))
                    Text("Mins:")
                        .font(.custom("ShareTechMono-Regular", size: 16))
                }
                VStack(alignment: .leading) {
                    Text("\(viewModel.allTimeSteps)")
                        .font(.custom("ShareTechMono-Regular", size: 16))
                    Text("\(viewModel.allTimeMins)")
                        .font(.custom("ShareTechMono-Regular", size: 16))
                }
            }
        }
    }
    
    var customDivider: some View {
        Text("..........................")
            .font(.custom("ShareTechMono-Regular", size: 25))
    }
}

#Preview {
    StatsView()
}

