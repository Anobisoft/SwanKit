//
//  MainView.swift
//  SwanKitDemo
//
//  Created by Stanislav Pletnev on 2026-07-18.
//  Copyright © 2026 Anobisoft. Licensed under the MIT License.
//

import UIKit
import SwanKit

/// A MainActor-isolated layout canvas subclass aggregating the programmatic view hierarchy
/// and declarative layout configurations for the SwanKit interactive showcase screen.
@MainActor
final class MainView: UIView {

    // MARK: - Interactive UI Nodes (SwanKit Method Chaining Subsystem)

    // Feature Used: UIView.autolayout() factory and UIView+Chaining.backgroundColor()
    let stackView = UIStackView.autolayout()
        .backgroundColor(.clear)

    // Feature Used: UIView.autolayout() and cornerRadius() chain layout modifiers
    let shadowDemoView = UIView.autolayout()
        .backgroundColor(.systemBackground)
        .cornerRadius(12)

    // NEW FEATURE: Programmatic UICollectionView replacing the single legacy preview image view bounds.
    // Configured horizontally to display a continuous media assets tracking stream panel.
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 140, height: 140)
        layout.minimumLineSpacing = 12
        layout.sectionInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)

        // Initialized via SwanKit's native .autolayout() factory wrapper
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout).autolayout()
            .backgroundColor(.clear)
            .clipsToBounds(true)

        collection.showsHorizontalScrollIndicator = false
        return collection
    }()

    // Feature Used: UITextField.autolayout() factory and clearButtonMode() chaining layout modifiers
    let demoTextField = UITextField.autolayout()
        .placeholder("Type something to test global padding...")
        .clearButtonMode(.whileEditing)

    // Feature Used: UILabel.autolayout() factory, textAlignment(), numberOfLines(), font(), textColor() and text() modifiers
    let statusLabel = UILabel.autolayout()
        .textAlignment(.center)
        .numberOfLines(0)
        .font(.monospacedSystemFont(ofSize: 13, weight: .regular))
        .textColor(.secondaryLabel)
        .text("SwanKit Subsystems Status: Idle")

    // MARK: - Framework Subsystem Trigger Buttons

    let cameraButton = UIButton.autolayout().configure { $0.title = "📸 Launch Hardware Camera" }
    let galleryButton = UIButton.autolayout().configure { $0.title = "🖼 Open Media Gallery" }
    let alertButton = UIButton.autolayout().configure { $0.title = "⚠️ Trigger Custom Alert Overlay" }
    let cacheButton = UIButton.autolayout().configure { $0.title = "💾 Inspect Cache Subsystem" }

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHierarchy()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: - Core Setup Mechanics

    private func setupHierarchy() {
        backgroundColor = .systemGroupedBackground

        addSubview(shadowDemoView)
        // Inject the newly integrated items collection stream inside the dynamic shadow layout capsule view bounding frames
        shadowDemoView.addSubview(collectionView)
        addSubview(stackView)
        addSubview(statusLabel)

        stackView.addArrangedSubview(demoTextField)
        stackView.addArrangedSubview(cameraButton)
        stackView.addArrangedSubview(galleryButton)
        stackView.addArrangedSubview(alertButton)
        stackView.addArrangedSubview(cacheButton)
    }

    private func setupConstraints() {
        // Feature Used: Batch activate layout constraints via Array<NSLayoutConstraint>.activate() wrapper
        [
            shadowDemoView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            shadowDemoView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            shadowDemoView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            shadowDemoView.heightAnchor.constraint(equalToConstant: 180),

            // Bind collection view edges seamlessly inside the underlying wrapper shadow tracking frame metrics
            collectionView.topAnchor.constraint(equalTo: shadowDemoView.topAnchor, constant: 12),
            collectionView.leadingAnchor.constraint(equalTo: shadowDemoView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: shadowDemoView.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: shadowDemoView.bottomAnchor, constant: -12),

            stackView.topAnchor.constraint(equalTo: shadowDemoView.bottomAnchor, constant: 24),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            statusLabel.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 32),
            statusLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            statusLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            statusLabel.bottomAnchor.constraint(lessThanOrEqualTo: safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ].activate()
    }

    // MARK: - Dynamic Adaptive Shadow Orchestration

    func applyShadowConfiguration() {
        shadowDemoView.shadow(
            radius: 8,
            color: { $0.userInterfaceStyle == .dark ? .label : .black },
            opacity: 0.25,
            offset: CGSize(width: 0, height: 4)
        )
    }
}

// MARK: - Programmatic UICollectionViewCell Component subclass Node

/// A simplified preview thumbnail item container node styled using SwanKit's custom cascading modifier pipelines.
final class MediaPreviewCell: UICollectionViewCell {

    let imageView = UIImageView.autolayout()
        .contentMode(.scaleAspectFill)
        .backgroundColor(.systemGray5)
        .cornerRadius(8)
        .clipsToBounds(true)

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        [
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ].activate()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
