//
//  AppAssetImage.swift
//  PlaqueTracker
//
//  Created by Gayrat Hamraev on 5/29/26.
//

import SwiftUI

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

enum AppAssetImage {
    static func exists(_ name: String) -> Bool {
        #if canImport(UIKit)
        return UIImage(named: name) != nil
        #elseif canImport(AppKit)
        return NSImage(named: name) != nil
        #else
        return false
        #endif
    }
}

struct OptionalAssetImage<Placeholder: View>: View {
    let name: String
    let contentMode: ContentMode
    let placeholder: Placeholder

    init(name: String, contentMode: ContentMode = .fit, @ViewBuilder placeholder: () -> Placeholder) {
        self.name = name
        self.contentMode = contentMode
        self.placeholder = placeholder()
    }

    var body: some View {
        if AppAssetImage.exists(name) {
            Image(name)
                .resizable()
                .aspectRatio(contentMode: contentMode)
        } else {
            placeholder
        }
    }
}
