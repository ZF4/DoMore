//
//  CircularImageView.swift
//  DoMore
//
//  Created by Zachary Farmer on 4/3/25.
//

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

struct CircularProfileImageView: View {
    @Environment(\.colorScheme) var colorScheme
    var user: UserModel?
    let size: ProfileImageSize
    var image: String?

    var body: some View {
        if let imageUrl = user?.profilePicture {
            KFImage(URL(string: imageUrl))
                .resizable()
                .scaledToFill()
                .frame(width: size.demension, height: size.demension)
                .background(Color.gray.opacity(0.3))
                .clipShape(Circle())
        } else {
            Image(colorScheme == .dark ? .logoLight : .logoDark)
                .resizable()
                .scaledToFill()
                .frame(width: size.demension, height: size.demension)
//                .clipShape(Circle())
                .background {
                    Circle()
                        .fill(user?.userColor ?? .gray)
                }
        }
    }
}

#Preview {
    CircularProfileImageView(size: .xLarge)
}
