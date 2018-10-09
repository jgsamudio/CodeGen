//
//  WorkoutListTest.swift
//  CrossFit GamesTests
//
//  Created by Malinka S on 10/26/17.
//  Copyright © 2017 Prolific Interactive. All rights reserved.
//

@testable import CrossFit_Games
import XCTest

class WorkoutListTest: XCTestCase {

    var workoutList: [Workout]!

    override func setUp() {
        super.setUp()
        initalize()
    }

    override func tearDown() {
        super.tearDown()
        workoutList = nil
    }

    func initalize() {
        guard let filePath = Bundle(for: WorkoutListTest.self).url(forResource: "workouts", withExtension: "json"),
            let json = try? Data(contentsOf: filePath) else {
                XCTFail("Failed due to being unable to parse file from disk.")
                return
        }

        let stringValue = String(data: json, encoding: .ascii)
        guard let data = stringValue?.data(using: .utf8) else {
            XCTFail("Whoops")
            return
        }

        let decoder = JSONDecoder()
        XCTAssertNoThrow(try decoder.decode([Workout].self, from: data))

        do {
            let workoutsPage = try decoder.decode([Workout].self, from: data)
            workoutList = workoutsPage
        } catch {
            XCTFail("Failed with error: \(error)")
        }
    }

    func testParsingWorkouts() {
        workoutList.forEach({ (workout) in
            XCTAssertTrue(workout.id.count > 0)
            XCTAssertTrue(!workout.label.isEmpty)
            XCTAssertTrue(!workout.created.isEmpty)
            XCTAssertTrue(!workout.changed.isEmpty)
            XCTAssertTrue((workout.workoutDeadline ?? -1) >= 0)
            XCTAssertTrue(!(workout.youtubeVideoId?.isEmpty ?? true))
            XCTAssertTrue(!workout.sponsorImages.isEmpty)
            XCTAssertTrue(!(workout.workoutImageURL?.isEmpty == true))
            XCTAssertTrue(!workout.workoutDescription.isEmpty)
            XCTAssertTrue(!workout.workoutSummary.isEmpty)
            XCTAssertTrue(!(workout.workoutImageURL?.isEmpty ?? true))
        })

        XCTAssertEqual(workoutList.count, 10)
    }

    /*
     Workout Periods listed from JSON for convenience

         17.5
         start: 1490313600
         end: 1501545600

         17.4:
         start: 1489708800
         end: 1490054400

         17.3:
         start: 1489107600
         end: 1489449600

         17.2:
         start: 1488502800
         end: 1488848400

         17.1:
         start: 1487786400
         end: 1488416400

         DatePicker.shared.date: 1490034100
     */

    func testLiveWorkout() {
        DatePicker.shared.date = Date(crossFitStandardTime: 1490034100)!
        let expectedAnswerList = [false, true, false, false, false]
        XCTAssertEqual(workoutList.count, 10)
        let workoutViewModelList = workoutList.flatMap { WorkoutViewModel(workout: $0, collapsed: false ) }
        for (workoutViewModel, answer) in zip(workoutViewModelList, expectedAnswerList) {
            XCTAssertEqual(workoutViewModel.isLiveWorkout, answer)
        }
    }

    func testCompletedWorkout() {
        DatePicker.shared.date = Date(crossFitStandardTime: 1490034100)!
        let expectedAnswerList = [false, false, true, true, true]
        XCTAssertEqual(workoutList.count, 10)
        let workoutViewModelList = workoutList.flatMap { WorkoutViewModel(workout: $0, collapsed: false ) }
        for (workoutViewModel, answer) in zip(workoutViewModelList, expectedAnswerList) {
            XCTAssertEqual(workoutViewModel.isCompleted, answer)
        }
    }

}
