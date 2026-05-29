//
//  Theme.swift
//  PlaqueTracker
//
//  Created by Gayrat Hamraev on 3/5/26.
//

import SwiftUI

/// Centralized typography and styling system
/// Ensures consistent text appearance and sizes across the app
struct AppTheme {
    
    // MARK: - Font Sizes
    
    struct FontSizes {
        static let display1: CGFloat = 32  // Large hero titles
        static let display2: CGFloat = 28  // Section titles
        static let headline1: CGFloat = 24 // Major headers
        static let headline2: CGFloat = 20 // Subheaders
        static let headline3: CGFloat = 18 // Card titles
        static let body: CGFloat = 15      // Main body text
        static let bodySmall: CGFloat = 13 // Small body text
        static let caption: CGFloat = 12   // Captions and hints
        static let captionSmall: CGFloat = 10 // Very small text
    }
    
    // MARK: - Text Styles
    
    static let display1 = Font.system(size: FontSizes.display1, weight: .bold, design: .rounded)
    static let display2 = Font.system(size: FontSizes.display2, weight: .bold, design: .rounded)
    static let headline1 = Font.system(size: FontSizes.headline1, weight: .semibold, design: .rounded)
    static let headline2 = Font.system(size: FontSizes.headline2, weight: .semibold, design: .rounded)
    static let headline3 = Font.system(size: FontSizes.headline3, weight: .semibold, design: .default)
    static let body = Font.system(size: FontSizes.body, weight: .regular, design: .default)
    static let bodyBold = Font.system(size: FontSizes.body, weight: .semibold, design: .default)
    static let bodySmall = Font.system(size: FontSizes.bodySmall, weight: .regular, design: .default)
    static let caption = Font.system(size: FontSizes.caption, weight: .regular, design: .default)
    static let captionBold = Font.system(size: FontSizes.caption, weight: .semibold, design: .default)
    static let captionSmall = Font.system(size: FontSizes.captionSmall, weight: .regular, design: .default)
    
    // MARK: - Spacing System
    
    struct Spacing {
        static let xs: CGFloat = 4      // Minimal spacing
        static let sm: CGFloat = 8      // Small gaps
        static let md: CGFloat = 16     // Medium spacing (standard)
        static let lg: CGFloat = 24     // Large spacing
        static let xl: CGFloat = 32     // Extra large
        static let xxl: CGFloat = 48    // Double extra large
    }
    
    // MARK: - Corner Radius
    
    struct CornerRadius {
        static let xs: CGFloat = 8      // Small cards
        static let sm: CGFloat = 12     // Medium elements
        static let md: CGFloat = 16     // Standard cards
        static let lg: CGFloat = 20     // Large cards
        static let xl: CGFloat = 24     // Extra large elements
        static let pill: CGFloat = 50   // Fully rounded (pill)
    }
    
    // MARK: - Shadows
    
    struct Shadows {
        /// Light shadow for subtle depth
        static let light = Shadow(
            color: Color.black.opacity(0.08),
            radius: 4,
            x: 0,
            y: 2
        )
        
        /// Medium shadow for cards
        static let medium = Shadow(
            color: Color.black.opacity(0.12),
            radius: 8,
            x: 0,
            y: 4
        )
        
        /// Strong shadow for elevated elements
        static let strong = Shadow(
            color: Color.black.opacity(0.15),
            radius: 12,
            x: 0,
            y: 8
        )
    }
    
    // MARK: - Animation Durations
    
    struct Animation {
        static let quick: TimeInterval = 0.15
        static let standard: TimeInterval = 0.3
        static let slow: TimeInterval = 0.5
        
        /// Spring animation for interactive elements
        static let spring = SwiftUI.Animation.spring(response: 0.35, dampingFraction: 0.8)
        
        /// Smooth easing for transitions
        static let smooth = SwiftUI.Animation.easeInOut(duration: standard)
    }
}

// MARK: - Shadow Model

struct Shadow {
    let color: Color
    let radius: CGFloat
    let x: CGFloat
    let y: CGFloat
}

// MARK: - View Extensions

extension View {
    /// Apply a themed shadow to the view
    func themeShadow(_ shadow: Shadow) -> some View {
        self.shadow(color: shadow.color, radius: shadow.radius, x: shadow.x, y: shadow.y)
    }
    
