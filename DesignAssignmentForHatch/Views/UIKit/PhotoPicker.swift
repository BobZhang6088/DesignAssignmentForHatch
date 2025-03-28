//
//  PhotoPicker.swift
//  DesignAssignmentForHatch
//
//  Created by Bob Zhang on 2025-03-27.
//
import SwiftUI
import PhotosUI

struct PhotoPicker: UIViewControllerRepresentable {
    // Binding to pass the selected image back to your SwiftUI view.
    @Binding var selectedImage: UIImage?

    // Create and configure the PHPickerViewController.
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images        // Only images
        configuration.selectionLimit = 1      // Limit selection to 1

        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator // Set the delegate to our coordinator.
        return picker
    }

    // No dynamic updates needed here.
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) { }

    // Create the Coordinator to handle picker delegate callbacks.
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    // Coordinator acts as the PHPickerViewController delegate.
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        var parent: PhotoPicker

        init(_ parent: PhotoPicker) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            // Dismiss the picker.
            picker.dismiss(animated: true)
            
            // If there's no result or the selected asset can't load an image, exit.
            guard let provider = results.first?.itemProvider,
                  provider.canLoadObject(ofClass: UIImage.self) else { return }
            
            // Load the selected image.
            provider.loadObject(ofClass: UIImage.self) { image, error in
                if let image = image as? UIImage {
                    DispatchQueue.main.async {
                        self.parent.selectedImage = image
                    }
                }
            }
        }
    }
}
