//
//  UserViewModel.swift
//  DoMore
//
//  Created by Zachary Farmer on 2/27/25.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import SwiftUI
import Combine
import CryptoKit
import AuthenticationServices

@MainActor
class UserViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: UserModel?
    @Published var isExistingUser: Bool = false
    @Published var isLoading: Bool = true
    //MARK: Mobile Login view properties
    @Published var mobileNo: String = ""
    @Published var otpCode: String = ""
    
    @Published var clientCode: String = ""
    
    //MARK: Error Properties
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""
    
    // MARK: App Log Status
    @AppStorage("log_status") var logStatus: Bool = false
    
    // MARK: Apple Sign in Properties
    @Published var nonce: String = ""
    
    private let db = Firestore.firestore()
    private var cancellables = Set<AnyCancellable>()
    
    
    init() {
        self.userSession = Auth.auth().currentUser
    }
    
    func getOTPCode(){
        UIApplication.shared.closeKeyboard()
        Task{
            do{
                // MARK: Disable it when testing with Real Device
                Auth.auth().settings?.isAppVerificationDisabledForTesting = true
                
                let code = try await PhoneAuthProvider.provider().verifyPhoneNumber("+\(mobileNo)", uiDelegate: nil)
                await MainActor.run(body: {
                    clientCode = code
                })
            }catch{
                await handleError(error: error)
            }
        }
    }
    
    func verifyOTPCode() {
        UIApplication.shared.closeKeyboard()
        Task {
            do {
                let credential = PhoneAuthProvider.provider().credential(withVerificationID: clientCode, verificationCode: otpCode)
                try await Auth.auth().signIn(with: credential)
                await checkExistingUser()
            } catch {
               await handleError(error: error)
            }
        }
    }
    
    func handleError(error: Error) async {
        await MainActor.run(body: {
            errorMessage = error.localizedDescription
            showError.toggle()
        })
    }
    
    
    func checkExistingUser() async {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let userRef = db.collection(Path.FireStore.profiles).document(userId)
        
        do {
            let document = try await userRef.getDocument()
            if document.exists, let user = try? document.data(as: UserModel.self) {
                currentUser = user
                isExistingUser = true
            } else {
                isExistingUser = false
                currentUser = nil
            }
        } catch {
            print("Error checking existing user: \(error)")
        }
    }
    
    func createNewUser(username: String) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let userRef = db.collection(Path.FireStore.profiles).document(userId)
        
        // Clear UserDefaults for new user
        UserDefaults.standard.removeObject(forKey: "totalBlockedTime")
        
        // Determine login method based on provider
        let loginMethod: UserModel.LoginMethod = Auth.auth().currentUser?.providerData.first?.providerID == "apple.com" ? .apple : .mobile
        
        // Create new user with username and login method
        let newUser = UserModel(id: userId, username: username, points: 0, userColorString: "#808080", loginMethod: loginMethod)
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
                print("No doc found")
            }
        } catch {
            print("Error in createOrUpdateUser: \(error)")
        }
    }
    func signOutUser() {
        try? Auth.auth().signOut() //signs out backend
        UserDefaults.standard.removeObject(forKey: "didOnboard") // Add this line
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
    
    func updateUserColor(_ color: Color) async {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let userRef = db.collection(Path.FireStore.profiles).document(userId)
        
        do {
            let hexString = color.toHex() ?? "#808080"
            let data = ["userColor": hexString]
            try await userRef.updateData(data as [String : Any])
            currentUser?.userColor = color
        } catch {
            print("Error updating user color: \(error)")
        }
    }
}


