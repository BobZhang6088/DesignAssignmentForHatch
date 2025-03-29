//
//  SelectedImagesViews.swift
//  DesignAssignmentForHatch
//
//  Created by Bob Zhang on 2025-03-28.
//

import SwiftUI
import Photos

struct ImageItem: Identifiable, Equatable {
    let id = UUID()
    let image: PHAsset
}

struct SelectedImagesViews: View {
    @Binding var images: [PHAsset]
    let itemSize:CGFloat = 50
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHGrid(rows: [GridItem(.fixed(itemSize))], spacing: 10) {
                ForEach(images, id: \.localIdentifier) { item in
//                    SelectedGridItem(asset: item, onDelete: {
//                        
//                    })
                    SelectedGridItem(asset: item) {
                        images.removeAll { $0.localIdentifier == item.localIdentifier }
                    }
                }
            }
            .frame(height:itemSize + 15)
            .padding(.horizontal, 10)
        }
    }
}

struct SelectedGridItem: View {
    let asset: PHAsset
    @State private var thumbnail: UIImage?
    var onDelete: (() -> Void)? = nil
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(maxWidth: .infinity)
                .aspectRatio(1, contentMode: .fill)
                .overlay {
                    if let thumbnail = thumbnail {
                        Image(uiImage: thumbnail)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    }
                }
                .clipped()
            Button(action: {
                onDelete?()
            }) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.red)
                    .clipShape(Circle())
            }
            .offset(x: 6, y: -6)

//            if isSelected {
//                Image(systemName: "checkmark.circle.fill")
//                    .foregroundColor(.blue)
//                    .padding(5)
//            }
        }
        .contentShape(Rectangle())
        .onAppear {
            PHImageManager.default().requestImage(for: asset, targetSize: CGSize(width: 80, height: 80),
                                                  contentMode: .aspectFill, options: nil) { image, _ in
                self.thumbnail = image
            }
        }
//        .onTapGesture {
//            onTap()
//        }
    }
}



