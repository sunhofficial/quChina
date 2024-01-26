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
    var papagoService: PapagoSevice
    init(papagoService: PapagoSevice) {
        self.papagoService = papagoService
    }
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {

    }
    
    let interaction = ImageAnalysisInteraction()
    var scannerViewController: DataScannerViewController = DataScannerViewController(recognizedDataTypes: [LiveTextView.textDataType],qualityLevel: .accurate, recognizesMultipleItems: true, isHighFrameRateTrackingEnabled: true, isHighlightingEnabled: true)

    func makeUIViewController(context: Context) -> some DataScannerViewController {
        scannerViewController.delegate = context.coordinator
        try? scannerViewController.startScanning()
        return scannerViewController
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(self, papagoService: papagoService)
    }
    class Coordinator: NSObject, DataScannerViewControllerDelegate{
        var parent: LiveTextView
        var papagoService: PapagoSevice
        var roundBoxMappings: [UUID: UIView] = [:]
        private var subscriptions = Set<AnyCancellable>()
        init(_ parent: LiveTextView, papagoService: PapagoSevice) {
            self.parent = parent
            self.papagoService = papagoService
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
             processItem(item: item)
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

        func processItem(item: RecognizedItem) {
            switch item {
            case .text(let text):
                print(text.observation) 
                print(text.transcript)
                papagoService.postTranslation(source: "zh-CN", target: "ko", text: text.transcript)
                    .receive(on: DispatchQueue.main)
                    .sink { completion in
                        print(completion)
                    } receiveValue: { korean in
                        print(korean)
                        let frame = self.getRoundBoxFrame(item: item)
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

         // DataScannerViewControllerDelegate - methods ends here
        func addBoxToItem(frame: CGRect, text: String, item: RecognizedItem) {
            let roundRectView = RoundedRectLabel(frame: frame)
            roundRectView.setText(text: text)
            parent.scannerViewController.overlayContainerView.addSubview(roundRectView)
            roundBoxMappings[item.id] = roundRectView
        }
        func removeBoxFromItem(item: RecognizedItem) {
            if let roundBoxView = roundBoxMappings[item.id] {
                if roundBoxView.superview != nil {
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
