//
//  PickerViewController.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 10/31/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import UIKit

/// View controller for picking specific values.
final class PickerViewController: UIViewController {

    @IBOutlet private weak var pickerView: UIPickerView!

    var viewModel: PickerViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.dataSource = self
        pickerView.delegate = self
        
        viewModel.components.enumerated().forEach { (component) in
            if let selectedRow = component.element.selectedRow,
                let index = component.element.displayValues.index(of: selectedRow) {
                pickerView.selectRow(index, inComponent: component.offset, animated: false)
            } else {
                pickerView.selectRow(0, inComponent: component.offset, animated: false)
            }
        }
    }

    @IBAction private func close() {
        dismiss(animated: true, completion: nil)
    }

}

// MARK: - UIPickerViewDataSource
extension PickerViewController: UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return viewModel.components.count
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.components[component].displayValues.count
    }

}

// MARK: - UIPickerViewDelegate
extension PickerViewController: UIPickerViewDelegate {

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let value = viewModel.components[component].displayValues[row].displayValue
        return value
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        viewModel.components[component].displayValues[row].callback()
    }

}
