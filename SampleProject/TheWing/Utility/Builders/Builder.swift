//
//  Builder.swift
//  TheWing
//
//  Created by Ruchi Jain on 3/5/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

/// Main builder class.
final class Builder {
    
    // MARK: - Public Properties

    /// Theme of the application.
    let theme: Theme
    
    /// Dependency provider.
    let dependencyProvider: DependencyProvider
    
    // MARK: - Private Properties
    
    // MARK: - Initialization
    
    init(dependencyProvider: DependencyProvider, theme: Theme) {
        self.dependencyProvider = dependencyProvider
        self.theme = theme
    }
    
    // MARK: - Public Functions
    
    /// Builds root view controller of the application.
    ///
    /// - Parameter destination: Tab destination.
    /// - Returns: UIViewController.
    func rootViewController(destination: TabDestination) -> RootViewController {
        let viewController = RootViewController(builder: self, theme: theme)
        viewController.destination = destination
        viewController.viewModel = RootViewModel(dependencyProvider: dependencyProvider)
        return viewController
    }
    
    /// Builds a navigation controller with a view controller.
    ///
    /// - Parameter viewController: UIViewController.
    /// - Returns: UINavigationController
    func navigationController(with viewController: UIViewController) -> UINavigationController {
        return UINavigationController(rootViewController: viewController)
    }
    
    /// Builds login view controller.
    ///
    /// - Returns: UIViewController
    func loginViewController(delegate: LoginDelegate) -> UIViewController {
        let viewController = LoginViewController(builder: self, theme: theme)
        viewController.delegate = delegate
        viewController.viewModel = LoginViewModel(dependencyProvider: dependencyProvider)
        return viewController
    }
    
    /// Builds settings view controller.
    ///
    /// - Returns: UIViewController
    func settingsViewController(delegate: UserAccountDelegate? = nil) -> UIViewController {
        let viewController = SettingsViewController(builder: self, theme: theme)
        viewController.viewModel = SettingsViewModel(dependencyProvider: dependencyProvider)
        viewController.accountDelegate = delegate
        return viewController
    }

    /// Builds the main tab bar view controller.
    ///
    /// - Returns: UIViewController.
    func mainViewController(delegate: UserAccountDelegate? = nil,
                            destination: TabDestination = .home) -> UIViewController {
        let viewController = MainTabBarController(builder: self, theme: theme)
        viewController.selectedIndex = destination.rawValue
        viewController.viewModel = MainTabBarViewModel(dependencyProvider: dependencyProvider)
        viewController.accountDelegate = delegate
        return viewController
    }
    
    /// Builds events view controller.
    ///
    /// - Parameter tabBarDelegate: Main tab bar delegate.
    /// - Returns: Tab bar item view controller.
    func eventsViewController(tabBarDelegate: MainTabBarDelegate?) -> TabBarItemViewController {
        let viewController = EventsViewController(builder: self, theme: theme)
        viewController.viewModel = EventsViewModel(dependencyProvider: dependencyProvider)
        viewController.tabBarDelegate = tabBarDelegate
        
        let headerView = FilterSearchTabHeaderView(theme: theme, headerTitle: viewController.tabBarItemTitle())
        headerView.delegate = viewController
        viewController.headerView = headerView
        
        return viewController
    }
    
    /// Builds community view controller.
    ///
    /// - Parameter tabBarDelegate: Main tab bar delegate.
    /// - Returns: Tab bar item view controller.
    func communityViewController(tabBarDelegate: MainTabBarDelegate?) -> TabBarItemViewController {
        let viewController = CommunityViewController(builder: self, theme: theme)
        viewController.viewModel = CommunityViewModel(dependencyProvider: dependencyProvider)
        viewController.tabBarDelegate = tabBarDelegate
        
        let headerView = FilterSearchTabHeaderView(theme: theme, headerTitle: viewController.tabBarItemTitle())
        headerView.delegate = viewController
        viewController.headerView = headerView
        
        return viewController
    }
    
    /// Builds home view controller.
    ///
    /// - Parameter tabBarDelegate: Main tab bar delegate.
    /// - Returns: Tab bar item view controller.
    func homeViewController(tabBarDelegate: MainTabBarDelegate?) -> TabBarItemViewController {
        let viewController = HomeViewController(builder: self, theme: theme)
        viewController.viewModel = HomeViewModel(dependencyProvider: dependencyProvider)
        viewController.tabBarDelegate = tabBarDelegate
        return viewController
    }
    
