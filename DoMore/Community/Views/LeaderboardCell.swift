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

import SwiftUI
import Kingfisher


enum ProfileImageSize {
    case xxSmall
    case xSmall
    case small
    case medium
    case large
    case xLarge
    case xxLarge
    
    var demension: CGFloat {
        switch self {
        case .xxSmall: return 28
        case .xSmall: return 32
        case .small: return 40
        case .medium: return 48
        case .large: return 64
        case .xLarge: return 80
        case .xxLarge: return 100
        }
    }
}

#Preview {
    LeaderboardCell()
}

struct CircularProfileImageView: View {
    @Environment(\.colorScheme) var colorScheme
    var user: UserModel?
    let size: ProfileImageSize
    var image: String?
    let defaultImage: String = "https://i.imgur.com/kIYMHRH.png"

    var body: some View {
        if let imageUrl = user?.profilePicture {
            KFImage(URL(string: imageUrl))
                .resizable()
                .scaledToFill()
                .frame(width: size.demension, height: size.demension)
                .background(Color.gray.opacity(0.3))
                .clipShape(Circle())
        } else {
            KFImage(URL(string: image ?? defaultImage))
                .resizable()
                .scaledToFill()
                .frame(width: size.demension, height: size.demension)
                .background(Color.gray.opacity(0.3))
                .clipShape(Circle())
        }
    }
}



