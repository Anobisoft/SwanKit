//
//  MainViewController.swift
//  SwanKitDemo
//
//  Created by Stanislav Pletnev on 2026-07-16.
//  Copyright © 2026 Anobisoft. Licensed under the MIT License.
//

import UIKit
import SwanKit

/// A MainActor-isolated orchestrator controller handling hardware interactions,
/// cache processing, and dynamic collection view workflows for the SwanKit interactive showcase.
@MainActor
final class MainViewController: UIViewController {

    // MARK: - Core Properties

    // Feature Fixed: Using a lazy variable to respect and preserve UIKit's native lazy memory allocation mechanics.
    private lazy var mainView = MainView()

    // Feature Used: ImagePicker hardware layer abstraction bridging AVFoundation and PhotoKit seamlessly
    private let imagePicker = ImagePicker()

    // Feature Used: Cache<Key, Value> thread-safe, strict concurrency-compliant memory retention subsystem
    private let internalCache = Cache<String, UIImage>()

    /// The local reactive state array storing thumbnails displayed inside the MainView's collection panel.
    private var mediaItems: [UIImage] = []

    // MARK: - Controller Lifecycle

    override func loadView() {
        self.view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupCollectionView()
        setupControlActions()
        mainView.applyShadowConfiguration()
    }

    // MARK: - Architectural Configurations

    private func setupNavigation() {
        title = "SwanKit Demo"
    }

    private func setupCollectionView() {
        mainView.collectionView.register(MediaPreviewCell.self, forCellWithReuseIdentifier: "MediaCell")
        mainView.collectionView.dataSource = self
        mainView.collectionView.delegate = self
    }

    private func setupControlActions() {
        mainView.cameraButton.addTarget(self, action: #selector(didTapCamera), for: .touchUpInside)
        mainView.galleryButton.addTarget(self, action: #selector(didTapGallery), for: .touchUpInside)
        mainView.alertButton.addTarget(self, action: #selector(didTapAlert), for: .touchUpInside)
        mainView.cacheButton.addTarget(self, action: #selector(didTapCacheInspect), for: .touchUpInside)

        let tap = UITapGestureRecognizer(target: mainView, action: #selector(UIView.endEditing))
        mainView.addGestureRecognizer(tap)
    }

    // MARK: - Subsystem Interaction Handlers

    @objc private func didTapCamera() {
        imagePicker.presentCamera(on: self, with: .default) { [weak self] result in
            guard let self else { return }
            switch result {
            case .cancelled:
                self.mainView.statusLabel.text("Camera Session: Cancelled by user")
            case .camera(let capturedImage):
                self.mediaItems.append(capturedImage)
                self.mainView.collectionView.reloadData()

                self.internalCache["latest_capture"] = capturedImage
                self.mainView.statusLabel.text("Camera Session: Success! Added to collection stream.")
            case .pickerSingle, .pickerMultiple:
                assertionFailure("ImagePicker anomaly: Unexpected gallery asset trigger inside hardware camera track context.")
            }
        }
    }

    @objc private func didTapGallery() {
        var config = ImagePicker.LibraryConfig()
        config.selectionLimit = 0

        imagePicker.presentLibrary(on: self, with: config) { [weak self] result in
            guard let self else { return }
            switch result {
            case .cancelled:
                self.mainView.statusLabel.text("Library Picker: Cancelled by user")

            case .pickerSingle(let phResult):
                self.extractAndAppendImage(from: phResult.itemProvider)

            case .pickerMultiple(let results):
                self.mainView.statusLabel.text("Library Picker: Batch loading \(results.count) items...")
                for result in results {
                    self.extractAndAppendImage(from: result.itemProvider)
                }

            case .camera:
                assertionFailure("ImagePicker anomaly: Unexpected camera trigger inside gallery picker track context.")
            }
        }
    }

    @objc private func didTapAlert() {
        // Feature Used: UIAlertController+Helper extension clean action cascading injection metrics routing path
        let alert = UIAlertController(title: "SwanKit Notification", message: "This is a clean, MainActor-isolated modular overlay view controller presented natively.")
        alert.addAction(title: "Acknowledge", style: .default)

        self.present(alert, animated: true)
        mainView.statusLabel.text("Alert Overlay: Presented successfully")
    }

    @objc private func didTapCacheInspect() {
        if let cachedImage = internalCache["latest_capture"] {
            mainView.statusLabel.text("Cache Inspection: 'latest_capture' found!\nRAM Footprint Cost: \(cachedImage.cost) bytes")
        } else {
            mainView.statusLabel.text("Cache Inspection: Empty.\nNo media has been saved in this session yet.")
        }
    }

    // MARK: - Concurrency-Safe Asset Extraction

    private func extractAndAppendImage(from provider: NSItemProvider) {
        guard provider.canLoadObject(ofClass: UIImage.self) else { return }

        provider.loadObject(ofClass: UIImage.self) { [weak self] (object, _) in
            guard let image = object as? UIImage else { return }

            Task { @MainActor in
                guard let self else { return }
                self.mediaItems.append(image)
                self.internalCache["latest_capture"] = image
                self.mainView.collectionView.reloadData()
                self.mainView.statusLabel.text("Library Streams: Successfully appended new asset node data.")
            }
        }
    }
}

// MARK: - UICollectionViewDataSource Implementation Block

extension MainViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mediaItems.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MediaCell", for: indexPath) as? MediaPreviewCell else {
            return UICollectionViewCell()
        }
        let image = mediaItems[indexPath.item]
        cell.imageView.image(image)
        return cell
    }
}

// MARK: - UICollectionViewDelegate Execution Pipes

extension MainViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedThumbnail = mediaItems[indexPath.item]
        mainView.statusLabel.text("Media Intercepted: Initializing modal download pipeline for item indices slot #\(indexPath.item)...")

        // Feature Used: UIAlertController+Helper extension utilizing crisp, flat native action chaining proxies hooks
        let downloadAlert = UIAlertController(title: "Downloading Full Asset", message: "Simulating secure background asset streaming metrics pipeline from remote content repositories...")

        downloadAlert.addAction(title: "Simulate Download Success", style: .default) { [weak self] _ in
            self?.mainView.statusLabel.text("Download Finished! Cached active frame weight metrics asset footprint: \(selectedThumbnail.cost) bytes.")
        }
        downloadAlert.addAction(title: "Abort Session", style: .cancel)

        self.present(downloadAlert, animated: true)
    }
}
