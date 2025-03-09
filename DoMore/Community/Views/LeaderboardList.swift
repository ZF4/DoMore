//
//  LeaderboardList.swift
//  DoMore
//
//  Created by Zachary Farmer on 3/5/25.
//

import SwiftUI
import FirebaseFirestore

struct LeaderboardList: View {
    @State private var users: [UserModel] = []
    @State private var isLoading = true
    
    var body: some View {
        VStack {
            Text("COMMUNITY")
                .font(.custom("ShareTechMono-Regular", size: 30))
            ScrollView {
                if isLoading {
                    ProgressView()
                } else {
                    ForEach(Array(users.enumerated()), id: \.element.id) { index, user in
                        LeaderboardCell(rank: index + 1, user: user)
                    }
                }
            }
            .onAppear {
                fetchUsers()
            }
        }
    }
    
    private func fetchUsers() {
        let db = Firestore.firestore()
        db.collection(Path.FireStore.profiles)
            .order(by: "points", descending: true)
            .getDocuments { snapshot, error in
                isLoading = false
                if let error = error {
                    print("Error fetching users: \(error)")
                    return
                }
                
                users = snapshot?.documents.compactMap { document in
                    try? document.data(as: UserModel.self)
                } ?? []
            }
    }
}

#Preview {
    LeaderboardList()
}
