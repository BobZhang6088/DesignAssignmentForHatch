//
//  CustomPhotosPicker.swift
//  DesignAssignmentForHatch
//
//  Created by Bob Zhang on 2025-03-27.
//

import SwiftUI
import Photos

struct CustomPhotosPicker: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel = PhotoLibraryViewModel()

    let maxSelection: Int
    let onSelectionDone: ([UIImage]) -> Void

    @State private var selectedAssets: [PHAsset] = []
    @State private var selectedImages: [UIImage] = []
    
    @State var toolbarOpacity: CGFloat = 0
    @State var toolbarHeight: CGFloat = 0

    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .top) {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 4) {
                        ForEach(viewModel.assets, id: \.localIdentifier) { asset in
                            PhotoGridItem(asset: asset,
                                          isSelected: selectedAssets.contains(asset),
                                          onTap: {
                                toggleSelection(asset: asset)
                            })
                        }
                    }
                    .padding(4)
                }
                .padding(.top, toolbarHeight)
                
                // ✅ 自定义 Toolbar
                VStack(spacing: 0) {
                    Color.white
                        .opacity(Double(toolbarOpacity))
                        .frame(height: toolbarHeight)
                        .overlay(
                            HStack {
                                Button("cancel") {
                                    presentationMode.wrappedValue.dismiss()
                                }
                                Spacer()
//                                Text("选择照片")
//                                    .font(.headline)
//                                Spacer()
                                Button("done") {
                                    fetchSelectedImages()
                                }
                            }
//                                .padding(.top, UIApplication. shared.windows.first?.safeAreaInsets.top ?? 44)
                                .padding(.horizontal)
                                .opacity(Double(toolbarOpacity))
                        )
                        .background(.ultraThinMaterial)
                        .ignoresSafeArea(edges: .top)
                }
            }
            .preference(key: ViewPositionKey.self, value: geo.frame(in: .global))
        }
        .onPreferenceChange(ViewPositionKey.self) { newValue in
            // 控制透明度
            var opacity = (UIScreen.main.bounds.height * 0.3 - newValue.origin.y) / 30
            opacity = max(0, min(1, opacity))
            
            // 控制高度
            let maxHeight: CGFloat = 64
            let minHeight: CGFloat = 0
            let dynamicHeight = minHeight + (maxHeight - minHeight) * opacity
            
            withAnimation(.easeInOut(duration: 0.2)) {
                toolbarOpacity = opacity
                toolbarHeight = dynamicHeight
            }
        }
    }

    private func toggleSelection(asset: PHAsset) {
        if selectedAssets.contains(asset) {
            selectedAssets.removeAll { $0 == asset }
        } else if selectedAssets.count < maxSelection {
            selectedAssets.append(asset)
        }
    }

    private func fetchSelectedImages() {
        let manager = PHImageManager.default()
        let targetSize = CGSize(width: 800, height: 800)

        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat
        options.isSynchronous = false

        var images: [UIImage] = []
        let group = DispatchGroup()

        for asset in selectedAssets {
            group.enter()
            manager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFill, options: options) { image, _ in
                if let img = image {
                    images.append(img)
                }
                group.leave()
            }
        }

        group.notify(queue: .main) {
            onSelectionDone(images)
            presentationMode.wrappedValue.dismiss()
        }
    }
}


struct ViewPositionKey: PreferenceKey {
    static var defaultValue: CGRect = .zero
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}
