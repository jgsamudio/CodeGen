//
//  ApplicationBuilder.swift
//  TheWing
//
//  Created by Ruchi Jain on 3/5/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import Foundation
import Keys
import UIKit
import Yoshi
import Velar
import Fabric
import Crashlytics

#if !RELEASE
import Instabug
#endif

#if ALPHA || BETA
import HockeySDK
#endif

/// Main application builder.
final class ApplicationBuilder {
    
    // MARK: - Public Properties
    
    /// Branch provider.
    var branchProvider: BranchProvider?
    
    /// Push notifications provider.
    var pushProvider: PushNotificationsProvider?
    
    // MARK: - Private Properties
    
    private var rootViewController: RootViewController?
    
    private var killSwitchProvider: KillSwitchProvider?
    
    // MARK: - Initialization
    
    /// Main application setup.
    ///
    /// - Parameters:
    ///   - window: UIWindow.
    ///   - launchOptions: Launch options to use.
    ///   - analyticsProvider: Analytics provider.
    init(in window: UIWindow, launchOptions: [UIApplicationLaunchOptionsKey: Any]?) {
        // Set up Crashlytics.
        Fabric.with([Crashlytics.self])
        
        // Build dependencies.
        let environmentManager = buildEnvironmentManager()
        let theme = Theme(colorTheme: ColorTheme(), textStyleTheme: TextStyleTheme(), buttonStyleTheme: ButtonStyleTheme())
        killSwitchProvider = KillSwitchProvider(window: window, theme: theme)
        let analyticsProvider = SegmentAnalyticsProvider(launchOptions: launchOptions)
        pushProvider = analyticsProvider
        let dependencyProvider = ApplicationDependencyProvider(environmentManager: environmentManager,
                                                               analyticsProvider: analyticsProvider,
                                                               killSwitchProvider: killSwitchProvider)
        let builder = Builder(dependencyProvider: dependencyProvider, theme: theme)
        
        // Apply theme to global application appearance properties.
        ApplicationAppearance.setup(with: theme)
        
        // Build root view controller and set window.
        let viewController = builder.rootViewController(destination: .home)
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.setNavigationBarHidden(true, animated: false)
        self.rootViewController = viewController
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        // Set up deeplink handler.
        let deepLinkHandler = DeepLinkHandler(window: window, builder: builder)
        branchProvider = BranchProvider(launchOptions: launchOptions) { (deepLinkData, error) in
            deepLinkHandler.handle(deepLinkData: deepLinkData, error: error)
        }
        
        // Set up debug menu.
        #if !RELEASE
        setupYoshi(environmentManager: environmentManager)
        #endif
        
        // Set up hockey build.
        #if ALPHA || BETA
        setupHockey()
        #endif
    }
    
}

// MARK: - Private Functions
private extension ApplicationBuilder {
    
    func buildEnvironmentManager() -> YoshiEnvironmentManager<APIEnvironment> {
        let producationBaseURL = URL(string: "https://api.the-wing.com/api/v1")!
        var environmentOptions = [APIEnvironment(name: "Production", baseURL: producationBaseURL)]
        
        #if !RELEASE
        let stageBaseUrl = URL(string: "https://api-stage.dev.thewing.prolific.io/api")!
        environmentOptions.append(APIEnvironment(name: "Staging", baseURL: stageBaseUrl))
        
        let devBaseUrl = URL(string: "https://api-dev.dev.thewing.prolific.io/api")!
        environmentOptions.append(APIEnvironment(name: "Dev", baseURL: devBaseUrl))
        #endif
        
        return YoshiEnvironmentManager(environments: environmentOptions)
    }
    
    #if !RELEASE
    func setupYoshi(environmentManager: YoshiEnvironmentManager<APIEnvironment> ) {
        let environmentMenu = YoshiEnvironmentMenu(environmentManager: environmentManager)
        let instabugMenu = buildBugReporter()
        let onboarding = YoshiActionMenu(title: "Transition to onboarding") {
            self.rootViewController?.transitionToOnboarding()
        }
        let transitionToMainApp = YoshiActionMenu(title: "Transition to main app") {
            self.rootViewController?.transitionToMainApp()
        }
        let killSwitch = YoshiActionMenu(title: "Show KillSwitch Screen") {
            self.killSwitchProvider?.receivedError(APIError.backend(error:
                BackendError(code: BusinessConstants.killSwitchErrorCode, message: "")))
        }
        let forceUpdate = YoshiActionMenu(title: "Show Force Update Screen") {
            self.killSwitchProvider?.receivedError(APIError.backend(error:
                BackendError(code: BusinessConstants.forceUpgradeErrorCode, message: "")))
        }
        Yoshi.setupDebugMenu([environmentMenu,
                              instabugMenu,
                              onboarding,
                              transitionToMainApp,
                              killSwitch,
                              forceUpdate])
    }
    
    func buildBugReporter() -> YoshiActionMenu {
        Instabug.start(withToken: TheWingKeys().instabugToken, invocationEvent: .none)
        Instabug.setCrashReportingEnabled(false)
        Instabug.setPromptOptionsEnabledWithBug(true, feedback: false, chat: false)
        
        return YoshiActionMenu(title: "Instabug",
                               subtitle: "Log a bug",
                               completion: {
                                Instabug.invoke()
        })
    }
    #endif
    
    #if ALPHA || BETA
    func setupHockey() {
        let identifier = TheWingKeys().hockeyAppID
        BITHockeyManager.shared().configure(withIdentifier: identifier)
        BITHockeyManager.shared().start()
        BITHockeyManager.shared().authenticator.authenticateInstallation()
    }
    #endif
    
}
