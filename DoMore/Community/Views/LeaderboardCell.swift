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
        VStack {
            HStack {
                Text(String(rank ?? 0))
                    .font(.custom("ShareTechMono-Regular", size: 30))
                    .padding(.trailing, 10)
                
                CircularProfileImageView(user: user, size: .medium)
                
                Text(user?.username ?? "username")
                    .font(.custom("ShareTechMono-Regular", size: 30))
                    .padding(.trailing, 10)
                Text(String(user?.points ?? 0))
                    .font(.custom("ShareTechMono-Regular", size: 25))
                Spacer()
            }
            .padding(.horizontal)
            
            Divider()
        }
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
    
    var demension: CGFloat {
        switch self {
        case .xxSmall: return 28
        case .xSmall: return 32
        case .small: return 40
        case .medium: return 48
        case .large: return 64
        case .xLarge: return 80
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

    var body: some View {
        if let imageUrl = user?.profilePicture {
            KFImage(URL(string: imageUrl))
                .resizable()
                .scaledToFill()
                .frame(width: size.demension, height: size.demension)
                .background(Color.gray.opacity(0.3))
                .clipShape(Circle())
        } else {
            Image("noPicture")
                .resizable()
                .frame(width: size.demension, height: size.demension)
                .background(Color.gray.opacity(0.3))
                .clipShape(Circle())
        }
    }
}

//#Preview {
//    CircularProfileImageView(user: UserModel(id: "", username: "", profilePicture: "", points: 0), size: .medium)
//}


