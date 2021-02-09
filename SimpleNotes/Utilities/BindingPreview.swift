//
//  BindingPreview.swift
//  SimpleNotes
//
//  Created by Conner M on 1/20/21.
//

import SwiftUI

@available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
public struct StatefulPreviewWrapper<Value, Content: View>: View {
    @State var value: Value
    var content: (Binding<Value>) -> Content

    public var body: some View {
        content($value)
    }

    public init(_ value: Value, content: @escaping (Binding<Value>) -> Content) {
        self._value = State(wrappedValue: value)
        self.content = content
    }
}

@available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
public struct CreateEditWrapper <Content: View>: View {
    @State var isEditing: Bool
    @State var bgColor: CGColor
    
    var content: (Binding<Bool>,Binding<CGColor>) -> Content

    public var body: some View {
        content($isEditing,$bgColor)
    }

    public init(_ isEditing: Bool, _ bgColor: CGColor, content: @escaping (Binding<Bool>,Binding<CGColor>) -> Content) {
        self._isEditing = State(wrappedValue: isEditing)
        self._bgColor = State(wrappedValue: bgColor)
        self.content = content
    }
}
