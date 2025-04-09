//
//  ContentView.swift
//  DesignAssignmentForHatch
//
//  Created by Bob Zhang on 2025-03-26.
//

import SwiftUI
import Photos

//let inputViewFixedHeight: CGFloat = 154

struct ContentView: View {
    @State var inputViewTopY: CGFloat = 0
    @State var imagePickerExpanded: Bool = false
    @State private var shouldAnimateInputViewTopY = false
    @StateObject private var viewModel = ViewModel()
    
    let rootCoordinateSpace = "rootCoordinateSpace"
    @State var inputViewFrame = CGRect.zero
    @State var photoPickerHeight: CGFloat = 0
    
    @FocusState var inputViewFocused
    
    @State var selectedImages: [PHAsset] = []
    
    let photoPickerFixedHeight: CGFloat = UIScreen.main.bounds.height * 0.4
    
    @GestureState private var inputDragOffsetY: CGFloat = .zero
    @State private var lastHeightOfInputView: CGFloat = .zero
    @State private var inputViewDragging: Bool = false

    @GestureState private var photoPickerDragOffsetY: CGFloat = .zero
    @State private var lastHeightOfPhotoPicker: CGFloat = .zero
    @State private var photoPickerDragging: Bool = false

    var inputViewFixedHeight: CGFloat {
        return 154 + (selectedImages.count > 0 ? 75 : 0)
    }
    
    
    var inputViewHeight: CGFloat {
//        let inputViewFixedHeight:CGFloat = 154 + (selectedImages.count > 0 ? 75 : 0)
//        if inputViewDragging {
//            if inputViewExpanded {
//                let newHeight = inputViewMaxHeight - inputDragOffsetY
//                return max(min(newHeight, inputViewMaxHeight),inputViewFixedHeight)
//            } else {
//                let newHeight = inputViewFixedHeight - inputDragOffsetY
//                return max(min(newHeight, inputViewMaxHeight),inputViewFixedHeight)
//            }
//        } else {
//            
//        }
        if viewModel.inputViewExpanded {
            return inputViewMaxHeight
        } else {
            return inputViewFixedHeight
        }
    }
    
//    var inputViewBottomPadding: CGFloat {
//        if inputViewFocused {
//            print("inputViewBottomPadding",geometryObj.keyboardHeight)
//            return geometryObj.keyboardHeight
//        } else if presentingImagePicker {
//            print("inputViewBottomPadding",photoPickerFixedHeight)
//            return photoPickerFixedHeight
//        } else {
//            print("inputViewBottomPadding",0)
//            return 0
//        }
//    }
    
    var inputViewMaxHeight: CGFloat {
        viewModel.rootSize.height - viewModel.inputViewBottomPadding - viewModel.safeAreaInsets.top
    }
    
    
//    func updateInputViewBottomPadding() {
//        if inputViewFocused {
//            print("inputViewBottomPadding",geometryObj.keyboardHeight)
//            inputViewBottomPadding = geometryObj.keyboardHeight
//        } else if presentingImagePicker {
//            print("inputViewBottomPadding",photoPickerFixedHeight)
//            inputViewBottomPadding = photoPickerFixedHeight
//        } else {
//            print("inputViewBottomPadding",0)
//            inputViewBottomPadding = 0
//        }
//    }
    var VStackOffsetY: CGFloat {
        -viewModel.inputViewBottomPadding - min(inputViewHeight, inputViewFixedHeight)
    }
    
