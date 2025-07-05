//
//  TextFieldView.swift
//  Core
//
//  Created by akiho on 2025/07/05.
//

import SwiftUI

struct TextFieldView: View {
    @Binding var value: String
    @FocusState var focus: Bool
    @State private var isSecured: Bool = true

    var height: CGFloat = 50
    var placeholder: String = ""
    var keyboardType: UIKeyboardType = .default
    var submitLabel: SubmitLabel = .done
    var isDisable: Bool = false
    var isClosable: Bool = false
    var isPassword: Bool = false
    var onCommit: ((String) -> Void)? = nil

    var body: some View {
        HStack(spacing: 0) {
            if isPassword && isSecured {
                SecureField(placeholder, text: $value)
                    .disabled(isDisable)
                    .keyboardType(keyboardType)
                    .textFieldStyle(PlainTextFieldStyle())
                    .frame(height: height)
                    .submitLabel(submitLabel)
                    .focused($focus)
                    .onSubmit {
                        if let fn = onCommit {
                            fn(value)
                        }
                    }
            } else {
                TextField(placeholder, text: $value, onEditingChanged: { _ in
                }, onCommit: {
                    if let fn = onCommit {
                        fn(value)
                    }
                })
                .disabled(isDisable)
                .keyboardType(keyboardType)
                .textFieldStyle(PlainTextFieldStyle())
                .frame(height: height)
                .submitLabel(submitLabel)
                .focused($focus)
            }

            if isPassword {
                Button(action: {
                    isSecured.toggle()
                }) {
                    Image(systemName: isSecured ? "eye.slash" : "eye")
                        .foregroundColor(Color(UIColor.secondaryLabel))
                }
                .padding(.leading, 8)
            }

            if isClosable && !value.isEmpty {
                Spacer8()
                Button(
                    action: {
                        self.value = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(Color(UIColor.secondaryLabel))
                    }
            }
        }
        .frame(height: height)
        .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
        .background(Color(UIColor.quaternarySystemFill))
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.clear, lineWidth: 1)
        )
    }
}
