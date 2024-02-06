//
//  Picker.swift
//  PHPickerTest
//
//  Created by Tamim_Dari on 1/17/24.
//

import Foundation
import PhotosUI

protocol PickerDelegate: NSObjectProtocol {
    func pickedMedias(_ medias: [Media])
}

class Picker: NSObject {
    weak var delegate: PickerDelegate?
    private weak var parentVC: UIViewController? = nil
    
    override init() {
        super.init()
    }
    
    func present(on viewController: UIViewController) {
        var configuration = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
        configuration.filter = .images
        configuration.selectionLimit = 10
        let picker = PHPickerViewController(configuration: configuration)
        
        picker.delegate = self
        picker.modalPresentationStyle = .fullScreen
        picker.presentationController?.delegate = self
        self.parentVC = viewController
        DispatchQueue.main.async {
            self.parentVC?.present(picker, animated: true)
        }

    }
}

extension Picker: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.delegate = nil
        picker.dismiss(animated: true) { [weak self] in
            
            let dispatchGroup: DispatchGroup = DispatchGroup()
            var orderIDArr: [String] = []
            var orderMap = [String : Media]()

            for result in results {
                let uniqueID = result.assetIdentifier ?? UUID().uuidString
                orderIDArr.append(uniqueID)
                dispatchGroup.enter()
                result.itemProvider.loadFileRepresentation(forTypeIdentifier: UTType.image.identifier) { url, error in
                    if let url = url{
                        if let filter = CIFilter(imageURL: url),
                           let ciImage = filter.outputImage{
                            let image = UIImage(ciImage: ciImage)
                            orderMap[uniqueID] = Media(image: image, identifier: result.assetIdentifier)
                            dispatchGroup.leave()
                        }
                    } else {
                        dispatchGroup.leave()
                    }
                }
            }
            dispatchGroup.notify(queue: .main) { [weak self] in
                var arrMedia: [Media] = []
                for uid in orderIDArr {
                    if let media = orderMap[uid] {
                        arrMedia.append(media)
                    }
                }
                self?.delegate?.pickedMedias(arrMedia)
            }
            
        }
    }
    
    
}


extension Picker: UIAdaptivePresentationControllerDelegate {
    func presentationControllerWillDismiss(_ presentationController: UIPresentationController) {
        DispatchQueue.main.async { [weak self] in
            self?.delegate?.pickedMedias([])
        }
    }
}
