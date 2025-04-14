//
//  InputDrawer.swift
//  DesignAssignmentForHatch
//
//  Created by Bob Zhang on 2025-04-08.
//

import SwiftUI
import Photos

struct InputDrawer: View {
    @Binding var expanded: Bool
    @Binding var presentingImagePicker: Bool
    @Binding var selectedImages: [PHAsset]
    var onPhotoPickerButtonTapped: () -> Void = { }
    @State var message: String = ""
    var body: some View {
        VStack {
            HStack(alignment: .top) {
                TextInputView(text: $message, expanded: $expanded, placeholder: "Start Typing...")
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
                
            }
            .padding()

            if !selectedImages.isEmpty {
                SelectedImagesView(images: $selectedImages)
                    .transition(.opacity)
            }
            HStack {
                Button(action: {
                    onPhotoPickerButtonTapped()
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
        }
        .background(Color(.systemGray6))
        .clipShape(RoundedCorner(radius: 20, corners: [.topLeft, .topRight]))
        .background(alignment: .top) {
            RoundedCorner(radius: 20, corners: [.topLeft, .topRight])
                .fill(Color(.systemGray6))
                .frame(height: 30)
                .shadow(color:.black.opacity(0.1), radius: 3, x: 0, y: -4)
        }
    }
}

#Preview {
//    InputDrawer()
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
