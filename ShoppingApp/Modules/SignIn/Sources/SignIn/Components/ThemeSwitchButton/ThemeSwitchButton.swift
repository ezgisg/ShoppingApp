//
//  ThemeSwitchButton.swift
//
//
//  Created by Ezgi Sümer Günaydın on 23.07.2024.
//

import UIKit
import Combine
/*
// MARK: - ThemeSwitchButton
final public class ThemeSwitchButton: UIView, NibOwnerLoadable {
    // MARK: - Module
    public static var module = Bundle.module

    // MARK: - UI Components
    @IBOutlet private weak var contentButton: UIButton!
    @IBOutlet private weak var switchDotView: UIView!
    @IBOutlet private weak var swtichLeadingConstraint: NSLayoutConstraint!
    @IBOutlet private weak var stateLabel: UILabel!
    @IBOutlet private weak var stateLeadingConstraint: NSLayoutConstraint!

    // MARK: - Data
    private var cancellables: [AnyCancellable] = []
    private var isOn: Bool {
        get {
            return UserManager.shared.isInDarkTheme
        }
        set(newValue) {
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
            UserManager.shared.isInDarkTheme = newValue
            updateContent()
        }
    }

    // MARK: - Init
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadNibContent()
        setupViews()
        updateContent()
    }
}

// MARK: - Configuration
private extension ThemeSwitchButton {
    final func setupViews() {
        configureContainerView()
        configureStateLabel()
        configureSwitchDotView()
        configureContentButton()
    }

    final func configureContainerView() {
        borderColor = .borderSwitch
        borderWidth = 1
        setHeightHalfCornerRadius()
        backgroundColor = .backgroundSwitch
    }

    final func configureStateLabel() {
        stateLabel.font = .medium(12)
        stateLabel.textColor = .init(light: .pearlBlack, dark: .white)
    }

    final func configureSwitchDotView() {
        switchDotView.setHeightHalfCornerRadius()
        switchDotView.backgroundColor = .borderSwitch
    }

    final func configureContentButton() {
        contentButton.setTitleForAllStates("")
        contentButton
            .publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                guard let self else { return }
                self.isOn.toggle()
            }
            .store(in: &cancellables)
    }
}

// MARK: - Helpers
private extension ThemeSwitchButton {
    final func updateContent() {
        let stateText = isOn ? L10nThemeSwitch.dark.localized() : L10nThemeSwitch.light.localized()
        let stateLeading: CGFloat = isOn ? 36 : 10
        let switchDotLeading: CGFloat = isOn ? 4 : 48
        borderColor = .borderSwitch

        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            UIView.animate(withDuration: Constants.Duration.animation) {
                self.stateLabel.text = stateText
                self.stateLeadingConstraint.constant = stateLeading
                self.swtichLeadingConstraint.constant = switchDotLeading
                self.layoutIfNeeded()
            }
        }
    }
}
*/
