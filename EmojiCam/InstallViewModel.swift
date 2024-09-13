//
//  InstallViewModel.swift
//  EmojiCam
//
//  Created by Fazekas, Gergo on 07.09.2024.
//

import Foundation
import SystemExtensions

enum InstallAction {
    case install
    case uninstall
}

final class InstallViewModel: NSObject, ObservableObject {
    @Published var logText: String = "Log Text"

    func onAction(_ action: InstallAction) {
        switch action {
        case .install:
            installExtension()
        case .uninstall:
            uninstallExtension()
        }
    }
}

private extension InstallViewModel {
    func installExtension() {
        guard let extensionId = extensionBundle?.bundleIdentifier else { return }

        let activationRequest = OSSystemExtensionRequest.activationRequest(forExtensionWithIdentifier: extensionId, queue: .main)
        activationRequest.delegate = self
        OSSystemExtensionManager.shared.submitRequest(activationRequest)
    }

    func uninstallExtension() {
        guard let extensionId = extensionBundle?.bundleIdentifier else { return }

        let deactivationRequest = OSSystemExtensionRequest.deactivationRequest(forExtensionWithIdentifier: extensionId, queue: .main)
        deactivationRequest.delegate = self
        OSSystemExtensionManager.shared.submitRequest(deactivationRequest)
    }

    private var extensionBundle: Bundle? {
        let extensionDirectoryUrl = URL(filePath: "Contents/Library/SystemExtensions", relativeTo: Bundle.main.bundleURL)
        let extensionURLs: [URL]
        do {
            extensionURLs = try FileManager.default.contentsOfDirectory(at: extensionDirectoryUrl, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
        } catch {
            fatalError("Failed to get the contents of \(extensionDirectoryUrl.absoluteString): \(error.localizedDescription)")
        }

        guard let extensionUrl = extensionURLs.first else {
            fatalError("Failed to find any system extensions")
        }

        guard let extensionBundle = Bundle(url: extensionUrl) else {
            fatalError("Failed to create a bundle with URL \(extensionUrl.absoluteString)")
        }

        return extensionBundle
    }
}

extension InstallViewModel: OSSystemExtensionRequestDelegate {
    func request(_ request: OSSystemExtensionRequest, actionForReplacingExtension existing: OSSystemExtensionProperties, withExtension ext: OSSystemExtensionProperties) -> OSSystemExtensionRequest.ReplacementAction {
        logText = "Replacing extension version \(existing.bundleShortVersion) with \(ext.bundleShortVersion)"
        return .replace
    }
    
    func requestNeedsUserApproval(_ request: OSSystemExtensionRequest) {
        logText = "Extension needs user approval"
    }

    func request(_ request: OSSystemExtensionRequest, didFinishWithResult result: OSSystemExtensionRequest.Result) {
        logText = "Request finished with result: \(result.rawValue)"
    }

    func request(_ request: OSSystemExtensionRequest, didFailWithError error: Error) {
        logText = "Request failed: \(error)"
    }
}
