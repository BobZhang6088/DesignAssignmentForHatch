//
//  ContentView.swift
//  DesignAssignmentForHatch
//
//  Created by Bob Zhang on 2025-03-26.
//

import SwiftUI
import Photos

struct ContentView: View {
    let rootCoordinateSpace = "rootCoordinateSpace"

    @StateObject private var viewModel = ViewModel()
    @FocusState var inputViewFocused
    @State var selectedImages: [PHAsset] = []
    
    var inputViewFixedHeight: CGFloat {
        return 154 + (selectedImages.count > 0 ? 75 : 0)
    }
    
    var inputViewHeight: CGFloat {
        if viewModel.inputViewExpanded {
            return inputViewMaxHeight
        } else {
            return inputViewFixedHeight
        }
    }
    
    var inputViewMaxHeight: CGFloat {
        viewModel.rootSize.height - viewModel.inputViewBottomPadding - viewModel.safeAreaInsets.top
    }

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
                if viewModel.inputViewExpanded || viewModel.imagePickerExpanded {
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
                    .onReceive(viewModel.$inputViewFocused, perform: { value in
                        inputViewFocused = value
                    })
                    .padding(.bottom, viewModel.inputViewBottomPadding)
                    .animation(.easeIn(duration: 0.25), value: inputViewHeight)
                    .animation(.easeIn(duration: 0.25), value: viewModel.inputViewBottomPadding)
            }
            .overlay(alignment:.bottom) {
                if viewModel.presentingImagePicker {
                    PhotoPickerWrapper(presenting: $viewModel.presentingImagePicker, expanded: $viewModel.imagePickerExpanded, height: $viewModel.photoPickerHeight, selectedAssets: $selectedImages, onSelection: { images in
                        if viewModel.imagePickerExpanded {
                            
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