    var body: some View {
        GeometryReader { geometry in
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
                }
                .offset(x: 0, y:VStackOffsetY)
                .animation(.easeIn(duration: 0.25), value: VStackOffsetY)
                .background(Color(.systemGray6))
                .navigationTitle("Chat")
                .navigationBarTitleDisplayMode(.inline)
                .ignoresSafeArea()
            }
            .overlay {
                if viewModel.inputViewExpanded || imagePickerExpanded {
                    Color.black.opacity(0.5).ignoresSafeArea()
                }
            }
            .overlay(alignment:.bottom) {
                Color(.systemGray6)
                    .frame(height: viewModel.inputViewBottomPadding + inputViewHeight - 30)// for corner radius
                    .animation(.easeIn(duration: 0.25), value: inputViewHeight)
                    .animation(.easeIn(duration: 0.25), value: viewModel.inputViewBottomPadding)
            }
            .overlay(alignment:.bottom) {
                InputDrawer(expanded: $viewModel.inputViewExpanded ,presentingImagePicker: $viewModel.presentingImagePicker, selectedImages: $selectedImages,onPhotoPickerButtonTapped: {
                    viewModel.presentingImagePicker.toggle()
                    inputViewFocused = !viewModel.presentingImagePicker
                })
                    .focused($inputViewFocused)
                    .onChange(of: inputViewFocused, { oldValue, newValue in
                        viewModel.inputViewFocused = newValue
                    })
                    .onGeometryChange(for: CGRect.self) { proxy in
                        proxy.frame(in: .named(rootCoordinateSpace))
                    } action: { newValue in
                        inputViewFrame = newValue
                    }
                    .frame(height: inputViewHeight)
                    .gesture(
                        DragGesture(coordinateSpace: .global)
                            .onChanged{ value in
                                viewModel.inputViewDragging = true
                                viewModel.inputDragOffsetY = value.translation.height
                            }
                            .onEnded { value in
                                viewModel.inputViewDragging = false
                            }
                    )
//                    .gesture(
//                        DragGesture(coordinateSpace: .global)
//                            .onChanged({ value in
//                                if !inputViewFocused && !geometryObj.presentingImagePicker && !inputViewExpanded{
//                                    if value.translation.height < 0 {
//                                        inputViewFocused = true
//                                        return
//                                    }
//                                }
//                                if inputViewFocused && !inputViewExpanded {
//                                    if value.translation.height > 0 {
//                                        inputViewFocused = false
//                                        return
//                                    }
//                                }
//                            })
//                            .updating($inputDragOffsetY, body: { value, state, tran in
//                                state = value.translation.height
//                                inputViewDragging = true
//                            })
//                            .onEnded({ value in
//                                if inputViewExpanded {
//                                    let newHeight = inputViewMaxHeight - value.translation.height
//                                    if newHeight < inputViewMaxHeight - 30 {
//                                        inputViewExpanded = false
//                                    }
//                                } else {
//                                    let newHeight = inputViewFixedHeight - value.translation.height
//                                    if newHeight > inputViewFixedHeight + 100 {
//                                        inputViewExpanded = true
//                                    }
//                                }
//                                inputViewDragging = false
//                                
//                            })
//                    )
//                    .gesture(DragGesture(coordinateSpace: .global)
//                        .onChanged{value in
//                            if !inputViewDragging {
//                                lastHeightOfInputView = inputViewHeight
//                            }
//                            inputViewDragging = true
//                            let drageHeight = lastHeightOfInputView - value.translation.height
//                            if !inputViewFocused && !presentingImagePicker && !inputViewExpanded{
//                                if value.translation.height < 0 {
//                                    inputViewFocused = true
//                                    return
//                                }
//                            }
//                            if inputViewFocused && !inputViewExpanded {
//                                if value.translation.height > 0 {
//                                    inputViewFocused = false
//                                    return
//                                }
//                            }
//                            inputViewHeight = min(max(inputViewFixedHeight, drageHeight), inputViewMaxHeight)
//                            
//                        }
//                        .onEnded { value in
//                            inputViewDragging = false
//                            if inputViewHeight - inputViewFixedHeight < (inputViewMaxHeight - inputViewFixedHeight) / 2 {
//                                inputViewHeight = inputViewFixedHeight
//                                inputViewExpanded = false
//                            } else {
//                                inputViewHeight = inputViewMaxHeight
//                                inputViewExpanded = true
//                            }
//                        })
                    .onReceive(viewModel.$inputViewFocused, perform: { value in
                        inputViewFocused = value
                    })
                    .padding(.bottom, viewModel.inputViewBottomPadding)
                    .animation(.easeIn(duration: 0.25), value: inputViewHeight)
                    .animation(.easeIn(duration: 0.25), value: viewModel.inputViewBottomPadding)
//                    .offset(x:0, y:-inputViewBottomPadding)
//                    .ignoresSafeArea()
            }
            .overlay(alignment:.bottom) {
                if viewModel.presentingImagePicker {
                    PhotoPickerWrapper(presenting: $viewModel.presentingImagePicker, expanded: $imagePickerExpanded, height: $photoPickerHeight, selectedAssets: $selectedImages, onSelection: { images in
                        if imagePickerExpanded {
                            
                        } else {
                            viewModel.presentingImagePicker = false
                            inputViewFocused = true
                        }
                    })
                    .environmentObject(viewModel)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
            .animation(.easeIn(duration: 0.25), value: viewModel.presentingImagePicker)
            .coordinateSpace(.named(rootCoordinateSpace))
            .onGeometryChange(for: CGSize.self, of: { proxy in
                proxy.size
            }, action: { newValue in
                viewModel.rootSize = newValue
                print(newValue)
            })
            .ignoresSafeArea()
        }
        .onGeometryChange(for: EdgeInsets.self, of: { proxy in
            proxy.safeAreaInsets
        }, action: { newValue in
            print(newValue)
//            geometryObj.safeAreaInsets = newValue
        })
        .onChange(of: inputViewFocused, { oldValue, newValue in
            if newValue {
                viewModel.presentingImagePicker = false
            }
        })
        .onChange(of: viewModel.inputViewExpanded) { _, newValue in
            if newValue {
                inputViewFocused = true
            }
        }
        .ignoresSafeArea()
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
