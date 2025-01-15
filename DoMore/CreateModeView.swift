//
//  CreateModeView.swift
//  DoMore
//
//  Created by Zachary Farmer on 1/14/25.
//

import SwiftUI

import SwiftUI

struct CreateModeView: View {
    @State private var modeName: String = "" // Editable mode name
    @State var showDelete: Bool = false
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Name Section
                    VStack(alignment: .leading, spacing: 10) {
                        Text("NAME")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.gray)
                        
                        TextField("Mode name", text: $modeName)
                            .font(.body)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(8)
                    }
                    .padding(.horizontal)

                    // Select Apps Section
                    VStack(alignment: .leading, spacing: 10) {
                        Text("SELECT APPS")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.gray)

                        Button(action: {
                            // Select Apps action
                        }) {
                            HStack {
                                Text("0 Apps Selected")
                                    .font(.body)
                                    .bold()
                                    .foregroundStyle(.gray)
                                Spacer()
                                Button {
                                    
                                } label: {
                                    Image(systemName: "pencil")
                                        .font(.system(size: 20))
                                        .bold()
                                        .foregroundColor(.gray)
                                }
                                .tint(.gray)

                            }
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(8)
                        }
                    }
                    .padding(.horizontal)

                    // Done Button
                    Button(action: {
                        // Done action
                    }) {
                        Text("DONE")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.black)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                }
                .padding(.top)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.white)
                .edgesIgnoringSafeArea(.bottom)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {

                        } label: {
                            Image(systemName: "trash")
                                .bold()
                        }
                        .tint(.gray)
                    }
                    
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "chevron.left")
                                .bold()
                        }
                        .tint(.gray)
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle("EDIT MODE")
            }
            
            Spacer()

        }
    }
}

#Preview {
    CreateModeView()
}
