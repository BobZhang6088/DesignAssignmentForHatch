//
//  InputSheet.swift
//  DesignAssignmentForHatch
//
//  Created by Bob Zhang on 2025-03-27.
//

import SwiftUI
import Photos

struct InputSheet: View {
    
    //    @State var photoPlaceholderHeight: CGFloat = 0
    
    @Binding var expanded: Bool
    @Binding var imagePickerExpanded: Bool
    var onTopYChange: ((CGFloat) -> Void)?

    
    @StateObject private var keyboard = KeyboardResponder()
    @State var message: String = ""
    @FocusState var inputViewFocused
    @State var photoPickerHeight: CGFloat = 0
    @State var presentingImagePicker: Bool = false
    var bottomPadding: CGFloat {
        if inputViewFocused {
            return keyboard.keyboardHeight == 0 ? 0 : keyboard.keyboardHeight - 34
        } else if presentingImagePicker {
            return photoPickerHeight
        } else {
            return 0
        }
    }

    @State var selectedImages: [PHAsset] = []
    var body: some View {
        ZStack(alignment: .bottom) {
            Color(.systemGray6)
                .frame(height: bottomPadding )
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
                        withAnimation {
                            expanded.toggle()
                        }
                    }) {
                        if expanded {
                            Image(systemName: "arrow.down.right.and.arrow.up.left")
                        } else {
                            Image(systemName: "arrow.up.backward.and.arrow.down.forward")
                        }
                    }
                    .padding(.horizontal, 10)
                    
                }
                .padding()
                .onGeometryChange(for: CGFloat.self) { geo in
                    geo.frame(in: .global).origin.y
                } action: { newValue in
                    onTopYChange?(newValue)
                }

                if !selectedImages.isEmpty {
                    SelectedImagesViews(images: $selectedImages)
                }
                HStack {
                    Button(action: {
                        presentingImagePicker.toggle()
                    }) {
                        Image(systemName: "photo.artframe.circle")
                            .padding(.vertical, 5)
                            .font(.system(size: 30))
                    }
                    .contentShape(Rectangle())
                    
                    Spacer()
                    
                    Button(action: {
                    }) {
                        Image(systemName: "paperplane.circle")
                            .padding(.vertical,5)
                            .font(.system(size: 30))
                    }
                    
                }
                .padding(.horizontal)
//                Color.clear
//                    .frame(height:(presentingImagePicker ? photoPickerHeight : 0))
//                    .animation(.easeIn, value: photoPickerHeight)
                //                        .transition(.move(edge: .bottom).combined(with: .opacity))
                //                        .animation(.easeInOut(duration: 0.3), value: presentingImagePicker)
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
            .onChange(of: expanded) { _, newValue in
                inputViewFocused = true
            }
            .onChange(of: presentingImagePicker) { _,  newValue in
                if newValue {
                    inputViewFocused = false
                } else if expanded {
                    inputViewFocused = true
                }
            }
            .onChange(of: inputViewFocused) { _, newValue in
                if newValue {
                    presentingImagePicker = false
                }
            }
            .padding(.bottom, bottomPadding)
            .animation(.default, value: bottomPadding)
            if presentingImagePicker {
                PhotoPickerWrapper(presenting: $presentingImagePicker, expanded: $imagePickerExpanded, height: $photoPickerHeight, selectedAssets: $selectedImages, onSelection: { images in
                    if imagePickerExpanded {
                        
                    } else {
                        presentingImagePicker = false
                        inputViewFocused = true
                    }
                })
                //                .frame(alignment: .top)
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .animation(.default, value: presentingImagePicker)
            }
        }
        .animation(.default, value: presentingImagePicker)
    }
    
//    func updatePadding() {
//        withAnimation(.easeInOut(duration: 0.3)) {
//            if inputViewFocused {
//                bottomPadding = keyboard.keyboardHeight == 0 ? 0 : keyboard.keyboardHeight - 34
//            } else if presentingImagePicker {
//                bottomPadding = photoPickerHeight
//            } else {
//                bottomPadding = 0
//            }
//        }
//    }
}

#Preview {
    InputSheet(expanded: .constant(false), imagePickerExpanded: .constant(false))
}


struct NoAnimationButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            // 不添加 scaleEffect 或 opacity 改变
            // 保持静态样式
    }
}
