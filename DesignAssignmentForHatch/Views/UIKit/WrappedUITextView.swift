//
//  WrappedUITextView.swift
//  DesignAssignmentForHatch
//
//  Created by Bob Zhang on 2025-03-26.
//

import SwiftUI
import UIKit

struct WrappedUITextView: UIViewRepresentable {
    @Binding var text: String
//    @Binding var lineCount: Int
    let fontSize: CGFloat
    
    var onTextChanged: ((_ deleting: Bool, _ textHeight: CGFloat) -> Void)?
    
    

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: fontSize)
        textView.isScrollEnabled = true
        textView.delegate = context.coordinator
        textView.backgroundColor = .clear
        if text != "" {
            textView.becomeFirstResponder()
        }
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        if uiView.text != text {
            uiView.text = text
        }
//        if text != "" {
//            uiView.becomeFirstResponder()
//        }
//        uiView.font = UIFont.systemFont(ofSize: fontSize)

        // Update line count after text changes
//        DispatchQueue.main.async {
//            context.coordinator.updateLineCount(textView: uiView)
//        }
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        var parent: WrappedUITextView
        var deleting: Bool = false
        init(parent: WrappedUITextView) {
            self.parent = parent
        }
        
        func textView(_ textView: UITextView,
                      shouldChangeTextIn range: NSRange,
                      replacementText text: String) -> Bool {
            if text.isEmpty && range.length > 0 {
                print("🗑 正在删除字符")
                
            } else {
                print("✍️ 正在输入字符: \(text)")
            }
            deleting = text.isEmpty && range.length > 0
            
            return true
        }
        
        func textViewDidChange(_ textView: UITextView) {
            parent.text = textView.text
//            updateLineCount(textView: textView)
            calculateHeight(textView: textView)
        }
        
        func calculateHeight(textView: UITextView)  {
            let layoutManager = textView.layoutManager
            layoutManager.ensureLayout(for: textView.textContainer)

            let numberOfGlyphs = layoutManager.numberOfGlyphs
            var totalHeight: CGFloat = 0
            var index = 0
            var lineRange = NSRange(location: 0, length: 0)

            while index < numberOfGlyphs {
                let rect = layoutManager.lineFragmentUsedRect(forGlyphAt: index, effectiveRange: &lineRange)
                totalHeight += rect.height
                index = NSMaxRange(lineRange)
            }
            parent.onTextChanged?(deleting, totalHeight)
        }
        
//        func updateLineCount(textView: UITextView) {
//            let layoutManager = textView.layoutManager
//            var lines = 0
//            var index = 0
//            var lineRange = NSRange(location: 0, length: 0)
//            
//            while index < layoutManager.numberOfGlyphs {
//                layoutManager.lineFragmentRect(forGlyphAt: index, effectiveRange: &lineRange)
//                index = NSMaxRange(lineRange)
//                lines += 1
//            }
//            
//            parent.lineCount = lines
//        }
    
    }
}
