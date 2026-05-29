//
//  ScanPhotoImage.swift
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

struct ScanPhotoImage: View {
    let data: Data?

    var body: some View {
        ZStack {
            AppColors.backgroundSecondary

            if let image = platformImage {
                Image(platformImage: image)
                    .resizable()
                    .scaledToFill()
            } else {
                VStack(spacing: AppTheme.Spacing.sm) {
                    Image(systemName: "photo")
                        .font(.system(size: 30, weight: .semibold))
                    Text("Photo coming soon")
                        .font(AppTheme.caption)
                }
                .foregroundColor(AppColors.textTertiary)
            }
        }
        .clipped()
    }

    private var platformImage: PlatformImage? {
        guard let data else { return nil }
        return PlatformImage(data: data)
    }
}

#if canImport(UIKit)
typealias PlatformImage = UIImage

private extension Image {
    init(platformImage: PlatformImage) {
        self.init(uiImage: platformImage)
    }
}
#elseif canImport(AppKit)
typealias PlatformImage = NSImage

private extension Image {
    init(platformImage: PlatformImage) {
        self.init(nsImage: platformImage)
    }
}
#endif
