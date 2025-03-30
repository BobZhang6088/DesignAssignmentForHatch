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
    @State var toolbarOpacity: CGFloat = 0
    @State var toolbarHeight: CGFloat = 0
    
    let originalHeight: CGFloat = UIScreen.main.bounds.height * 0.4
    @State var lastHeight = UIScreen.main.bounds.height * 0.4
    let maxHeight: CGFloat = UIScreen.main.bounds.height - 88 - UIApplication.shared.statusBarHeight
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .top) {
                HStack {
                    Button("Clear") {
                        selectedAssets.removeAll()
                        dismiss()
                    }
                    .fontWeight(.semibold)
                    Spacer()
                    Button("Done") {
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
                .padding(.horizontal)
                .frame(height: toolbarHeight)
                .opacity(Double(toolbarOpacity))
                Capsule()
                    .frame(width: 40, height: 6)
                    .foregroundColor(.gray)
                    .padding(8)
            }
            .background(Color(.systemGray6))
            .clipShape(RoundedCorner(radius: 20 * toolbarOpacity, corners: [.topLeft, .topRight]))

            
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
                .background(Color(.systemGray6))
        }
        .frame(height:realHeight)
        .contentShape(Rectangle())
        .simultaneousGesture(
            DragGesture(coordinateSpace: .global)
                .onChanged { value in
                    print(value.translation)
                    realHeight = min(max(lastHeight - value.translation.height,0), maxHeight)
                    height = min(realHeight,originalHeight)
                }
                .onEnded { _ in
                    withAnimation {
                        if realHeight < originalHeight * 0.5 {
                            dismiss()
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

            , isEnabled: true)
        .onChange(of: realHeight) { oldValue, newValue in
            var opacity = (realHeight - (maxHeight - 150)) / 150
            opacity = max(0, min(1, opacity))
            
            // 控制高度
            let maxHeight: CGFloat = 64
            let minHeight: CGFloat = 0
            let dynamicHeight = minHeight + (maxHeight - minHeight) * opacity
            
            withAnimation {
                toolbarOpacity = opacity
                toolbarHeight = dynamicHeight
            }
        }
    }
    
    func dismiss() {
        realHeight = 0
        height = 0
        presenting = false
        expanded = false
    }
}

#Preview {
//    PhotoPickerWrapper()
}
