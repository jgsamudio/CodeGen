//
//  ShimmerSection.swift
//  TheWing
//
//  Created by Jonathan Samudio on 8/3/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

import UIKit

private typealias Range = (lowerBounds: Int, upperBounds: Int)

struct ShimmerSection {

    // MARK: - Public Properties

    /// Width of the shimmer section.
    let width: CGFloat

    /// Height of the shimmer section.
    let height: CGFloat

    // MARK: - Public Functions

    /// Generates an array of shimmer sections with random sizes.
    ///
    /// - Parameters:
    ///   - minWidth: Minimum width that a section should be.
    ///   - height: Default height of the shimmer section.
    ///   - totalWidth: The total width of the combined sections.
    ///   - maxNumberOfSections: The maximum number of sections to render, used by the random generator.
    /// - Returns: Array of sections to display.
    static func generate(minWidth: CGFloat,
                         height: CGFloat,
                         totalWidth: CGFloat,
                         maxNumberOfSections: Int) -> [ShimmerSection] {
        let numberOfSections = Int(arc4random_uniform(UInt32(maxNumberOfSections))) + 1
        return generateSections(minWidth: minWidth,
                                height: height,
                                totalWidth: totalWidth,
                                numberOfSections: numberOfSections)
    }

}

// MARK: - Private Functions
private extension ShimmerSection {

    static func generateSections(minWidth: CGFloat,
                                 height: CGFloat,
                                 totalWidth: CGFloat,
                                 numberOfSections: Int) -> [ShimmerSection] {
        guard numberOfSections != 1 else {
            return [ShimmerSection(width: totalWidth, height: height)]
        }
        
        var sectionsCount = 0
        var runningWidth = totalWidth
        var generatedSections = [ShimmerSection]()
        while sectionsCount < numberOfSections && runningWidth > 0 {
            var randomWidth = runningWidth
            if runningWidth > minWidth {
                randomWidth = CGFloat(random(range: (Int(minWidth), Int(runningWidth - minWidth))))
            }
            generatedSections.append(ShimmerSection(width: randomWidth, height: height))
            runningWidth -= randomWidth
            sectionsCount += 1
        }
        
        return generatedSections
    }

    static func random(range: Range) -> Int {
        guard range.lowerBounds <= range.upperBounds else {
            return range.lowerBounds
        }
        let endRange = range.upperBounds - range.lowerBounds
        return Int(arc4random_uniform(UInt32(endRange))) + range.lowerBounds
    }

}
