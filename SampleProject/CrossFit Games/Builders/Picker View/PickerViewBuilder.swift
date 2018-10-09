//
//  PickerViewBuilder.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 10/31/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import UIKit

/// Builder for a generic picker view.
struct PickerViewBuilder: Builder {

    // MARK: - Public Properties
    
    /// View model for the created view.
    let pickerViewModel: PickerViewModel

    // MARK: - Public Functions
    
    func build() -> UIViewController {
        let pickerViewController: PickerViewController = UIStoryboard(name: "PickerView", bundle: nil).instantiateViewController()
        pickerViewController.viewModel = pickerViewModel
        pickerViewController.modalPresentationStyle = .overFullScreen
        pickerViewController.modalTransitionStyle = .crossDissolve

        return pickerViewController
    }

}
