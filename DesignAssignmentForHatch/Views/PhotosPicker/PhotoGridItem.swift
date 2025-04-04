//
//  PhotoGridItem.swift
//  DesignAssignmentForHatch
//
//  Created by Bob Zhang on 2025-03-27.
//
import Photos
import SwiftUI
struct PhotoGridItem: View {
    let asset: PHAsset
    let isSelected: Bool
    let onTap: () -> Void

    @State private var thumbnail: UIImage?

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

            if isSelected {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.blue)
                    .padding(5)
            }
        }
        .onAppear {
            PHImageManager.default().requestImage(for: asset, targetSize: CGSize(width: 150, height: 150),
                                                  contentMode: .aspectFill, options: nil) { image, _ in
                self.thumbnail = image
            }
        }
        .contentShape(Rectangle()) 
        .onTapGesture {
            onTap()
        }
    }
}
