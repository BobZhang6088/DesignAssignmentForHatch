//
//  PhotoPickerWrapper.swift
//  DesignAssignmentForHatch
//
//  Created by Bob Zhang on 2025-03-28.
//

import SwiftUI
import Photos

struct PhotoPickerWrapper: View {
    @Binding var presenting: Bool
    @Binding var expanded: Bool
    @Binding var height: CGFloat
    @Binding var selectedAssets: [PHAsset]
    let onSelection: ([PHAsset]) -> Void
    
    @State var realHeight: CGFloat = UIScreen.main.bounds.height * 0.4
    @State var enableHighPriorityGesture: Bool = true
    
    let originalHeight: CGFloat = UIScreen.main.bounds.height * 0.4
    @State var lastHeight = UIScreen.main.bounds.height * 0.4
    let maxHeight: CGFloat = UIScreen.main.bounds.height - 88 - UIApplication.shared.statusBarHeight
    
    var body: some View {
        VStack {
            Capsule()
                .frame(width: 40, height: 6)
                .foregroundColor(.gray)
                .padding(8)
            PhotosPickerView(maxSelection: 9, selectedAssets: $selectedAssets, onSelection: onSelection)
            .onScrollGeometryChange(for: CGFloat.self) { geometry in
                geometry.contentOffset.y
            } action: { oldValue, newValue in
                if oldValue != newValue {
                    if expanded {
                        if newValue < 0 {enableHighPriorityGesture = true}
                    } else {
                        enableHighPriorityGesture = true
                    }
                }
            }
            .onAppear {
                height = originalHeight
            }
        }
        .frame(height:realHeight)
        .highPriorityGesture(
            DragGesture(coordinateSpace: .global)
                .onChanged { value in
                    print(value.translation)
                    realHeight = min(max(lastHeight - value.translation.height,0), maxHeight)
                    height = min(realHeight,originalHeight)
                }
                .onEnded { _ in
                    withAnimation {
                        if realHeight < originalHeight * 0.5 {
                            realHeight = 0
                            height = 0
                            presenting = false
                            expanded = false
                            enableHighPriorityGesture = false
                        } else if realHeight > originalHeight * 1.5 {
                            realHeight = maxHeight
                            height = originalHeight
                            expanded = true
                            enableHighPriorityGesture = false
                        } else {
                            realHeight = originalHeight
                            height = originalHeight
                            expanded = false
                            enableHighPriorityGesture = true
                        }
                    }
                    lastHeight = realHeight
                }
            ,isEnabled: enableHighPriorityGesture
        )
    }
}

#Preview {
//    PhotoPickerWrapper()
}
