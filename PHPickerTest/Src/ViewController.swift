//
//  ViewController.swift
//  PHPickerTest
//
//  Created by Tamim_Dari on 1/17/24.
//

import UIKit

class ViewController: UIViewController {
    
    private var picker: Picker!
    override func viewDidLoad() {
        super.viewDidLoad()
        picker = Picker()
    }

    @IBAction func pickerButtonPressed(_ sender: Any) {
        picker.delegate = self
        picker.present(on: self)
    }
    
}

extension ViewController: PickerDelegate {
    func pickedMedias(_ medias: [Media]) {
        for media in medias {
            print("Event: picked media with ID: \(String(describing: media.getIdentifier())) and image: \(media.getImage())")
        }
    }
}

