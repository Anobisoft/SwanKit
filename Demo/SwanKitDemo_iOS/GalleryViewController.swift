//
//  GalleryViewController.swift
//  SwanKitDemo
//
//  Created by Stanislav Pletnev on 2026-07-18.
//  Copyright © 2026 Anobisoft. Licensed under the MIT License.
//

import UIKit
import PhotosUI
import SwanKit

/// A MainActor-isolated workspace controller managing full-screen media collection streams,
/// asset tracking dictionaries, navigation bar triggers, and native progress item delivery.
@MainActor
final class GalleryViewController: UIViewController {

    // MARK: - Core Properties

    private lazy var mainView = GalleryView()

    // Feature Used: ImagePicker hardware layer abstraction bridging AVFoundation and PhotoKit seamlessly
    private let imagePicker = ImagePicker()

    // Feature Used: Cache<Key, Value> thread-safe memory retention subsystem mapped tightly to systemic asset IDs
    private let internalCache = Cache<String, UIImage>()

    /// A structured ledger tracking the sequential array order of original picker results elements.
    private var pickerResults: [PHPickerResult] = []

    /// A structured ledger tracking the sequential array order of active preview asset keys.
    private var previewIDs: [String] = []

    /// A localized reactive collection dictionary storing loaded preview images linked straight to their identifier tokens.
    private var previews: [String: UIImage] = [:]

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
        title = "Gallery Workspace"

        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .camera,
            target: self,
            action: #selector(didTapCamera)
        )

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Add Media",
            style: .plain,
            target: self,
            action: #selector(didTapGallery)
        )
    }

    private func setupCollectionView() {
        mainView.collectionView.register(MediaPreviewCell.self, forCellWithReuseIdentifier: "MediaCell")
        mainView.collectionView.dataSource = self
        mainView.collectionView.delegate = self
    }

    private func setupControlActions() {
        // Fixed: cancelsTouchesInView set to false prevents interaction locks on the active UICollectionView hierarchy bounds.
        let tap = UITapGestureRecognizer(target: mainView, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        mainView.addGestureRecognizer(tap)
    }

    // MARK: - Subsystem Interaction Handlers

    @objc private func didTapCamera() {
        Task {
            await imagePicker.presentCameraCapture(on: self, with: .default) { [weak self] result in
                guard let self else { return }
                switch result {
                case .cancelled:
                    self.mainView.statusLabel.text("Camera Session: Cancelled or Access Denied.")
                case .camera(let capturedImage):
                    let uniqueCameraID = "camera_capture_\(UUID().uuidString)"

                    // Сохраняем в локальные массивы и кэш SwanKit
                    self.previewIDs.append(uniqueCameraID)
                    self.previews[uniqueCameraID] = capturedImage
                    self.internalCache[uniqueCameraID] = capturedImage

                    self.mainView.collectionView.reloadData()
                    self.mainView.statusLabel.text("Camera Session: Success! Added frame token directly to workspace.")
                case .pickerSingle, .pickerMultiple:
                    assertionFailure("ImagePicker anomaly: Unexpected gallery asset trigger inside hardware camera track context.")
                }
            }
        }
    }

    @objc private func didTapGallery() {
        Task {
            var config = ImagePicker.LibraryConfig()
            config.selectionLimit = 0 // Unlimited batch selections configuration metrics

            await imagePicker.presentLibrary(on: self, with: config) { [weak self] result in
                guard let self else { return }
                switch result {
                case .cancelled:
                    self.mainView.statusLabel.text("Library Picker: Cancelled or Access Denied.")

                case .pickerSingle(let phResult):
                    let cacheKey = phResult.assetIdentifier ?? phResult.itemProvider.description
                    self.extractAndAppendPreviewImage(assetID: cacheKey, provider: phResult.itemProvider)

                case .pickerMultiple(let results):
                    self.mainView.statusLabel.text("Library Picker: Batch loading \(results.count) items into layout...")
                    for result in results {
                        let cacheKey = result.assetIdentifier ?? result.itemProvider.description
                        self.extractAndAppendPreviewImage(assetID: cacheKey, provider: result.itemProvider)
                    }

                case .camera:
                    assertionFailure("ImagePicker anomaly: Unexpected camera trigger inside gallery picker track context.")
                }
            }
        }
    }

    // MARK: - Native Asynchronous Preview Extraction with Full-Size Fallback

    /// Extracts a lightweight built-in thumbnail asset from the system provider using native async throws signatures.
    /// If the native preview extraction fails or is invalid, automatically falls back to streaming the full asset data.
    private func extractAndAppendPreviewImage(assetID: String, provider: NSItemProvider) {
        Task {
            // Plan A: Try to fetch the lightning-fast built-in thumbnail natively using optional try
            if let codingObject = try? await provider.loadPreviewImage(),
               let image = codingObject as? UIImage {
                self.appendImageToWorkspace(image, assetID: assetID, source: "loadPreviewImage")
                return // Success! Exit the task safely
            }

            // Plan B: The preview is missing, unreadable, or invalid -> Load the full asset directly as a fallback!
            guard provider.canLoadObject(ofClass: UIImage.self) else {
                self.mainView.statusLabel.text("Library Streams Failure: Unsupported asset data format.")
                return
            }

            provider.loadObject(ofClass: UIImage.self) { [weak self] (object, error) in
                if let error {
                    Task { @MainActor in
                        self?.mainView.statusLabel.text("Library Streams Total Failure: \(error.localizedDescription)")
                    }
                    return
                }

                guard let fullImage = object as? UIImage else { return }

                Task { @MainActor in
                    self?.appendImageToWorkspace(fullImage, assetID: assetID, source: "loadObject Full Fallback")
                }
            }
        }
    }

    /// Internal synchronized core method to update state dictionaries and refresh the active collection stream.
    private func appendImageToWorkspace(_ image: UIImage, assetID: String, source: String) {
        if !self.previewIDs.contains(assetID) {
            self.previewIDs.append(assetID)
        }

        self.previews[assetID] = image
        self.internalCache[assetID] = image

        self.mainView.collectionView.reloadData()
        self.mainView.statusLabel.text("Library Streams: Successfully rendered thumbnail via \(source) pipeline.")
    }

}

// MARK: - UICollectionViewDataSource Implementation Block

extension GalleryViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return previewIDs.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MediaCell", for: indexPath) as? MediaPreviewCell else {
            return UICollectionViewCell()
        }

        let cacheKey = previewIDs[indexPath.item]
        if let image = previews[cacheKey] {
            cell.imageView.image(image)
        }
        return cell
    }
}

// MARK: - UICollectionViewDelegate Execution Pipes

extension GalleryViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.item < previewIDs.count else { return }

        let targetID = previewIDs[indexPath.item]
        mainView.statusLabel.text("Media Intercepted: Requesting full asset streaming routing metrics for ID '\(targetID)'...")

        // Создаем легитимный NSItemProvider на основе сохраненной в кэше картинки.
        // Если это была фотка из галереи, провайдер честно отдаст данные, если с камеры — завернет готовый слепок.
        let provider = NSItemProvider(object: previews[targetID] ?? UIImage())

        let detailVC = DetailViewController(itemProvider: provider)
        self.present(detailVC, animated: true)
    }
}
