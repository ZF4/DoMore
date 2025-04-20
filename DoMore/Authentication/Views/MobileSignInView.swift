import SwiftUI
import AuthenticationServices
import Firebase

struct MobileSignInView: View {
    @StateObject var loginModel: UserViewModel = .init()
    @Environment(\.colorScheme) var colorScheme
    @State var isTextSent: Bool = false
    var body: some View {
        ZStack {
            VStack(spacing: 15) {
                Text("STRIDE")
                    .font(.custom("ShareTechMono-Regular", size: 50))
                    .padding(.bottom, 15)
                
                Text("MOBILE LOGIN")
                    .font(.custom("ShareTechMono-Regular", size: 15))
                    .padding(.bottom, 12)
                
                Text("I PROMISE NOT TO ADD YOU TO MY FAMILY GROUP CHAT.")
                    .font(.custom("ShareTechMono-Regular", size: 12))
                    .padding(.bottom, 20)

                
                // MARK: Custom TextField
                
                if !isTextSent {
                    CustomTextField(hint: "+1-800-273-8255", text: $loginModel.mobileNo)
                        .keyboardType(.numberPad)
                        .padding(.top,50)
                    
                } else {
                    CustomTextField(hint: "OTP Code", text: $loginModel.otpCode)
                        .keyboardType(.numberPad)
                        .padding(.top,20)
                    
                }
                
                
                Text("STANDARD MESSAGING AND DATA RATES MAY APPLY FOR VERIFICATION CODES")
                    .font(.custom("ShareTechMono-Regular", size: 10))
                    .foregroundStyle(Color.gray)
                    .padding(.bottom, 10)

                if !isTextSent {
                    Button {
                        loginModel.getOTPCode()
                        isTextSent.toggle()
                    } label: {
                        Text("Get Code")
                            .font(.custom("ShareTechMono-Regular", size: 18))
                            .padding()
                            .frame(maxWidth: .infinity)
                            .foregroundStyle(colorScheme == .dark ? Color.white : Color.black)
                            .background(colorScheme == .dark ? Color.gray.opacity(0.6) : Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 1)
                    }
                    .padding(.top, 10)
                    
                } else {
                    Button {
                        loginModel.verifyOTPCode()
                    } label: {
                        Text("Verify Code")
                            .font(.custom("ShareTechMono-Regular", size: 18))
                            .padding()
                            .frame(maxWidth: .infinity)
                            .foregroundStyle(colorScheme == .dark ? Color.white : Color.black)
                            .background(colorScheme == .dark ? Color.gray.opacity(0.6) : Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 1)
                    }
                    .padding(.top, 20)
                }
            }
            .padding(.horizontal,75)
            .padding(.vertical,15)
        }
        .alert(loginModel.errorMessage, isPresented: $loginModel.showError) {
        }
    }
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        MobileSignInView()
    }
}

import SwiftUI

struct CustomTextField: View {
    var hint: String
    @Binding var text: String
    
    // MARK: View Properties
    @FocusState var isEnabled: Bool
    var contentType: UITextContentType = .telephoneNumber
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            TextField(hint, text: $text)
                .keyboardType(.numberPad)
                .textContentType(contentType)
                .focused($isEnabled)
            
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(.black.opacity(0.2))
                
                Rectangle()
                    .fill(.black)
                    .frame(width: isEnabled ? nil : 0,alignment: .leading)
                    .animation(.easeInOut(duration: 0.3), value: isEnabled)
            }
            .frame(height: 2)
        }
    }
}

