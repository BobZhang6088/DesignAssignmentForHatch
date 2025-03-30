//
//  Drawers.swift
//  DesignAssignmentForHatch
//
//  Created by Bob Zhang on 2025-03-29.
//

import SwiftUI

struct Drawers: View {
    var body: some View {
        DrawerView {
            NavigationStack {
                VStack {
                    Spacer()
//                         Quick reply chips
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(0..<4) { _ in
                                VStack(alignment: .leading) {
                                    Text("Some Text").bold()
                                    Text("Some more text")
                                }
                                .padding()
                                .background(Color(.systemBackground))
                                .cornerRadius(20)
                                .shadow(color:.black.opacity(0.1), radius: 3)
                            }
                        }
                        .padding()
                    }
                    .ignoresSafeArea([.keyboard])
                }
                .background(Color(.systemGray6))
                .navigationTitle("Chat")
                .navigationBarTitleDisplayMode(.inline)
                .ignoresSafeArea([.keyboard])
            }
        } drawer: {
            
        }
    }
}

#Preview {
    Drawers()
}