    /// Builds profile view controller.
    ///
    /// - Parameters:
    ///   - userId: User id associated with profile.
    ///   - partialMemberInfo: Partial member info from the list item.
    /// - Returns: UIViewController.
    func profileViewController(userId: String, partialMemberInfo: MemberInfo? = nil) -> UIViewController {
        let viewController = ProfileViewController(builder: self, theme: theme)
        viewController.hidesBottomBarWhenPushed = true
        viewController.viewModel = ProfileViewModel(userId: userId,
                                                    dependencyProvider: dependencyProvider,
                                                    partialMemberInfo: partialMemberInfo)
        return viewController
    }
    
    /// Builds the edit state for profile view controller.
    ///
    /// - Parameter user: User object to load.
    /// - Returns: UIViewController.
    func editProfileViewController(user: User,
                                   delegate: EditProfileDelegate? = nil,
                                   entrySelection: EmptyStateViewType? = nil) -> UIViewController {
        let editController = EditProfileViewController(builder: self, theme: theme)
        editController.viewModel = EditProfileViewModel(dependencyProvider: dependencyProvider,
                                                        user: user,
                                                        entrySelection: entrySelection)
        editController.delegate = delegate
        let navigationController = UINavigationController(rootViewController: editController)
        return navigationController
    }
    
    /// Builds the edit occupation view controller.
    ///
    /// - Parameters:
    ///   - delegate: Edit occupation base delegate.
    ///   - occupation: User occupation if available.
    /// - Returns: UIViewController.
    func editOccupationViewController(delegate: EditOccupationBaseDelegate?, occupation: Occupation?) -> UIViewController {
        let viewController = EditOccupationViewController(builder: self, theme: theme)
        viewController.viewModel = EditOccupationViewModel(occupation: occupation,
                                                           type: .editOccupation,
                                                           dependencyProvider: dependencyProvider)
        viewController.delegate = delegate
        return viewController
    }
    
    /// Builds the add occupation view controller.
    ///
    /// - Parameter delegate: Edit occupation base delegate.
    /// - Returns: UIViewController.
    func addOccupationViewController(delegate: EditOccupationBaseDelegate?) -> UIViewController {
        let viewController = EditOccupationViewController(builder: self, theme: theme)
        viewController.viewModel = EditOccupationViewModel(occupation: nil,
                                                           type: .addOccupation,
                                                           dependencyProvider: dependencyProvider)
        viewController.delegate = delegate
        return viewController
    }
    
    /// Builds the search position view controller.
    ///
    /// - Returns: UIViewController.
    func searchPositionViewController(delegate: EditOccupationViewController? = nil) -> UIViewController {
        let viewController = SearchOccupationViewController(builder: self, theme: theme)
        viewController.delegate = delegate
        viewController.viewModel = SearchOccupationViewModel(dependencyProvider: dependencyProvider,
                                                             type: .positions)
        return viewController
    }
    
    /// Builds the search neighborhood view controller.
    ///
    /// - Parameter delegate: the delegate for the view controller, tells you when it's done.
    /// - Returns: UIViewController.
    func neighborhoodSearchViewController(delegate: NeighborhoodSearchViewControllerDelegate) -> UIViewController {
        let viewController = NeighborhoodSearchViewController(builder: self, theme: theme)
        viewController.viewModel = NeighborhoodSearchViewModel(dependencyProvider: dependencyProvider)
        viewController.delegate = delegate
        return viewController
    }
    
    /// Builds the search company view controller.
    ///
    /// - Returns: UIViewController.
    func searchCompanyViewController(delegate: EditOccupationViewController? = nil) -> UIViewController {
        let viewController = SearchOccupationViewController(builder: self, theme: theme)
        viewController.delegate = delegate
        viewController.viewModel = SearchOccupationViewModel(dependencyProvider: dependencyProvider,
                                                             type: .companies)
        return viewController
    }
    
    /// Builds a view controller to search through tags given a data source.
    ///
    /// - Parameters:
    ///   - type: Profile tag type.
    ///   - searchDelegate: Search tags delegate.
    /// - Returns: UIViewController
    func searchTagsViewController(type: ProfileTagType, searchDelegate: SearchTagsDelegate?) -> UIViewController {
        let viewController = SearchTagsViewController(builder: self, theme: theme)
        let viewModel = SearchTagsViewModel(type: type, dependencyProvider: dependencyProvider)
        viewModel.searchDelegate = searchDelegate
        viewController.viewModel = viewModel
        return viewController
    }
    
