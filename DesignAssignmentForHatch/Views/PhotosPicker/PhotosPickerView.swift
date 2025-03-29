//
//  PhotosPickerView.swift
//  DesignAssignmentForHatch
//
//  Created by Bob Zhang on 2025-03-28.
//

import SwiftUI
import Photos

struct PhotosPickerView: View {
    @StateObject var viewModel = PhotoLibraryViewModel()

    let maxSelection: Int
    @Binding var selectedAssets: [PHAsset]
    let onSelection: ([PHAsset]) -> Void

    @State var showAlert = false
//    @State private var selectedImages: [UIImage] = []
    

    let columns = Array(repeating: GridItem(.flexible(), spacing: 4), count: 3)


    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVGrid(columns: columns, spacing: 4) {
                ForEach(viewModel.assets, id: \.localIdentifier) { asset in
                    PhotoGridItem(asset: asset,
                                  isSelected: selectedAssets.contains(where: {$0.localIdentifier == asset.localIdentifier}),
                                  onTap: {
                        toggleSelection(asset: asset)
                    })
                }
            }
            .padding(4)
        }
        .alert("Please select no more than \(maxSelection) photos.", isPresented: $showAlert) {} message: {}
    }
    private func toggleSelection(asset: PHAsset) {
        if selectedAssets.contains(where: {$0.localIdentifier == asset.localIdentifier}) {
            selectedAssets.removeAll { $0.localIdentifier == asset.localIdentifier }
        } else if selectedAssets.count < maxSelection {
            selectedAssets.append(asset)
        } else {
            showAlert = true
        }
        onSelection(selectedAssets)
    }

//    private func fetchSelectedImages() {
//        let manager = PHImageManager.default()
//        let targetSize = CGSize(width: 800, height: 800)
//
//        let options = PHImageRequestOptions()
//        options.deliveryMode = .highQualityFormat
//        options.isSynchronous = false
//
//        var images: [UIImage] = []
//        let group = DispatchGroup()
//
//        for asset in selectedAssets {
//            group.enter()
//            manager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFill, options: options) { image, _ in
//                if let img = image {
//                    images.append(img)
//                }
//                group.leave()
//            }
//        }
//
//        group.notify(queue: .main) {
//            onSelectionDone(images)
//        }
//    }
}

