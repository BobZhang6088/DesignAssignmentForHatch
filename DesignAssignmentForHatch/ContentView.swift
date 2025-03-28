//
//  ContentView.swift
//  DesignAssignmentForHatch
//
//  Created by Bob Zhang on 2025-03-26.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ViewModel()
    @FocusState var inputViewFocused: Bool
    @State private var selectedImages: [UIImage] = []
    @State private var pickerHeight: CGFloat = .zero
    let originalPhotoPickerHeight = UIScreen.main.bounds.height * 0.5
    var body: some View {
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
                
                // Text input area
                
                VStack {
                    HStack(alignment: .top) {
                        TextInputView(text: $viewModel.message, placeholder: "Start Typing...")
                            .focused($inputViewFocused)
                            .gesture(
                                DragGesture(coordinateSpace: .global)
                                    .onChanged { gesture in
                                        print(gesture.startLocation)
                                        if gesture.translation.height > 20 && inputViewFocused {
                                            inputViewFocused = false
                                        }
                                        if gesture.translation.height < -20 && !inputViewFocused{
                                            inputViewFocused = true
                                        }
                                    }
                                    .onEnded { _ in
                                        viewModel.bottomPadding = 0
                                    }
                            )
                        Button(action: {
                            viewModel.showInputSheet = true
                        }) {
                            Image(systemName: "arrow.up.backward.and.arrow.down.forward")
                        }
                        .padding(.horizontal, 10)
                        
                    }.padding()
                    
                    HStack {
                        Button(action: {
                            viewModel.showPicker = true
                            viewModel.photoPickerHeight = UIScreen.main.bounds.height * 0.4
                        }) {
                            Image(systemName: "photo.artframe.circle")
                                .padding(.vertical, 5)
                                .font(.system(size: 30))
                        }
                        
                        Spacer()
                        
                        Button(action: {
                        }) {
                            Image(systemName: "paperplane.circle")
                                .padding(.vertical,5)
                                .font(.system(size: 30))
                        }
                    }
                    .padding(.horizontal)
                    
                }
                .background(Color(.systemGray6))
                
                .clipShape(RoundedCorner(radius: 20, corners: [.topLeft, .topRight]))
                .background(alignment: .top) {
                    RoundedCorner(radius: 20, corners: [.topLeft, .topRight])
                        .fill(Color(.systemGray6))
                        .frame(height: 30)
                        .shadow(color:.black.opacity(0.1), radius: 3, x: 0, y: -4)
                }
            }
            .background(Color(.systemGray6))
            .navigationTitle("Chat")
            .navigationBarTitleDisplayMode(.inline)
        }
        .padding(.bottom, viewModel.showPicker ? pickerHeight : 0)
        .animation(.default, value: viewModel.showPicker)
        .sheet(isPresented: $viewModel.showPicker) {
            CustomPhotosPicker(maxSelection: 5) { images in
                selectedImages = images
            }
            .presentationDetents([.height(originalPhotoPickerHeight), .large])
            .presentationDragIndicator(.visible)
            .presentationBackgroundInteraction(.enabled)
            .onPreferenceChange(ViewPositionKey.self) { newValue in
                let height = UIScreen.main.bounds.height - newValue.origin.y - 34
                pickerHeight = height > originalPhotoPickerHeight ? originalPhotoPickerHeight : height                
            }

        }
        .sheet(isPresented: $viewModel.showInputSheet) {
            InputSheet(text: $viewModel.message, placeholder: "Start Typing...")
                .background(Color(.systemGray6))
            
        }
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
