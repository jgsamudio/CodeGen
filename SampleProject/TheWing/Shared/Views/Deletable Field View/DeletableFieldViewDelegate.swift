//
//  DeletableFieldViewDelegate.swift
//  TheWing
//
//  Created by Ruchi Jain on 5/18/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation

protocol DeletableFieldViewDelegate: class {
    
    /// Notifies delegate that the delete action was taken.
    func deleteSelected(_ deletableFieldView: DeletableFieldView)

}
