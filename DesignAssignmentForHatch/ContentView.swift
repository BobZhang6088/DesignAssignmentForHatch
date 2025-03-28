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
//    @StateObject private var keyboard = KeyboardResponder()
    @State var inputViewFrame: CGRect = .zero
    @State var inputViewExpanded: Bool = false
    @State var imagePickerExpanded: Bool = false

    var body: some View {
        ZStack(alignment:.bottom) {
            NavigationStack {
                VStack {
                    Spacer()
                    // Quick reply chips
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(0..<4) { _ in
                                VStack(alignment: .leading) {
                                    Text("Some Text").bold()
                                    Text("Some more text")
                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(20)
                                .shadow(color:.black.opacity(0.1), radius: 3)
                            }
                        }
                        .padding()
                    }
                }
                .offset(CGSizeMake(0, -inputViewFrame.height))
                .background(Color(.systemGray6))
                .navigationTitle("Chat")
                .navigationBarTitleDisplayMode(.inline)
            }
            if inputViewExpanded || imagePickerExpanded {
                Color.black.opacity(0.5).edgesIgnoringSafeArea(.all)
            }
            InputSheet(expanded: $inputViewExpanded, imagePickerExpanded: $imagePickerExpanded)
                .onGeometryChange(for: CGRect.self) { proxy in
                    proxy.frame(in: .local)
                } action: { newValue in
                    print(newValue)
                    if !inputViewExpanded {
                        inputViewFrame = newValue
                    }
            }
        }
        //        .sheet(isPresented: .constant(true)) {
        //            InputSheet()
        //                .presentationSizing()
        //                .presentationDetents([], selection: $selectedPresentationDetent)
        //        }
        //        .padding(.bottom, viewModel.showPicker ? pickerHeight : 0)
        //        .animation(.default, value: viewModel.showPicker)
        //        .sheet(isPresented: $viewModel.showPicker) {
        //            CustomPhotosPicker(maxSelection: 5) { images in
        //                selectedImages = images
        //            }
        //            .presentationDetents([.height(originalPhotoPickerHeight), .large])
        //            .presentationDragIndicator(.visible)
        //            .presentationBackgroundInteraction(.enabled)
        //            .onPreferenceChange(ViewPositionKey.self) { newValue in
        //                let height = UIScreen.main.bounds.height - newValue.origin.y - 34
        //                pickerHeight = height > originalPhotoPickerHeight ? originalPhotoPickerHeight : height
        //            }
        //
        //        }
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
