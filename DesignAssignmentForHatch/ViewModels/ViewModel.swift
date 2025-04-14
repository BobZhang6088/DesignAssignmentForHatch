//
//  Geometry.swift
//  DesignAssignmentForHatch
//
//  Created by Bob Zhang on 2025-04-08.
//

import SwiftUI
import Combine


class ViewModel: ObservableObject {
    var safeAreaInsets: UIEdgeInsets {
        UIApplication.shared.safeAreaInsets
    }
    
    @Published var rootSize: CGSize = .zero
    @Published var keyboardHeight: CGFloat = 0
    
    @Published var inputViewFocused:Bool = false
    @Published var presentingImagePicker: Bool = false
    @Published var inputViewBottomPadding: CGFloat = 0
    @Published var inputViewExpanded: Bool = false
    @Published var inputDragOffsetY: CGFloat = 0
    @Published var inputViewDragging: Bool = false
    var lastInputViewBottomPadding: CGFloat = 0
    var estimatedKeyboradHeight: CGFloat = 336
    var inputViewDragble = false
    let photoPickerFixedHeight: CGFloat = UIScreen.main.bounds.height * 0.4
    var photoPickerMaxHeight: CGFloat {
        return rootSize.height - safeAreaInsets.top
    }
    
    @Published var imagePickerExpanded: Bool = false
    @Published var photoPickerHeight: CGFloat = 0


    
    private var cancellableSet: Set<AnyCancellable> = []

    init() {
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
            .merge(with: NotificationCenter.default.publisher(for: UIResponder.keyboardWillChangeFrameNotification))
            .sink { notification in
                if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                    self.keyboardHeight = keyboardFrame.height
                    self.estimatedKeyboradHeight = keyboardFrame.height
                }
            }
            .store(in: &cancellableSet)

        NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
            .sink { _ in
                self.keyboardHeight = 0
            }
            .store(in: &cancellableSet)
        let combine3 = Publishers.CombineLatest3($inputViewFocused, $presentingImagePicker, $keyboardHeight)
        let combine2 = Publishers.CombineLatest($inputDragOffsetY, $inputViewDragging)
        $inputViewDragging
            .scan((nil, nil)) { previous, newValue in
                (previous.1, newValue) // (old, new)
            }
            .sink { oldValue, newValue in
                if oldValue == false && newValue == true {
                    self.lastInputViewBottomPadding = self.inputViewBottomPadding
                    if (self.inputViewFocused && !self.inputViewExpanded) || (!self.inputViewFocused && !self.presentingImagePicker && !self.inputViewExpanded) {
                        self.inputViewDragble = true
                    } else {
                        self.inputViewDragble = false
                    }
                }
                if oldValue == true && newValue == false {
                    self.inputViewDragble = false
                    if !self.inputViewFocused && !self.presentingImagePicker && !self.inputViewExpanded{
                        if self.inputViewBottomPadding > self.estimatedKeyboradHeight/2 {
                            self.inputViewFocused = true
                        }
                    }
                }
            }
            .store(in: &cancellableSet)
        Publishers.CombineLatest(combine3, combine2)
            .map { a ,b in
                let (inputViewFocused, presentingImagePicker, keyboardHeight) = a
                let (inputDragOffsetY, inputViewDragging) = b
                if inputViewDragging {
                    if self.inputViewDragble {
                        if inputViewFocused && !self.inputViewExpanded {
                            if inputDragOffsetY > 0 {
                                self.inputViewFocused = false
                            }
                        }
                        let newPadding = self.lastInputViewBottomPadding - inputDragOffsetY
                        return max(min(newPadding, self.estimatedKeyboradHeight), self.safeAreaInsets.bottom)
                    }
                    return self.lastInputViewBottomPadding
                } else {
                    if inputViewFocused {
                        print("inputViewBottomPadding", keyboardHeight)
                        return keyboardHeight
                    } else if presentingImagePicker {
                        print("inputViewBottomPadding", self.photoPickerFixedHeight)
                        return self.photoPickerFixedHeight
                    } else {
                        print("inputViewBottomPadding", 0)
                        return self.safeAreaInsets.bottom
                    }
                }
                
            }
            .debounce(for: .milliseconds(inputViewDragging ? 0: 10), scheduler: RunLoop.main)
            .assign(to: \.inputViewBottomPadding, on: self)
            .store(in: &cancellableSet)
        
        
        
    }
}
