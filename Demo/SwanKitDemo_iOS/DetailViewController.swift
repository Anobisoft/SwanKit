//
//  DetailViewController.swift
//  SwanKitDemo
//
//  Created by Stanislav Pletnev on 2026-07-18.
//  Copyright © 2026 Anobisoft. Licensed under the MIT License.
//

import UIKit
import SwanKit

@MainActor
final class DetailViewController: UIViewController {

    // MARK: - UI Nodes (SwanKit Method Chaining Subsystem)

    private let imageView = UIImageView.autolayout()
        .contentMode(.scaleAspectFit)
        .backgroundColor(.black)

    // Feature Used: UIProgressView.autolayout() with system blue tint chaining configurations
    private let progressBar = UIProgressView(progressViewStyle: .default).autolayout()

    private let statusLabel = UILabel.autolayout()
        .textAlignment(.center)
        .numberOfLines(0)
        .font(.systemFont(ofSize: 14, weight: .medium))
        .textColor(.white)
        .text("Connecting to Photo Library...")

    // MARK: - State Dependencies

    private let itemProvider: NSItemProvider
    private var progressObservation: NSKeyValueObservation?

    // MARK: - Initializers

    init(itemProvider: NSItemProvider) {
        self.itemProvider = itemProvider
        super.init(nibName: nil, bundle: nil)
        // Ensure modal presentations span standard overlay behaviors elegantly
        self.modalPresentationStyle = .pageSheet
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        // Invalidate observations context strictly to clear memory pools
        progressObservation?.invalidate()
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupHierarchy()
        setupConstraints()
        executeNativeAssetDownload()
    }

    // MARK: - Setup Layout Mechanics

    private func setupHierarchy() {
        view.backgroundColor = .black
        view.addSubview(imageView)
        view.addSubview(progressBar)
        view.addSubview(statusLabel)
    }

    private func setupConstraints() {
        [
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            progressBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            progressBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            progressBar.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            progressBar.heightAnchor.constraint(equalToConstant: 4),

            statusLabel.topAnchor.constraint(equalTo: progressBar.bottomAnchor, constant: 16),
            statusLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            statusLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ].activate()
    }

    // MARK: - Native Non-Simulated Download Subsystem

    private func executeNativeAssetDownload() {
        guard itemProvider.canLoadObject(ofClass: UIImage.self) else {
            statusLabel.text("Error: Asset format incompatible.")
            progressBar.isHidden = true
            return
        }

        // Feature Used: NSItemProvider.loadObject(ofClass:completionHandler:)
        // This native Apple API synchronously returns a Progress object tracking real download telemetry from iCloud/Library!
        let nativeProgress = itemProvider.loadObject(ofClass: UIImage.self) { [weak self] (object, error) in
            guard let self else { return }

            if let error {
                Task { @MainActor in
                    self.statusLabel.text = "Download Failed: \(error.localizedDescription)"
                    self.progressBar.isHidden = true
                }
                return
            }

            // Strict Concurrency verification: Extract the asset image template safely before actor transition
            guard let fullSizeImage = object as? UIImage else { return }

            Task { @MainActor in
                self.progressBar.isHidden = true
                self.statusLabel.isHidden = true
                self.imageView.image(fullSizeImage)
            }
        }

        // Feature Used: KVO Observation over native Progress.fractionCompleted metric updates
        // NO SIMULATION: We pipe the raw hardware/network fraction values directly into the progress UI node!
        progressObservation = nativeProgress.observe(\.fractionCompleted, options: [.new]) { [weak self] progress, change in
            guard let self, let newValue = change.newValue else { return }
            Task { @MainActor in
                self.progressBar.setProgress(Float(newValue), animated: true)
                let percentage = Int(newValue * 100)
                self.statusLabel.text = "Streaming original asset from iCloud repository... \(percentage)%"
            }
        }
    }
}
