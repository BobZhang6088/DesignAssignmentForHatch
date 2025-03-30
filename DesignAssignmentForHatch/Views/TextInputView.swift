//
//  TextInputView.swift
//  DesignAssignmentForHatch
//
//  Created by Bob Zhang on 2025-03-26.
//

import SwiftUI
fileprivate let biggestFontSize: CGFloat = 18
struct TextInputView: View {
    @Binding var text: String
    @Binding var expanded: Bool
    @State private var threelineHeight: CGFloat = 0
    var placeholder: String
    var fontSize: CGFloat  {
        expanded ? biggestFontSize : fontSizeNotExpanded
    }
    private let measuringText = "A\nB\nC" // your reference text
    @State private var fontSizeNotExpanded: CGFloat = biggestFontSize

    @State private var debounceWorkItem: DispatchWorkItem?
    
    @State private var textviewConstentSize: CGSize =  CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
    

    func scheduleFontSizeUpdate(height: CGFloat, deleting: Bool) {
        let delayTime: TimeInterval = 0.1
        debounceWorkItem?.cancel()
        
        var height = height
        let workItem = DispatchWorkItem {
            var font:CGFloat = fontSizeNotExpanded
            if deleting {
                while height <= threelineHeight/2 && font < 18 {
                    font += 2
                    height = calculateHeight(wiht: text, fontSize: font)
                }
            } else {
                while height >= threelineHeight*2/3 && font > 14 {
                    font -= 2
                    height = calculateHeight(wiht: text, fontSize: font)
                }
            }
            if font != fontSizeNotExpanded {
                withAnimation(.easeInOut(duration: 0.5)) {
                    fontSizeNotExpanded = font
                }
                print("fontSizeNotExpanded \(fontSizeNotExpanded)")
            }
        }

        debounceWorkItem = workItem

        DispatchQueue.main.asyncAfter(deadline: .now() + delayTime, execute: workItem)
    }
    
    func calculateHeight(wiht string: String, fontSize: CGFloat) -> CGFloat {
        let size = CGSize(width: textviewConstentSize.width, height: CGFloat.greatestFiniteMagnitude)
        
        let paragraphStyle = NSMutableParagraphStyle()
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: fontSize),
            .paragraphStyle: paragraphStyle
        ]
        let total = string.boundingRect(
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
                scheduleFontSizeUpdate(height: height, deleting: deleting)
            }
            .onGeometryChange(for: CGSize.self, of: { geo in
                geo.size
            }, action: { oldValue, newValue in
                textviewConstentSize = newValue
            })
                .id(fontSize)
                .frame(maxHeight: expanded ?.infinity: threelineHeight)
                .transition(.opacity)
            if text.isEmpty {
                Text(placeholder)
                    .foregroundColor(Color.gray.opacity(0.5))
                    .offset(x:8, y:8)
            }
        }
        .font(.system(size: fontSize))
        .onAppear {
            self.threelineHeight = self.calculateHeight(wiht: measuringText, fontSize: biggestFontSize) + 5
        }
    }
}

#Preview {
    TextInputView(text: .constant(""),expanded: .constant(false), placeholder: "Hi")
}
