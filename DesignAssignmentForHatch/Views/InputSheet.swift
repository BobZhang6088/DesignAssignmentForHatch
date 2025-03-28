//
//  InputSheet.swift
//  DesignAssignmentForHatch
//
//  Created by Bob Zhang on 2025-03-27.
//

import SwiftUI

struct InputSheet: View {
    @Binding var text: String
    @State private var threelineHeight: CGFloat = 100
    var placeholder: String
    @State var fontSize: CGFloat = 18

    @Namespace static var textEditorAnimation
    
    var body: some View {
        VStack {
            HStack(alignment: .top) {
                ZStack(alignment: .topLeading) {
                    TextEditor(text: $text)
                        .scrollContentBackground(.hidden) 
                        .frame(maxHeight: .infinity)

                    if text.isEmpty {
                        Text(placeholder)
                            .foregroundColor(Color.gray.opacity(0.5))
                    }
                }
                .font(.system(size: fontSize))
                
                Button(action: {
                    // Add your action
                }) {
                    Image(systemName: "arrow.down.right.and.arrow.up.left")
                }
                .padding(.horizontal, 10)
            }
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    InputSheet(text: .constant(""), placeholder: "Start Typing...")
}