    /// Builds a view controller to edit filters.
    ///
    /// - Parameters:
    ///   - filtersDelegate: Filters delegate.
    /// - Returns: UIViewController
    func filtersViewController(filtersDelegate: FiltersDelegate) -> UIViewController {
        let viewController = FiltersViewController(builder: self, theme: theme)
        let viewModel = FiltersViewModel(dependencyProvider: dependencyProvider, type: filtersDelegate.filterType)
        viewModel.filtersDelegate = filtersDelegate
        viewController.viewModel = viewModel
        filtersDelegate.filterItemsDelegate = viewModel
        let navigationController = UINavigationController(rootViewController: viewController)
        return navigationController
    }
    
    /// Builds a view controller to display the event detail page.
    ///
    /// - Parameters:
    ///   - eventId: Event Id.
    ///   - eventData: Prefectched event data.
    ///   - eventStatusDelegate: Events status delegate.
    ///   - location: Location is who is sending the application to the EDP, like Home or MyHappenings.
    /// - Returns: UIViewController.
    func eventDetailViewController(eventId: String,
                                   eventData: EventData? = nil,
                                   eventStatusDelegate: EventStatusDelegate? = nil) -> UIViewController {
        let viewController = EventDetailViewController(builder: self, theme: theme)
        viewController.hidesBottomBarWhenPushed = true
        let viewModel = EventDetailViewModel(eventId: eventId,
                                             prefetchedData: eventData,
                                             dependencyProvider: dependencyProvider)
        viewModel.eventStatusDelegate = eventStatusDelegate
        viewController.viewModel = viewModel
        return viewController
    }
    
    /// Builds a view controller to edit event guests info.
    ///
    /// - Parameters:
    ///   - eventId: Event identifier.
    ///   - guestPerMember: Count of guests allowed per member.
    ///   - guestData: Event guests registration data.
    ///   - guestsDelegate: Guests delegate.
    /// - Returns: UIViewController.
    func editGuestsViewController(event: EventData,
                                  guestsDelegate: GuestsDelegate?) -> UIViewController {
        let viewController = EditGuestsViewController(builder: self, theme: theme)
        viewController.viewModel = EditGuestsViewModel(event: event,
                                                       guestsDelegate: guestsDelegate,
                                                       dependencyProvider: dependencyProvider)
        let navigationController = UINavigationController(rootViewController: viewController)
        return navigationController
    }
    
    /// Builds a view controller to display all attendees of an event.
    ///
    /// - Parameters:
    ///   - eventId: Event identifier.
    ///   - title: Title of view controller.
    /// - Returns: UIViewController.
    func attendeesViewController(eventId: String, title: String) -> UIViewController {
        let viewController = MembersViewController(builder: self, theme: theme)
        let membersProvider = AttendeesViewModel(eventId: eventId, title: title, dependencyProvider: dependencyProvider)
        viewController.membersProvider = membersProvider
        return viewController
    }
    
    /// Builds a view controller to display all of the user's events.
    ///
    /// - Parameters:
    ///   - type: Type of the my happenings view.
    /// - Returns: UIViewController.
    func myHappeningsViewController(type: MyHappeningsType) -> UIViewController {
        let viewController = MyHappeningsViewController(builder: self, theme: theme)
        viewController.hidesBottomBarWhenPushed = true
        let viewModel = MyHappeningsViewModel(dependencyProvider: dependencyProvider, type: type)
        viewController.viewModel = viewModel
        return viewController
    }
    
    /// Builds an announcement view controller to display announcement information.
    ///
    /// - Parameter announcement: Announcement raw data.
    /// - Returns: UIViewController.
    func announcementViewController(announcement: AnnouncementData) -> UIViewController {
        let viewController = AnnouncementViewController(builder: self, theme: theme)
        viewController.viewModel = AnnouncementViewModel(announcement: announcement, dependencyProvider: dependencyProvider)
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.setNavigationBarHidden(true, animated: false)
        return navigationController
    }
    
    /// Builds a view controller to display top matched users from community.
    ///
    /// - Returns: UIViewController.
    func topMatchesViewController() -> UIViewController {
        let viewController = TopMatchesViewController(builder: self, theme: theme)
        viewController.hidesBottomBarWhenPushed = true
        let viewModel = TopMatchesViewModel(dependencyProvider: dependencyProvider)
        viewController.viewModel = viewModel
        return viewController
    }
    
    /// The house rules view controller
    ///
    /// - Returns: The house rules view controller
    func houseRulesViewController() -> UIViewController {
        let viewController = HouseRulesViewController(builder: self, theme: theme)
        viewController.hidesBottomBarWhenPushed = true
        return viewController
    }

}
