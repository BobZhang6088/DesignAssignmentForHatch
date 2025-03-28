//
//  KeyboardResponder.swift
//  DesignAssignmentForHatch
//
//  Created by Bob Zhang on 2025-03-27.
//

import SwiftUI
import Combine

class ViewModel: ObservableObject {
    @Published var holdingKeyborad: Bool = false
    @Published var message: String = ""
    @Published var bottomPadding: CGFloat = 0
    @Published var keyboardHeight: CGFloat = 0
    @Published var showPicker = false
    @Published var selectedImage: UIImage?
    @Published var photoPickerHeight: CGFloat = 0
    
    var globalFrameOfTextInputView: CGRect = .zero
    private var cancellables: Set<AnyCancellable> = []

    init() {
//        NotificationCenter.Publisher(center: .default, name: UIResponder.keyboardWillShowNotification)
//            .merge(with: NotificationCenter.Publisher(center: .default, name: UIResponder.keyboardWillChangeFrameNotification))
//            .compactMap { notification -> CGFloat? in
//                if let frame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
//                    print(frame.height)
//                    return frame.height
//                }
//                return nil
//            }
//            .sink { height in
//                print("Keyboard height:", height)
//                // 你可以在这里做任意逻辑，比如：
////                self.keyboardHeight = height
////                self.bottomPadding = height - 20 // 举个例子
//            }
//            .store(in: &cancellables)
//
//        NotificationCenter.Publisher(center: .default, name: UIResponder.keyboardWillHideNotification)
//            .map { _ in CGFloat(0) }
//            .sink { height in
//                print("Keyboard height:", height)
//                // 你可以在这里做任意逻辑，比如：
////                if self.holdingKeyborad {
////                    self.keyboardHeight = height
////                }
////                self.bottomPadding = height - 20 // 举个例子
//            }
//            .store(in: &cancellables)
    }
}
