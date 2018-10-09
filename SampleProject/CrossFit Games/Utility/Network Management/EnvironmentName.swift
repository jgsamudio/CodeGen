//
//  EnvironmentName.swift
//  CrossFit Games
//
//  Created by Malinka S on 9/22/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import Foundation

/// An enum to represent the environment names
enum EnvironmentName: String {

    case authBeta = "Authorization Beta"
    case authProd = "Authorization Production"
    case generalProd = "Production"
    case generalStageTemp = "Staging Temp"
    case generalStage = "Staging"

    init?(name: String) {
        switch name {
        case "authBeta":
            self = .authBeta
        case "authProd":
            self = .authProd
        case "generalProd":
            self = .generalProd
        case "generalStageTemp":
            self = .generalStageTemp
        case "generalStage":
            self = .generalStage
        default:
            return nil
        }
    }

    /// Converts an environment name to string
    ///
    /// - Parameter name: environment name
    /// - Returns: converted string
    static func convertToString(name: EnvironmentName) -> String {
        switch name {
        case .authBeta:
            return "authBeta"
        case .authProd:
            return "authProd"
        case .generalProd:
            return "generalProd"
        case .generalStageTemp:
            return "generalStageTemp"
        case .generalStage:
            return "generalStage"
        }
    }

}
