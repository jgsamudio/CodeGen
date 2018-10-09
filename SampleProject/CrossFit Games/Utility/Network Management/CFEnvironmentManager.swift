//
//  CFEnvironmentManager.swift
//  CrossFit Games
//
//  Created by Malinka S on 9/21/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import Foundation

/// Manages environment configurations
/// Reads available base URLs from config.plist
/// By default stores the Auth - Prod and General - Prod
/// User selections are saved in user defaults
final class CFEnvironmentManager: HTTPEnvironmentManager {

    /// Stores the current environment for general APIs
    var currentGeneralEnvironment: HTTPEnvironment! {
        if let environmentString = UserDefaultsManager.shared.getValue(byKey: .currentGeneralEnvironment) as? String {
            return environments[environmentString]
        }

        return nil
    }

    /// Stores the current environment for auth APIs
    var currentAuthEnvironment: HTTPEnvironment! {
        if let environmentString = UserDefaultsManager.shared.getValue(byKey: .currentAuthEnvironment) as? String {
            return environments[environmentString]
        }
        
        return nil
    }

    /// Stores all the available environments
    var environments: [String: HTTPEnvironment] = [:]

    /// Manages the shared instance (singleton) of CFEnvironmentManager
    static var shared: CFEnvironmentManager = CFEnvironmentManager()

    private init() {
        prepareEnvironments()
    }

    /// Reads available environments from file and stores them in environments
    private func prepareEnvironments() {
        /// Reads base URLs from file
        if let availableEnvironments = readBaseURLsFromFile() {
            for (environment, url) in availableEnvironments {
                let environmentType: EnvironmentType
                let name: EnvironmentName

                switch environment {
                case EnvironmentName.convertToString(name: .authProd):
                    environmentType = .auth
                    name = .authProd
                case EnvironmentName.convertToString(name: .authBeta):
                    environmentType = .auth
                    name = .authBeta
                case EnvironmentName.convertToString(name: .generalStageTemp):
                    environmentType = .general
                    name = .generalStageTemp
                case EnvironmentName.convertToString(name: .generalProd):
                    environmentType = .general
                    name = .generalProd
                case EnvironmentName.convertToString(name: .generalStage):
                    environmentType = .general
                    name = .generalStage
                default:
                    continue
                }

                let title = name.rawValue

                if let environmentURL = URL(string: url) {
                    let environmentInstance = CFEnvironment(title: title,
                                                            baseURL: environmentURL,
                                                            environmentType: environmentType,
                                                            environmentName: name)
                    /// Appends environment, ex: [Authorization Production] = "https://mainsite-stage.crossfit.com/sso/api/v1/"
                    environments[title] = environmentInstance

                    /// Checks if it's a general environment,
                    /// and if it doesn't exist in user defaults,
                    /// the prod value will be stored
                    if environmentInstance.environmentType == .general &&
                        environmentInstance.title == EnvironmentName.generalProd.rawValue {
                        if currentGeneralEnvironment == nil {
                            persistUserPreferredEnvironment(userDefaultsKey: .currentGeneralEnvironment, value: name.rawValue)
                        }
                    } else if environmentInstance.environmentType == .auth &&
                        environmentInstance.title == EnvironmentName.authProd.rawValue {

                        /// Checks if it's a auth environment,
                        /// and if it doesn't exist in user defaults,
                        /// the prod value will be stored
                        if currentAuthEnvironment == nil {
                            persistUserPreferredEnvironment(userDefaultsKey: .currentAuthEnvironment, value: name.rawValue)
                        }
                    }
                }
            }
        }
    }

    /// Persists user preeferred function in user defaults
    ///
    /// - Parameters:
    ///   - userDefaultsKey: key of the relevant userdefaults value
    ///   - value: value to be saved
    func persistUserPreferredEnvironment(userDefaultsKey: UserDefaultsKey, value: String) {
        UserDefaultsManager.shared.setValue(withKey: userDefaultsKey, value: value)
    }

    /// Reads URLs from file
    ///
    /// - Returns: dictionary of available environments and relevant base URLs
    private func readBaseURLsFromFile() -> [String: String]? {
        if let dictionary = StandardFileManager.readPropertyFile(byPath: "config") as? [String: [String: String]]? {
            if let environmentsDictionary = dictionary?["environments"] {
                return environmentsDictionary
            }
        }
        return nil
    }

}
