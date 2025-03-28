//
//  TextInputView.swift
//  DesignAssignmentForHatch
//
//  Created by Bob Zhang on 2025-03-26.
//

import SwiftUI

struct TextInputView: View {
    @Binding var text: String
    @State private var threelineHeight: CGFloat = 0
    var placeholder: String
    @State var fontSize: CGFloat = 18
    private let measuringText = "A\nB\nC" // your reference text
    
    func calculateHeight() -> CGFloat {
        let size = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        
        let paragraphStyle = NSMutableParagraphStyle()
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: fontSize),
            .paragraphStyle: paragraphStyle
        ]
        let total = measuringText.boundingRect(
            with: size,
            options: .usesLineFragmentOrigin,
            attributes: attributes,
            context: nil
        )
        print(total.height)
        return total.height
    }
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            WrappedUITextView(text: $text, fontSize: fontSize) { deleting, height in
                var offset:CGFloat = 0
                if deleting {
                    if height <= threelineHeight/2 && fontSize < 18{
                        offset = 2
                    }
                } else {
                    if height >= threelineHeight*2/3 && fontSize > 14 {
                        offset = -2
                    }
                }
                if offset != 0 {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        fontSize += offset
                    }
                }
            }
                .id(fontSize)
                .frame(height: threelineHeight)
                .transition(.opacity)
            if text.isEmpty {
                Text(placeholder)
                    .foregroundColor(Color.gray.opacity(0.5))
                    .offset(x:8, y:8)
            }
        }
        .font(.system(size: fontSize))
        .onAppear {
            self.threelineHeight = self.calculateHeight() + 5
        }
    }
}

#Preview {
    TextInputView(text: .constant(""), placeholder: "Hi")
}
