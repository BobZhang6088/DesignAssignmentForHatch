//
//  ContentView.swift
//  DesignAssignmentForHatch
//
//  Created by Bob Zhang on 2025-03-26.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ViewModel()
//    @FocusState var inputViewFocused: Bool
//    @State private var selectedImages: [UIImage] = []
//    @State private var pickerHeight: CGFloat = .zero
//    @State var selectedPresentationDetent: PresentationDetent = .medium
//    let originalPhotoPickerHeight = UIScreen.main.bounds.height * 0.5
    @State var inputViewTopY: CGFloat = 0
    @State var inputViewExpanded: Bool = false
    @State var imagePickerExpanded: Bool = false

    var body: some View {
            ZStack(alignment:.bottom) {
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
                    .offset(CGSizeMake(0, inputViewTopY - UIScreen.main.bounds.height ))
                    .background(Color(.systemGray6))
                    .navigationTitle("Chat")
                    .navigationBarTitleDisplayMode(.inline)
                    .ignoresSafeArea([.keyboard])
                }
                if inputViewExpanded || imagePickerExpanded {
                    Color.black.opacity(0.5).edgesIgnoringSafeArea(.all)
                }
                InputSheet(expanded: $inputViewExpanded, imagePickerExpanded: $imagePickerExpanded) { y in
                    if !inputViewExpanded {
                        withAnimation {
                            inputViewTopY = y
                        }
                    }
                }
            }
            .ignoresSafeArea([.keyboard])
    }
}

#Preview {
    ContentView()
}


struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}
