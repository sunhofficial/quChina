//
//  LiveTextView.swift
//  quChina
//
//  Created by 235 on 1/20/24.
//

import SwiftUI
import VisionKit
import Combine
@MainActor
struct LiveTextView: UIViewControllerRepresentable {
    static let textDataType: DataScannerViewController.RecognizedDataType = .text(languages: ["zh-Hans-CN"])
    @EnvironmentObject var container: DIContainer
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {

    }
    
    let interaction = ImageAnalysisInteraction()
    var scannerViewController: DataScannerViewController = DataScannerViewController(
        recognizedDataTypes: [LiveTextView.textDataType],
        qualityLevel: .accurate,
        recognizesMultipleItems: true,
        isHighFrameRateTrackingEnabled: true,
        isPinchToZoomEnabled: true,
        isHighlightingEnabled: true)

    func makeUIViewController(context: Context) -> some DataScannerViewController {
        scannerViewController.delegate = context.coordinator
        try? scannerViewController.startScanning()
        return scannerViewController
    }
    static func dismantleUIViewController(_ uiViewController: DataScannerViewController, coordinator: Coordinator) {
        uiViewController.stopScanning()
    }
    func makeCoordinator() -> Coordinator {
        return Coordinator(self, container: container)
    }
    class Coordinator: NSObject, DataScannerViewControllerDelegate{
        var parent: LiveTextView
        var container: DIContainer
        var touchedItems: [RecognizedItem] = []
        var roundBoxMappings: [UUID: UIView] = [:]
        private var subscriptions = Set<AnyCancellable>()
//        @Binding var touchItem: RecognizedItem
        init(_ parent: LiveTextView, container: DIContainer) {
            self.parent = parent
            self.container = container
//            self._touchItem  = touchItem
        }
        func labelDidTap(_ text: String)  {
            container.services.speechRecognizer.speechSentences(text, langType: .chinese)
        }
        // DataScannerViewControllerDelegate - methods starts here
         func dataScanner(_ dataScanner: DataScannerViewController, didAdd addedItems: [RecognizedItem], allItems: [RecognizedItem]) {
//             processAddedItems(items: addedItems)
         }

         func dataScanner(_ dataScanner: DataScannerViewController, didRemove removedItems: [RecognizedItem], allItems: [RecognizedItem]) {
             //ToDo
             processRemovedItems(items: removedItems)
         }

         func dataScanner(_ dataScanner: DataScannerViewController, didUpdate updatedItems: [RecognizedItem], allItems: [RecognizedItem]) {
             //ToDo
             processUpdatedItems(items: updatedItems)
         }

         func dataScanner(_ dataScanner: DataScannerViewController, didTapOn item: RecognizedItem) {
             //ToDo
             if touchedItems.contains(where: { $0.id == item.id }) {
                 readItem(item: item)
             } else {
                 touchedItems.append(item)
                 processItem(item: item)
             }

         }

        func processAddedItems(items: [RecognizedItem]) {
            for item in items {
                processItem(item: item)
            }
        }

        func processRemovedItems(items: [RecognizedItem]) {
            for item in items {
                removeBoxFromItem(item: item)
            }
        }
        func readItem(item: RecognizedItem) {
            switch item {
            case .text(let text):
                container.services.speechRecognizer.speechSentences(String.extractChinese(from: text.transcript), langType: .chinese)
            default:
                break
            }
        }
        func processItem(item: RecognizedItem) {
            switch item {
            case .text(let text):
                let frame = self.getRoundBoxFrame(item: item)
//                let speakerBtn = addSpeakButton(text: text.transcript, item: item)
//                parent.scannerViewController.overlayContainerView.addSubview(speakerBtn)
                container.services.papagoService.postTranslation(source: "zh-CN", target: "ko", text: text.transcript)
                    .receive(on: DispatchQueue.main)
                    .sink { completion in
                        print(completion)
                    } receiveValue: { korean in
                        self.addBoxToItem(frame: frame, text: korean, item: item)
                    }.store(in: &subscriptions)
            default:
                break
            }
        }

        func processUpdatedItems(items: [RecognizedItem]) {
            for item in items {
                updateRoundBoxToItem(item: item)
            }
        }
//        func addSpeakButton(text: String, item: RecognizedItem) -> SpeakerButton{
//            let button = SpeakerButton()
//            button.setImage(UIImage(systemName: "speaker.wave.2"), for: .normal)
//            button.frame = CGRect(x: item.bounds.topLeft.x - 10, y: (item.bounds.bottomLeft.y + item.bounds.topLeft.y) / 2, width: 30, height: 30)
//            button.text = text
//            button.addTarget(self, action: #selector(speakTap(_:)), for: .touchUpInside)
//            return button
//        }
//        @objc func speakTap(_ sender: SpeakerButton) {
//            container.services.speechRecognizer.speechSentences(sender.text, langType: .chinese)
//        }
         // DataScannerViewControllerDelegate - methods ends here
        func addBoxToItem(frame: CGRect, text: String, item: RecognizedItem) {
            let roundRectView = RoundedRectLabel(frame: frame)
//            roundRectView.delegate = self
            roundRectView.setText(text: text)
            parent.scannerViewController.overlayContainerView.addSubview(roundRectView)
            roundBoxMappings[item.id] = roundRectView
        }
        func removeBoxFromItem(item: RecognizedItem) {
            if let roundBoxView = roundBoxMappings[item.id] {
                if roundBoxView.superview != nil {
                    touchedItems.removeAll { $0.id == item.id }
                    roundBoxView.removeFromSuperview()
                    roundBoxMappings.removeValue(forKey: item.id)
                }
            }
        }
        func updateRoundBoxToItem(item: RecognizedItem) {
                 if let roundBoxView = roundBoxMappings[item.id] {
                     if roundBoxView.superview != nil {
                         let frame = getRoundBoxFrame(item: item)
                         roundBoxView.frame = frame
                     }
                 }
             }

        func getRoundBoxFrame(item: RecognizedItem) -> CGRect {
            let frame = CGRect(
                x: item.bounds.topLeft.x,
                y: item.bounds.topLeft.y,
                width: abs(item.bounds.topRight.x - item.bounds.topLeft.x) + 15,
                height: abs(item.bounds.topLeft.y - item.bounds.bottomLeft.y) + 15
            )
            return frame
        }
    }
}


