//
//  AnalyticsKey.swift
//  CrossFit Games
//
//  Created by Daniel Vancura on 12/11/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

import UIKit

/// Struct which contains enums with information that could be logged for Analytics purposes.
struct AnalyticsKey {

    /// Events in the app. See "Event Name" in
    /// https://docs.google.com/spreadsheets/d/1YNMHivTpGmaxb6uHoi1bp8gu17CWeMsx2Gc9UZFt1rg/edit#gid=1442657975
    enum Event: String {
        case trackScreen = "track_screen"
        case yoshiTriggered = "yoshi_triggered"
        
        // MARK: - Dashboard Events
        case dashboardNavigation = "dashboard_navigation"
        case dashboardCardExpanded = "dashboard_card_expanded"
        case dashboardCardViewThisLeaderboard = "dashboard_card_view_this_leaderboard"
        case openRegistration = "open_registration"
        case appShare = "app_share"

        // MARK: - Landing Events
        case landingSignIn = "landing_sign_in"
        case landingCreateAccount = "landing_create_account"
        case landingSkip = "landing_skip"
        case signInSuccess = "sign_in_success"
        case signInExit = "sign_in_exit"
        case createAccountSuccess = "create_account_success"
        case createAccountExit = "create_account_exit"
        
        // MARK: - Leaderboard Events
        case leaderboardNavigation = "leaderboard_navigation"
        case leaderboardCompetitionFilter = "leaderboard_competition_filter"
        case leaderboardDivisionFilter = "leaderboard_division_filter"
        case leaderboardWorkoutTypeFilter = "leaderboard_workout_type_filter"
        case leaderboardFittestInFilter = "leaderboard_fittest_in_filter"
        case leaderboardOccupationFilter = "leaderboard_occupation_filter"
        case leaderboardSortFilter = "leaderboard_sort_filter"
        case leaderboardYearFilter = "leaderboard_year_filter"
        case leaderboardSearchStarted = "leaderboard_search_started"
        case leaderboardSearchCompleted = "leaderboard_search_completed"
        case leaderboardSearchCancelled = "leaderboard_search_cancelled"

        // MARK: - Push Opt In
        case pushOptInView = "push_opt_in_view"
        case pushOptInSuccess = "push_opt_in_success"
        case pushOptInExit = "push_opt_in_exit"

        // MARK: - Settings
        case settingsNavigation = "settings_navigation"
        case help
        case contactUs = "contact_us"
        case ruleBook = "rule_book"
        case drugPolicy = "drug_policy"
        case login
        case logout
        case forgotPassword = "forgot_password"

        // MARK: - Workout Pages
        case workoutNavigation = "workout_navigation"
        case workoutDetails = "workout_details"
        case workoutsFilter = "workouts_filter"

        // MARK: - Workout Details
        case workoutDetailsFilter = "workout_details_filter"
        case workoutMovementStandards = "workout_movement_standards"
        case workoutDescription = "workout_description"
        case workoutEquipment = "workout_equipment"
        case workoutVideoSubmission = "workout_video_submission"
        case workoutVideoExpanded = "workout_video_expanded"
        case openScoreSubmission = "open_score_submission"

        // MARK: - Follow an Athlete
        case followAthleteAdd = "follow_athlete_add"
        case followAthleteRemove = "follow_athlete_remove"
        case followAthleteViewStats = "follow_athlete_view_stats"

        // MARK: - Promo items
        case promoLink1 = "promo_link_1"
        case promoLink2 = "promo_link_2"
    }

    /// Properties in the app. See the keys of "Property objects" in
    /// https://docs.google.com/spreadsheets/d/1YNMHivTpGmaxb6uHoi1bp8gu17CWeMsx2Gc9UZFt1rg/edit#gid=1442657975
    enum Property: String {
        case screen = "screen"
        case className = "class_name"
        case yoshiUser = "testing_user"
        case yoshiSuccess = "success"
        case dashboardCard = "dashboard_card"
        case competition
        case division
        case workoutType = "workout_type"
        case fittestIn = "fittest_in"
        case occupation
        case sort
        case year
        case athleteName = "athlete_name"
        case athleteId = "athlete_id"
        case id
        case workout
        case firstName = "first_name"
        case country
        case language
        case pushEnabled = "push_enabled"
        case openRegistered = "open_registered"
        case userId
        case promoLink1 = "promo_link_1"
        case promoLink2 = "promo_link_2"
    }

    /// Properties in the app. See the values of recurring screens on "Property objects" in
    /// https://docs.google.com/spreadsheets/d/1YNMHivTpGmaxb6uHoi1bp8gu17CWeMsx2Gc9UZFt1rg/edit#gid=1442657975
    enum Screen: String {
        case yoshi = "Yoshi"
        case dashboard = "Dashboard"
        case dashoardCardDetails = "Dashboard Card"
        case landing = "Landing"
        case signIn = "Sign In"
        case createAccount = "Create Account"
        case createAccountStep1 = "Create Account Step 1"
        case createAccountStep2 = "Create Account Step 2"
        case leaderboardFilters = "Leaderboad Filters"
        case leaderboard = "Leaderboard"
        case search = "Search"
        case pushOptIn = "Push Opt-In"
        case settings = "Settings"
        case workoutPages = "Workout Pages"
        case workoutDetails = "Workout Details"
        case workoutAdditionalInformation = "Workout Additional Information"
        case followAthlete = "Follow Athlete"
        case followAthleteStatsView = "Follow Athlete Stats View"
    }

    // MARK: - Public Functions
    
    /// Returns the screen name for a given viewcontroller
    ///
    /// - Parameter viewController: viewcontroller which is to be translated to the screen name
    /// - Returns: screen name
    static func getScreen(for viewController: UIViewController) -> AnalyticsKey.Screen? {
        if viewController.isKind(of: DashboardViewController.self) {
            return .dashboard
        } else if viewController.isKind(of: LandingViewController.self) {
            return .landing
        } else if viewController.isKind(of: LoginViewController.self) {
            return .signIn
        } else if viewController.isKind(of: CreateAccountNameEntryViewController.self) {
            return .createAccountStep1
        } else if viewController.isKind(of: CreateAccountCredentialsEntryViewController.self) {
            return .createAccountStep2
        } else if viewController.isKind(of: LeaderboardResultViewController.self) {
            return .leaderboard
        } else if viewController.isKind(of: SearchViewController.self) {
            return .search
        } else if viewController.isKind(of: AccountViewController.self) {
            return .settings
        } else if viewController.isKind(of: WorkoutDetailsViewController.self) {
            return .workoutDetails
        } else if viewController.isKind(of: WorkoutAdditionalInfoViewController.self) {
            return .workoutAdditionalInformation
        } else if viewController.isKind(of: FilterViewController.self) {
            return .leaderboardFilters
        } else if viewController.isKind(of: CardDetailContainerViewController.self) {
            return .dashoardCardDetails
        } else if viewController.isKind(of: DashboardFAAModalViewController.self) {
            return .followAthleteStatsView
        } else if viewController.isKind(of: FollowAnAthleteModalViewController.self) {
            return .followAthlete
        }
        return nil
    }

}
