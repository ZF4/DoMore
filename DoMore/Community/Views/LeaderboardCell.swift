//
//  LeaderboardCell.swift
//  DoMore
//
//  Created by Zachary Farmer on 3/4/25.
//

import SwiftUI

struct LeaderboardCell: View {
    var rank: Int?
    var user: UserModel?
    var body: some View {
        VStack(alignment: .trailing) {
            LeaderboardTemplate(rank: rank, user: user)
        }
    }
}

struct LeaderboardTemplate: View {
    var rank: Int?
    var user: UserModel?
    var body: some View {
            HStack {
                if rank == 1 {
                    Text(String(rank ?? 0))
                        .font(.custom("ShareTechMono-Regular", size: 30))
                        .padding(.trailing, 10)
                        .foregroundStyle(Color.yellow)
                    
                } else {
                    Text(String(rank ?? 0))
                        .font(.custom("ShareTechMono-Regular", size: 30))
                        .padding(.trailing, 10)
                }
                
                CircularProfileImageView(user: user, size: .medium)
                
                Text(user?.username ?? "username")
                    .font(.custom("ShareTechMono-Regular", size: 30))
                    .padding(.trailing, 10)
                Spacer()
                
                Text(String(user?.points ?? 0))
                    .font(.custom("ShareTechMono-Regular", size: 25))
                
            }
            .padding(.horizontal)
            
            Divider()
    }
}

#Preview {
    LeaderboardCell()
}