    /// Apply light shadow
    func shadowLight() -> some View {
        self.themeShadow(AppTheme.Shadows.light)
    }
    
    /// Apply medium shadow
    func shadowMedium() -> some View {
        self.themeShadow(AppTheme.Shadows.medium)
    }
    
    /// Apply strong shadow
    func shadowStrong() -> some View {
        self.themeShadow(AppTheme.Shadows.strong)
    }
    
    /// Apply standard card styling
    func cardStyle(background: Color = AppColors.cardBackground) -> some View {
        self
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(AppTheme.Spacing.md)
            .background(background)
            .clipShape(RoundedRectangle(cornerRadius: AppTheme.CornerRadius.lg))
            .shadowMedium()
    }
    
    /// Apply standard button styling
    func primaryButtonStyle() -> some View {
        self
            .frame(maxWidth: .infinity)
            .padding(.vertical, AppTheme.Spacing.md)
            .background(AppColors.primary)
            .foregroundColor(.white)
            .font(AppTheme.bodyBold)
            .clipShape(RoundedRectangle(cornerRadius: AppTheme.CornerRadius.md))
            .shadowMedium()
    }
    
    /// Apply secondary button styling
    func secondaryButtonStyle() -> some View {
        self
            .frame(maxWidth: .infinity)
            .padding(.vertical, AppTheme.Spacing.md)
            .background(AppColors.background)
            .foregroundColor(AppColors.primary)
            .font(AppTheme.bodyBold)
            .overlay(
                RoundedRectangle(cornerRadius: AppTheme.CornerRadius.md)
                    .stroke(AppColors.primary, lineWidth: 2)
            )
    }
}

// MARK: - Preview

#if DEBUG
struct AppThemePreview: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.lg) {
                // Typography
                VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                    Text("Display 1").font(AppTheme.display1)
                    Text("Display 2").font(AppTheme.display2)
                    Text("Headline 1").font(AppTheme.headline1)
                    Text("Headline 2").font(AppTheme.headline2)
                    Text("Headline 3").font(AppTheme.headline3)
                    Text("Body text").font(AppTheme.body)
                    Text("Body small").font(AppTheme.bodySmall)
                    Text("Caption").font(AppTheme.caption)
                }
                .padding(AppTheme.Spacing.md)
                .cardStyle()
                
                // Spacing
                VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                    Text("Spacing System").font(AppTheme.headline3)
                    
                    HStack {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(AppColors.primary)
                            .frame(width: AppTheme.Spacing.xs, height: 40)
                        Text("XS (4pt)").font(AppTheme.body)
                    }
                    
                    HStack {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(AppColors.primary)
                            .frame(width: AppTheme.Spacing.sm, height: 40)
                        Text("SM (8pt)").font(AppTheme.body)
                    }
                    
                    HStack {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(AppColors.primary)
                            .frame(width: AppTheme.Spacing.md, height: 40)
                        Text("MD (16pt)").font(AppTheme.body)
                    }
                    
                    HStack {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(AppColors.primary)
                            .frame(width: AppTheme.Spacing.lg, height: 40)
                        Text("LG (24pt)").font(AppTheme.body)
                    }
                }
                .padding(AppTheme.Spacing.md)
                .cardStyle()
                
                // Corner Radius
                VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                    Text("Corner Radius").font(AppTheme.headline3)
                    
                    HStack(spacing: AppTheme.Spacing.sm) {
                        RoundedRectangle(cornerRadius: AppTheme.CornerRadius.xs)
                            .fill(AppColors.primary)
                            .frame(height: 50)
                        
                        RoundedRectangle(cornerRadius: AppTheme.CornerRadius.md)
                            .fill(AppColors.success)
                            .frame(height: 50)
                        
                        RoundedRectangle(cornerRadius: AppTheme.CornerRadius.lg)
                            .fill(AppColors.accent)
                            .frame(height: 50)
                        
                        Circle()
                            .fill(AppColors.info)
                            .frame(height: 50)
                    }
                }
                .padding(AppTheme.Spacing.md)
                .cardStyle()
            }
            .padding(AppTheme.Spacing.md)
        }
    }
}

#Preview {
    AppThemePreview()
}
#endif
