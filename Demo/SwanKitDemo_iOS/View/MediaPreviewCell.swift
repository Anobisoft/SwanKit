//
//  MediaPreviewCell.swift
//  SwanKitDemo
//
//  Created by Stanislav Pletnev on 2026-07-18.
//  Copyright © 2026 Anobisoft. Licensed under the MIT License.
//

import UIKit
import SwanKit

/// A programmatic UICollectionViewCell component subclass serving as an isolated preview
/// thumbnail container node styled with custom inner image passport padding metrics.
public final class MediaPreviewCell: UICollectionViewCell {

    // Feature Used: UIImageView.autolayout() factory, contentMode(), cornerRadius() and clipsToBounds() modifiers
    public let imageView = UIImageView.autolayout()
        .contentMode(.scaleAspectFill)
        .backgroundColor(.systemGray5)
        .cornerRadius(12)
        .clipsToBounds(true)

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupCellHierarchy()
        setupCellConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func setupCellHierarchy() {
        contentView.backgroundColor = .systemBackground
        contentView.layer.cornerRadius = 16
        contentView.clipsToBounds = true

        contentView.addSubview(imageView)
    }

    private func setupCellConstraints() {
        // Feature Used: Flat NSLayoutConstraint activation array wrapper pipeline
        // Injected internal cell bounds padding (паспарту эффект) to cleanly isolate thumbnails
        [
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ].activate()
    }
}
