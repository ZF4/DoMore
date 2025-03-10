//
//  UserViewModel.swift
//  DoMore
//
//  Created by Zachary Farmer on 2/27/25.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import Combine

@MainActor
class UserViewModel: ObservableObject {
    @Published var currentUser: UserModel?
    @Published var isExistingUser: Bool = false
    private let db = Firestore.firestore()
    private var cancellables = Set<AnyCancellable>()
    
    func checkExistingUser() async {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let userRef = db.collection(Path.FireStore.profiles).document(userId)
        
        do {
            let document = try await userRef.getDocument()
            if document.exists, let user = try? document.data(as: UserModel.self) {
                currentUser = user
                isExistingUser = true
            }
        } catch {
            print("Error checking existing user: \(error)")
        }
    }
    
    func createNewUser(username: String) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let userRef = db.collection(Path.FireStore.profiles).document(userId)
        
        // Create new user with username
        let newUser = UserModel(id: userId, username: username, points: 0)
        try? userRef.setData(from: newUser)
        self.currentUser = newUser
    }
    
    func checkUsernameAvailable(_ username: String) async throws -> Bool {
        let snapshot = try await db.collection(Path.FireStore.profiles)
            .whereField("username", isEqualTo: username)
            .getDocuments()
        
        return snapshot.documents.isEmpty
    }
    
    func createOrUpdateUser() async {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let userRef = db.collection(Path.FireStore.profiles).document(userId)
        
        do {
            let document = try await userRef.getDocument()
            if document.exists {
                // Update existing user
                await updateUserPoints(userId: userId)
            } else {
                // Create new user
                let newUser = UserModel(id: userId, username: "", profilePicture: "", points: 0)
                try userRef.setData(from: newUser)
                currentUser = newUser
            }
        } catch {
            print("Error in createOrUpdateUser: \(error)")
        }
    }
    
    func updateUserPoints(userId: String, points: Int? = nil) async {
        let userRef = db.collection(Path.FireStore.profiles).document(userId)
        
        do {
            let data: [String: Any]
            if let points = points {
                data = ["points": points]
                try await userRef.updateData(data as [String : Any])
                currentUser?.points = points
            } else {
                let blockedTime = UserDefaults.standard.double(forKey: "totalBlockedTime")
                let calculatedPoints = Int(ceil(blockedTime * 0.5))
                data = ["points": calculatedPoints]
                try await userRef.updateData(data as [String : Any])
                currentUser?.points = calculatedPoints
            }
        } catch {
            print("Error updating points: \(error)")
        }
    }
    
    func observeUserPoints() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        let userRef = db.collection(Path.FireStore.profiles).document(userId)
        userRef.addSnapshotListener { [weak self] document, error in
            guard let document = document,
                  let user = try? document.data(as: UserModel.self) else { return }
            
            DispatchQueue.main.async {
                self?.currentUser = user
            }
        }
    }
}
