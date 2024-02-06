//
//  Media.swift
//  PHPickerTest
//
//  Created by Tamim Dari Chowdhury on 1/20/24.
//

import UIKit

class Media {
    private let image: UIImage
    private let identifier: String?
    init(image: UIImage, identifier: String? = nil){
        self.image = image
        self.identifier = identifier
    }
    public func getImage() -> UIImage {
        return self.image
    }
    public func getIdentifier() -> String? {
        return self.identifier
    }
}
