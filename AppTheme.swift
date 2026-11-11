import SwiftUI

enum AppTheme {

    // MARK: - Colors

    enum Colors {

        static let background = Color(
            uiColor: .systemGroupedBackground
        )

        static let secondaryBackground = Color(
            uiColor: .secondarySystemGroupedBackground
        )

        static let primary = Color(
            uiColor: .label
        )

        static let secondary = Color(
            uiColor: .secondaryLabel
        )

        static let accent = Color(
            red: 0.20,
            green: 0.43,
            blue: 0.95
        )

        static let success = Color(
            uiColor: .systemGreen
        )

        static let warning = Color(
            uiColor: .systemOrange
        )

        static let danger = Color(
            uiColor: .systemRed
        )

        static let separator = Color(
            uiColor: .separator
        )
    }

    // MARK: - Typography

    enum Typography {

        static let largeTitle = Font.system(
            .largeTitle,
            design: .rounded
        ).weight(.bold)

        static let title = Font.system(
            .title2,
            design: .rounded
        ).weight(.bold)

        static let headline = Font.system(
            .headline
        )

        static let body = Font.system(
            .body
        )

        static let subheadline = Font.system(
            .subheadline
        )

        static let caption = Font.system(
            .caption
        )
    }

    // MARK: - Spacing

    enum Spacing {

        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 16
        static let lg: CGFloat = 24
        static let xl: CGFloat = 32
    }

    // MARK: - Radius

    enum Radius {

        static let small: CGFloat = 10
        static let medium: CGFloat = 16
        static let large: CGFloat = 22
    }
}
