//
//  DebugMenu.swift
//  CrossFit Games
//
//  Created by Malinka S on 9/22/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

#if DEBUG || ALPHA || BETA
    import Foundation
    import Yoshi
    import Instabug
    import Simcoe

    private final class DatePickerMenu: YoshiDateSelectorMenu {

    // MARK: - Public Properties
    
        let title: String = "Select date 📆"

        var subtitle: String? {
            return CustomDateFormatter.mediumDateFormatter.string(from: DatePicker.shared.date)
        }

        var selectedDate: Date {
            get {
                return DatePicker.shared.date
            }
            set {
                DatePicker.shared.date = newValue
            }
        }

        var didUpdateDate: (Date) -> Void = { date in
            DatePicker.shared.date = date
        }

    }

    /// Debug menu for the application.
    struct DebugMenu {

    // MARK: - Private Properties
    
        private static var cacheReset: YoshiActionMenu {
            let menu = YoshiActionMenu(title: "Reset cache 🔄", completion: {
                CFCache.default.reset()
            })
            return menu
        }

        private static var crashMenu: YoshiActionMenu {
            let menu = YoshiActionMenu(title: "Crash the app ☠️", completion: {
                CrashlyticsIntegration.shared.crash()
            })
            return menu
        }

        private static var instabugMenu: YoshiActionMenu {
            let menu = YoshiActionMenu(title: "Log a bug 🐞", completion: {
                InstabugIntegration.shared.invoke()
            })
            return menu
        }

        private static var logoutMenu: YoshiActionMenu {
            let menu = YoshiActionMenu(title: "Logout 👋", subtitle: "Deletes saved usernames & passwords", completion: {
                ServiceFactory.shared.createLogoutService().logout()

                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
                    UIApplication.shared.keyWindow?.rootViewController = RootViewBuilder().build()
                })
            })

            return menu
        }

        private static var netfoxMenu: YoshiActionMenu {
            NetfoxIntegration.shared.setup()
            let menu = YoshiActionMenu(title: "API 📡", completion: {
                NetfoxIntegration.shared.show()
            })
            return menu
        }

        private static var datePickerMenu: YoshiDateSelectorMenu {
            return DatePickerMenu()
        }

        private static var analyticsTestMenu: YoshiActionMenu {
            return YoshiActionMenu(title: "Analytics Test 📈",
                                   subtitle: "Logs: [`TestingUser`: `Pukey`], [`YoshiTriggered`, `Success`: `True`]",
                                   completion: {
                                    Simcoe.setUserAttribute(.yoshiUser,
                                                            value: "Pukey")
                                    Simcoe.track(event: .yoshiTriggered,
                                                 withAdditionalProperties: [.yoshiSuccess: "True"])
            })
        }

    // MARK: - Public Functions
    
        /// Sets up the debug menu, configuring instabug for bug reporting and providing an environment switcher
        /// for the application.
        static func setup() {
            /// Prepare environment menu items for the Yoshi menu
            let environmentMenuItems = prepareEnvironmentMenu()
            Yoshi.setupDebugMenu([environmentMenuItems.0, environmentMenuItems.1, createHomeDebugItem(), instabugMenu,
                                  logoutMenu, datePickerMenu, netfoxMenu, analyticsTestMenu, cacheReset,
                                  crashMenu,
                                  useDummyForKillSwitchMenu(),
                                  forceUpdateMenu(),
                                  killSwitchMenu(),
                                  mockExpiredAccessTokenMenu()],
                                 invocations: [YoshiInvocation.shakeMotionGesture])
        }

        // MARK: - Single Selection Menu Items

        private static func prepareEnvironmentMenu() -> (YoshiSingleSelectionMenu, YoshiSingleSelectionMenu) {
            var authEnvironments: [HTTPEnvironment] = []
            var generalEnvironments: [HTTPEnvironment] = []
            var authSingleSelectionItems: [YoshiSingleSelection] = []
            var generalSingleSelectionItems: [YoshiSingleSelection] = []
            var authEnvIndex = 0
            var authSelectedIndex = 0
            var generalEnvIndex = 0
            var generalSelectedIndex = 0

            let environments = CFEnvironmentManager.shared.environments
            let currentAuthEnvironment = CFEnvironmentManager.shared.currentAuthEnvironment
            let crrentGeneralEnvironment = CFEnvironmentManager.shared.currentGeneralEnvironment

            /// Iterates through all the environments and assigns
            /// to auth and genral environments respectively
            for (environmentName, environment) in environments {
                let url = environment.baseURL.absoluteString.removingPercentEncoding
                let selection = YoshiSingleSelection(title: environment.environmentName.rawValue, subtitle: url)

                switch environment.environmentType {
                case .auth:
                    authSingleSelectionItems.append(selection)
                    authEnvironments.append(environment)

                    if environmentName == currentAuthEnvironment?.environmentName.rawValue {
                        authSelectedIndex = authEnvIndex
                    }
                    authEnvIndex += 1
                case .general:
                    generalSingleSelectionItems.append(selection)
                    generalEnvironments.append(environment)

                    if environmentName == crrentGeneralEnvironment?.environmentName.rawValue {
                        generalSelectedIndex = generalEnvIndex
                    }
                    generalEnvIndex += 1
                }
            }

            /// Construct YoshiSingleSelectionMenu for auth environments.
            let authEnvironmentMenu = createAuthEnvironmentMenu(authEnvironments: authEnvironments,
                                                                authSelectedIndex: authSelectedIndex,
                                                                authSingleSelectionItems: authSingleSelectionItems)

            /// Construct YoshiSingleSelectionMenu for general environments.
            let generalEnvironmentMenu = createGeneralEnvironmentMenu(generalEnvironments: generalEnvironments,
                                                                      generalSelectedIndex: generalSelectedIndex,
                                                                      generalSingleSelectionItems: generalSingleSelectionItems)

            return (authEnvironmentMenu, generalEnvironmentMenu)
        }

        private static func createAuthEnvironmentMenu(authEnvironments: [HTTPEnvironment],
                                                      authSelectedIndex: Int,
                                                      authSingleSelectionItems: [YoshiSingleSelection]) -> YoshiSingleSelectionMenu {
            let authEnvironmentMenu = YoshiSingleSelectionMenu(title: "Auth Environment 🛠",
                                                               options: authSingleSelectionItems,
                                                               selectedIndex: authSelectedIndex,
                                                               didSelect: { selection in
                                                                for environment in authEnvironments
                                                                    where environment.environmentName.rawValue == selection.title {
                                                                        CFEnvironmentManager.shared.persistUserPreferredEnvironment(
                                                                            userDefaultsKey: .currentAuthEnvironment,
                                                                            value: selection.title)
                                                                        break
                                                                }
            })
            return authEnvironmentMenu
        }

        private static func useDummyForKillSwitchMenu() -> YoshiSingleSelectionMenu {
            let selection1 = YoshiSingleSelection(title: "On", subtitle: nil)
            let selection2 = YoshiSingleSelection(title: "Off", subtitle: nil)

            var selectedIndex = 1
            if let status = UserDefaultsManager.shared.getValue(byKey: .useDummyForKillSwitch) as? Bool,
                status {
                selectedIndex = 0
            }

            let killSwitchMenu = YoshiSingleSelectionMenu(title: "Use Dummy For Kill Switch ☠️",
                                                          options: [selection1, selection2],
                                                          selectedIndex: selectedIndex,
                                                          didSelect: { selection in
                                                            if selection.title == "On" {
                                                                UserDefaultsManager.shared.setValue(withKey: .useDummyForKillSwitch, value: true)
                                                            } else {
                                                                UserDefaultsManager.shared.setValue(withKey: .useDummyForKillSwitch, value: false)
                                                            }
            })
            return killSwitchMenu
        }

        private static func mockExpiredAccessTokenMenu() -> YoshiActionMenu {
            return YoshiActionMenu(title: "Mock expired access token ⏳",
                                   completion: {
                                    UserDefaultsManager.shared.setValue(withKey: .accessTokenExpirationDate,
                                                                        value: Date(timeIntervalSinceNow: -300))
            })
        }

        private static func forceUpdateMenu() -> YoshiSingleSelectionMenu {
            let selection1 = YoshiSingleSelection(title: "On", subtitle: nil)
            let selection2 = YoshiSingleSelection(title: "Off", subtitle: nil)
            var selectedIndex = 1
            if let status = UserDefaultsManager.shared.getValue(byKey: .forceAppUpdate) as? Bool,
            status {
                selectedIndex = 0
            }

            let appForceUpdateMenu = YoshiSingleSelectionMenu(title: "Force App Update",
                                                              options: [selection1, selection2],
                                                              selectedIndex: selectedIndex,
                                                              didSelect: { selection in
                if selection.title == "On" {
                    UserDefaultsManager.shared.setValue(withKey: .forceAppUpdate, value: true)
                } else {
                    UserDefaultsManager.shared.setValue(withKey: .forceAppUpdate, value: false)
                }
            })
            return appForceUpdateMenu
        }

        private static func killSwitchMenu() -> YoshiSingleSelectionMenu {
            let selection1 = YoshiSingleSelection(title: "On", subtitle: nil)
            let selection2 = YoshiSingleSelection(title: "Off", subtitle: nil)

            var selectedIndex = 1
            if let status = UserDefaultsManager.shared.getValue(byKey: .killSwitchStatus) as? Bool,
                status {
                selectedIndex = 0
            }

            let killSwitchMenu = YoshiSingleSelectionMenu(title: "Kill Switch ☠️",
                                                          options: [selection1, selection2],
                                                          selectedIndex: selectedIndex,
                                                          didSelect: { selection in
                if selection.title == "On" {
                    UserDefaultsManager.shared.setValue(withKey: .killSwitchStatus, value: true)
                } else {
                    UserDefaultsManager.shared.setValue(withKey: .killSwitchStatus, value: false)
                }
            })
            return killSwitchMenu
        }

        private static func createGeneralEnvironmentMenu(generalEnvironments: [HTTPEnvironment],
                                                         generalSelectedIndex: Int,
                                                         generalSingleSelectionItems: [YoshiSingleSelection]) -> YoshiSingleSelectionMenu {
            let generalEnvironmentMenu = YoshiSingleSelectionMenu(title: "General Environment 🛠",
                                                                  options: generalSingleSelectionItems,
                                                                  selectedIndex: generalSelectedIndex,
                                                                  didSelect: { selection in
                                                                    for environment in generalEnvironments
                                                                        where environment.environmentName.rawValue == selection.title {
                                                                            CFEnvironmentManager.shared.persistUserPreferredEnvironment(
                                                                                userDefaultsKey: .currentGeneralEnvironment,
                                                                                value: selection.title)
                                                                            break
                                                                    }
            })
            return generalEnvironmentMenu
        }

        private static func createHomeDebugItem() -> YoshiActionMenu {
            return YoshiActionMenu(title: "Show home screen 🏠", completion: {
                let rootController = MainNavigationBuilder().build()
                UIApplication.shared.keyWindow?.rootViewController?.present(rootController, animated: true, completion: nil)
            })
        }

    }

#endif
