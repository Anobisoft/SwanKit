//
//  GalleryView.swift
//  SwanKitDemo
//
//  Created by Stanislav Pletnev on 2026-07-18.
//  Copyright © 2026 Anobisoft. Licensed under the MIT License.
//

import UIKit
import SwanKit

/// A MainActor-isolated layout canvas subclass aggregating a full-screen programmatic
/// media stream collection with calculated adaptive pixel-perfect item bounds geometry.
@MainActor
final class GalleryView: UIView {

    // MARK: - Core Layout Metrics Constants
    private let sidePadding: CGFloat = 16
    private let interItemSpacing: CGFloat = 16

    // Feature Used: Programmatic UICollectionView tied tightly to responsive bound updates
    private let flowLayout = UICollectionViewFlowLayout()

    // Инициализируем коллекцию сразу, а точный itemSize накатим в layoutSubviews()
    lazy var collectionView: UICollectionView = {
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = interItemSpacing
        flowLayout.minimumInteritemSpacing = interItemSpacing
        flowLayout.sectionInset = UIEdgeInsets(top: 16, left: sidePadding, bottom: 80, right: sidePadding)

        let collection = UICollectionView(frame: .zero, collectionViewLayout: flowLayout).autolayout()
            .backgroundColor(.clear)
            .clipsToBounds(false)
            .isUserInteractionEnabled(true)

        collection.alwaysBounceVertical = true
        collection.showsVerticalScrollIndicator = false
        return collection
    }()

    let statusLabel = StatusConsoleLabel.autolayout()
        .text("SwanKit Subsystems Status: Idle")

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHierarchy()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: - Lifecycle Layout Pass

    override func layoutSubviews() {
        super.layoutSubviews()

        // Гарантируем, что перерасчет пойдет только если вьюха получила реальные размеры от системы
        if bounds.width > 0 {
            let adaptiveSize = calculateAdaptiveItemSize()
            flowLayout.itemSize = adaptiveSize
        }
    }

    // MARK: - Core Setup Mechanics

    private func setupHierarchy() {
        backgroundColor = .systemGroupedBackground
        addSubview(collectionView)
        addSubview(statusLabel)
    }

    private func setupConstraints() {
        [
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),

            statusLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            statusLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            statusLabel.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -8),
            statusLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 44)
        ].activate()
    }

    // MARK: - Pixel-Perfect Layout Math Engine

    /// Computes the absolute pixel-perfect size for items based on the active view bounds width.
    func calculateAdaptiveItemSize() -> CGSize {
        // FEATURE FIXED: We rely strictly on self.bounds to natively support iPad Split-View and orientation tracking.
        let availableWidth = bounds.width - (sidePadding * 2)

        let targetColumns: CGFloat = 3
        let totalInterItemSpacing = (targetColumns - 1) * interItemSpacing
        let netContentWidth = availableWidth - totalInterItemSpacing

        let cellWidth = floor(netContentWidth / targetColumns)
        return CGSize(width: cellWidth, height: cellWidth)
    }

    func applyShadowConfiguration() {
        statusLabel.shadow(
            radius: 8,
            color: { $0.userInterfaceStyle == .dark ? .label : .black },
            opacity: 0.15,
            offset: CGSize(width: 0, height: 4)
        )
    }
}
