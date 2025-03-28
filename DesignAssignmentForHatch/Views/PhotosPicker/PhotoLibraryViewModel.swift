//
//  PhotoLibraryViewModel.swift
//  DesignAssignmentForHatch
//
//  Created by Bob Zhang on 2025-03-27.
//

import Photos
import SwiftUI

class PhotoLibraryViewModel: ObservableObject {
    @Published var assets: [PHAsset] = []

    init() {
        fetchPhotos()
    }

    func fetchPhotos() {
        PHPhotoLibrary.requestAuthorization { status in
            if status == .authorized || status == .limited {
                let fetchOptions = PHFetchOptions()
                fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
                let result = PHAsset.fetchAssets(with: .image, options: fetchOptions)

                DispatchQueue.main.async {
                    self.assets = (0..<result.count).map { result.object(at: $0) }
                }
            }
        }
    }

    func requestImage(for asset: PHAsset, targetSize: CGSize, completion: @escaping (UIImage?) -> Void) {
        let manager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.isSynchronous = false
        options.deliveryMode = .highQualityFormat

        manager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFill, options: options) { image, _ in
            completion(image)
        }
    }
}
