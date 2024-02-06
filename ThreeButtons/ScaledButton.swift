import UIKit

final class ScaledButton: UIButton {
    private var animator: UIViewPropertyAnimator?

    init(title: String) {
        super.init(frame: .zero)
        self.configurationUpdateHandler = makeUpdateHandler()
        self.configuration = makeConfiguration(title: title)
    }

    required init?(coder: NSCoder) {
        nil
    }
}

extension ScaledButton {
    private func makeConfiguration(title: String) -> UIButton.Configuration {
        var configuration = UIButton.Configuration.filled()

        configuration.attributedTitle = AttributedString(title)
        configuration.imagePlacement = .trailing
        configuration.image = UIImage(systemName: "arrow.right.circle.fill")

        configuration.imagePadding = LayoutConstants.imagePadding
        configuration.contentInsets = LayoutConstants.contentInsets

        return configuration
    }

    private func makeUpdateHandler() -> UIButton.ConfigurationUpdateHandler {
        { [weak self] button in
            button.configuration?.background.backgroundColor = self?.backgroundButtonColor
            button.configuration?.attributedTitle?.foregroundColor = self?.titleButtonColor
            button.configuration?.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(
                paletteColors: [self?.imageButtonColor].compactMap { $0 }
            )

            switch button.state {
            case [.selected, .highlighted], .selected, .highlighted:
                self?.animateIn()
            default:
                self?.animateOut()
            }
        }
    }
}

extension ScaledButton {
    private enum AnimationConstants {
        static let dutation: TimeInterval = 0.3
        static let scaleCoef: CGFloat = 0.9
    }

    private func animateIn() {
        animator = nil
        animator = UIViewPropertyAnimator(
            duration: AnimationConstants.dutation,
            timingParameters: UICubicTimingParameters()
        )
        animator?.addAnimations { [weak self] in
            self?.transform = CGAffineTransform(
                scaleX: AnimationConstants.scaleCoef,
                y: AnimationConstants.scaleCoef
            )
        }
        animator?.startAnimation()
    }

    private func animateOut() {
        animator = nil
        animator = UIViewPropertyAnimator(
            duration: AnimationConstants.dutation,
            timingParameters: UICubicTimingParameters()
        )
        animator?.addAnimations { [weak self] in
            self?.transform = .identity
        }
        animator?.startAnimation()
    }
}

extension ScaledButton {
    private enum LayoutConstants {
        static let imagePadding: CGFloat = 8
        static let contentInsets: NSDirectionalEdgeInsets = .init(
            top: 10, leading: 14,
            bottom: 10, trailing: 14
        )
    }

    private enum Colors {
        static let normalForegrund: UIColor = .white
        static let dimmedForegrund: UIColor = .systemGray3

        static let normalBackground: UIColor = .link
        static let dimmedBackground: UIColor = .systemGray2

        static let normalImage: UIColor = .white
        static let dimmedImage: UIColor = .systemGray3
    }

    private var titleButtonColor: UIColor {
        tintAdjustmentMode == .dimmed
            ? Colors.dimmedForegrund
            : Colors.normalForegrund
    }

    private var backgroundButtonColor: UIColor {
        tintAdjustmentMode == .dimmed
            ? Colors.dimmedBackground
            : Colors.normalBackground
    }

    private var imageButtonColor: UIColor {
        tintAdjustmentMode == .dimmed
            ? Colors.dimmedImage
            : Colors.normalImage
    }
}
