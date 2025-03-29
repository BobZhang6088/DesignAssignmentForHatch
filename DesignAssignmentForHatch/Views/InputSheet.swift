//
//  InputSheet.swift
//  DesignAssignmentForHatch
//
//  Created by Bob Zhang on 2025-03-27.
//

import SwiftUI
import Photos

struct InputSheet: View {
    @State var message: String = ""
    @FocusState var inputViewFocused
    @State var photoPickerHeight: CGFloat = 0
//    @State var photoPlaceholderHeight: CGFloat = 0

    @Binding var expanded: Bool
    @State var presentingImagePicker: Bool = false
    @Binding var imagePickerExpanded: Bool
    
    @State var selectedImages: [PHAsset] = []
    var body: some View {
//        ZStack {
            VStack {
                HStack(alignment: .top) {
                    TextInputView(text: $message, expanded: $expanded, placeholder: "Start Typing...")
                        .focused($inputViewFocused)
                        .gesture(
                            DragGesture(coordinateSpace: .global)
                                .onChanged { gesture in
                                    print(gesture.startLocation)
                                    if gesture.translation.height > 20 && inputViewFocused {
                                        inputViewFocused = false
                                        expanded = false
                                    }
                                    if gesture.translation.height < -20 && !inputViewFocused{
                                        inputViewFocused = true
                                    }
                                }
                                .onEnded { _ in
                                }
                        )
                    Button(action: {
                        expanded.toggle()
                    }) {
                        if expanded {
                            Image(systemName: "arrow.down.right.and.arrow.up.left")
                        } else {
                            Image(systemName: "arrow.up.backward.and.arrow.down.forward")
                        }
                    }
                    .padding(.horizontal, 10)
                    
                }.padding()
                if !selectedImages.isEmpty {
                    SelectedImagesViews(images: $selectedImages)
                }
                HStack {
                    Button(action: {
                        presentingImagePicker = true
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
                if presentingImagePicker {
                    Color.clear
                        .frame(height:photoPickerHeight)
//                        .transition(.move(edge: .bottom).combined(with: .opacity))
//                        .animation(.easeInOut(duration: 0.3), value: presentingImagePicker)
                }
            }
            .background(Color(.systemGray6))
            .clipShape(RoundedCorner(radius: 20, corners: [.topLeft, .topRight]))
            .background(alignment: .top) {
                RoundedCorner(radius: 20, corners: [.topLeft, .topRight])
                    .fill(Color(.systemGray6))
                    .frame(height: 30)
                    .shadow(color:.black.opacity(0.1), radius: 3, x: 0, y: -4)
            }
            .padding(.top, expanded ? 44: 0)
            .onChange(of: expanded) { newValue in
                inputViewFocused = true
            }
            .onChange(of: presentingImagePicker) { newValue in
                if newValue {
                    inputViewFocused = false
                }
            }
            .onChange(of: inputViewFocused) { newValue in
                if newValue {
                    presentingImagePicker = false
                }
            }
//            .padding(.bottom, 200)
//            .offset(CGSizeMake(0, -200))
            .overlay(alignment: .bottom) {
                if presentingImagePicker {
                    PhotoPickerWrapper(presenting: $presentingImagePicker, expanded: $imagePickerExpanded, height: $photoPickerHeight, selectedAssets: $selectedImages, onSelection: { images in
                        if imagePickerExpanded {

                        } else {
                            presentingImagePicker = false
                            inputViewFocused = true
                        }
                    })
                        .background(Color(.systemGray6))
                        .frame(alignment: .top)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        .animation(.easeInOut(duration: 0.2), value: presentingImagePicker)
//                }
                    
            }
            
            
            
        }
        
    }
}

#Preview {
    InputSheet(expanded: .constant(false), imagePickerExpanded: .constant(false))
}


