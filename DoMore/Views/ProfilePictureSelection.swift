//
//  ProfilePictureSelection.swift
//  DoMore
//
//  Created by Zachary Farmer on 3/9/25.
//

import SwiftUI
import FirebaseFirestore

struct ProfilePictureSelection: View {
    @State private var arr: [String] = []
    @State private var isLoading = true

    var body: some View {
        VStack {
            Text("PROFILE PICTURES")
                .font(.custom("ShareTechMono-Regular", size: 30))
            Text("EMAIL ME FOR A CUSTOM PROFILE PICTURE")
                .font(.custom("ShareTechMono-Regular", size: 12))
                .foregroundStyle(Color.gray)
            
            ScrollView {
                LazyHStack(alignment: .center) {
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(arr.chunked(into: 3), id: \.self) { chunk in
                            LazyHStack(spacing: 20) {
                                ForEach(chunk, id: \.self) { image in
                                    Button {
                                        
                                    } label: {
                                        CircularProfileImageView(size: .xxLarge, image: image)
                                    }
                                }
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom)
                }
            }
        }
        .padding(.top)
        .padding(.horizontal, 35)
        .onAppear {
            fetchPhotos()
        }
    }
    
    private func fetchPhotos() {
        let db = Firestore.firestore()
        db.collection(Path.FireStore.profilePictures)
            .getDocuments { snapshot, error in
                isLoading = false
                if let error = error {
                    print("Error fetching profile pictures: \(error)")
                    return
                }
                
                if let documents = snapshot?.documents {
                    self.arr = documents.compactMap { doc in
                        doc.data()["image"] as? String
                    }
                } else {
                    print("No profile pictures found")
                    self.arr = []
                }
            }
    }

}

#Preview {
    ProfilePictureSelection()
}
