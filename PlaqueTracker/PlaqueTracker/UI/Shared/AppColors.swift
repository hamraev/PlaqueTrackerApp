//
//  AppColors.swift
//  PlaqueTracker
//
//  Created by Gayrat Hamraev on 3/5/26.
//

import SwiftUI

/// Centralized color palette for the PlaqueTracker app
/// All colors follow kid-friendly, accessible design standards
struct AppColors {
    
    // MARK: - Primary Colors
    
    /// Main brand color - used for primary actions and highlights
    static let primary = Color(red: 0.0, green: 0.478, blue: 1.0) // #007AFF
    
    /// Primary color variants for different states
    static let primaryLight = Color(red: 0.2, green: 0.55, blue: 1.0)
    static let primaryDark = Color(red: 0.0, green: 0.35, blue: 0.8)
    
    // MARK: - Secondary Colors
    
    /// Success/achievement color - used for positive feedback and progress
    static let success = Color(red: 0.208, green: 0.784, blue: 0.349) // #34C759
    
    /// Success color variants
    static let successLight = Color(red: 0.4, green: 0.9, blue: 0.55)
    static let successDark = Color(red: 0.1, green: 0.6, blue: 0.25)
    
    // MARK: - Accent Colors
    
    /// Reward/celebration color - warm and inviting for gamification
    static let accent = Color(red: 1.0, green: 0.584, blue: 0.0) // #FF9500
    
    /// Accent color variants
    static let accentLight = Color(red: 1.0, green: 0.7, blue: 0.2)
    static let accentDark = Color(red: 0.9, green: 0.5, blue: 0.0)
    
    // MARK: - Status Colors
    
    /// Attention needed color - for areas requiring focus
    static let warning = Color(red: 1.0, green: 0.231, blue: 0.188) // #FF3B30
    static let warningLight = Color(red: 1.0, green: 0.4, blue: 0.3)
    
    /// Info color - for hints and tooltips
    static let info = Color(red: 0.353, green: 0.784, blue: 0.98) // #5AC8FA
    
    // MARK: - Neutral Colors
    
    /// Text color - primary text on light backgrounds
    static let text = Color(UIColor.label)
    
    /// Secondary text color - captions and hints
    static let textSecondary = Color(UIColor.secondaryLabel)
    
    /// Tertiary text color - disabled or background text
    static let textTertiary = Color(UIColor.tertiaryLabel)
    
    // MARK: - Background Colors
    
    /// Main background
    static let background = Color(UIColor.systemBackground)
    
    /// Secondary background - for grouped content
    static let backgroundSecondary = Color(UIColor.secondarySystemBackground)
    
    /// Tertiary background - for layered content
    static let backgroundTertiary = Color(UIColor.tertiarySystemBackground)
    
    // MARK: - Semantic Colors for UI Elements
    
    /// Card background with subtle tint
    static let cardBackground = Color(red: 0.98, green: 0.98, blue: 1.0) // Light blue
    
    /// Disabled state color
    static let disabled = Color(red: 0.9, green: 0.9, blue: 0.9)
    
    /// Divider color
    static let divider = Color(red: 0.9, green: 0.9, blue: 0.92)
    
    // MARK: - Gradient Colors
    
    /// Primary gradient - for hero sections
    static let gradientPrimary = LinearGradient(
        gradient: Gradient(colors: [primaryLight, primary]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    /// Success gradient - for achievements
    static let gradientSuccess = LinearGradient(
        gradient: Gradient(colors: [successLight, success]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    /// Reward gradient - for gamification elements
    static let gradientAccent = LinearGradient(
        gradient: Gradient(colors: [accentLight, accent]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    // MARK: - Contextual Colors
    
    /// Smile score excellent range (80-100)
    static let scoreExcellent = Color(red: 0.208, green: 0.784, blue: 0.349)
    
    /// Smile score good range (60-79)
    static let scoreGood = Color(red: 0.353, green: 0.784, blue: 0.98)
    
    /// Smile score fair range (40-59)
    static let scoreFair = Color(red: 1.0, green: 0.584, blue: 0.0)
    
    /// Smile score poor range (0-39)
    static let scorePoor = Color(red: 1.0, green: 0.231, blue: 0.188)
}

// MARK: - Color Extensions

extension Color {
    /// Get smile score color based on score value (0-100)
    static func scoreColor(for score: Int) -> Color {
        switch score {
        case 80...100:
            return AppColors.scoreExcellent
        case 60..<80:
            return AppColors.scoreGood
        case 40..<60:
            return AppColors.scoreFair
        default:
            return AppColors.scorePoor
        }
    }
    
    /// Opacity variant of the color
    func withOpacity(_ opacity: Double) -> Color {
        return self.opacity(opacity)
    }
}

// MARK: - Preview

#if DEBUG
struct AppColorsPreview: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Primary
                VStack(alignment: .leading) {
                    Text("Primary Colors").font(.headline)
                    HStack(spacing: 12) {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(AppColors.primaryLight)
                            .frame(height: 60)
                        RoundedRectangle(cornerRadius: 12)
                            .fill(AppColors.primary)
                            .frame(height: 60)
                        RoundedRectangle(cornerRadius: 12)
                            .fill(AppColors.primaryDark)
                            .frame(height: 60)
                    }
                }
                
                // Success
                VStack(alignment: .leading) {
                    Text("Success Colors").font(.headline)
                    HStack(spacing: 12) {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(AppColors.successLight)
                            .frame(height: 60)
                        RoundedRectangle(cornerRadius: 12)
                            .fill(AppColors.success)
                            .frame(height: 60)
                        RoundedRectangle(cornerRadius: 12)
                            .fill(AppColors.successDark)
                            .frame(height: 60)
                    }
                }
                
                // Accent
                VStack(alignment: .leading) {
                    Text("Accent Colors").font(.headline)
                    HStack(spacing: 12) {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(AppColors.accentLight)
                            .frame(height: 60)
                        RoundedRectangle(cornerRadius: 12)
                            .fill(AppColors.accent)
                            .frame(height: 60)
                        RoundedRectangle(cornerRadius: 12)
                            .fill(AppColors.accentDark)
                            .frame(height: 60)
                    }
                }
                
                // Score Colors
                VStack(alignment: .leading) {
                    Text("Smile Score Colors").font(.headline)
                    HStack(spacing: 12) {
                        VStack {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(AppColors.scoreExcellent)
                                .frame(height: 60)
                            Text("80-100").font(.caption)
                        }
                        VStack {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(AppColors.scoreGood)
                                .frame(height: 60)
                            Text("60-79").font(.caption)
                        }
                        VStack {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(AppColors.scoreFair)
                                .frame(height: 60)
                            Text("40-59").font(.caption)
                        }
                        VStack {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(AppColors.scorePoor)
                                .frame(height: 60)
                            Text("0-39").font(.caption)
                        }
                    }
                }
            }
            .padding()
        }
    }
}

#Preview {
    AppColorsPreview()
}
#endif
