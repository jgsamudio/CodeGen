//
//  IndustryExtension.swift
//  TheWing
//
//  Created by Ruchi Jain on 10/1/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

extension Industry {
    
    // MARK: - Public Properties
    
    /// Parameters
    var parameters: [String: Any] {
        var params = [String: Any]()
        params.insert(key: CodingKeys.industryId.rawValue, object: industryId)
        params.insert(key: CodingKeys.name.rawValue, object: name)
        return params
    }
    
    /// Default industry options list.
    static var defaults: [Industry] {
        return [Industry(industryId: "zx6Kg4QMC3qEcsAYA", name: "Advertising"),
        Industry(industryId: "zx6Kg4QMC3qEcsAYY", name: "Art"),
        Industry(industryId: "zx6Kg4QMC3qEcsAYB", name: "Consulting"),
        Industry(industryId: "zx6Kg4QMC3qEcsAPP", name: "Design"),
        Industry(industryId: "zx6Kg4QMC3qEcsAEE", name: "Education/Academia"),
        Industry(industryId: "zx6Kg4QMC3qEcsACC", name: "Fashion/Beauty"),
        Industry(industryId: "zx6Kg4QMC3qEcsAUU", name: "Film/TV/Radio/Music"),
        Industry(industryId: "zx6Kg4QMC3qEcsAQQ", name: "Finance"),
        Industry(industryId: "zx6Kg4QMC3qEcsARR", name: "Food/Beverage"),
        Industry(industryId: "zx6Kg4QMC3qEcsAOO", name: "Healthcare/Medicine"),
        Industry(industryId: "zx6Kg4QMC3qEcsAOA", name: "Hospitality"),
        Industry(industryId: "zx6Kg4QMC3qEcsAII", name: "Law/Government"),
        Industry(industryId: "zx6Kg4QMC3qEcsABBC", name: "Lifestyle/Wellness"),
        Industry(industryId: "zx6Kg4QMC3qEcsABB", name: "Marketing/Communications"),
        Industry(industryId: "zx6Kg4QMC3qEcsABA", name: "Media"),
        Industry(industryId: "zx6Kg4QMC3qEcsAYz", name: "Military"),
        Industry(industryId: "zx6Kg4QMC3qEcsATT", name: "Nonprofit/NGO"),
        Industry(industryId: "zx6Kg4QMC3qEcsASS", name: "Real Estate"),
        Industry(industryId: "zx6Kg4QMC3qEcsAAB", name: "Tech"),
        Industry(industryId: "zx6Kg4QMC3qEcsAFF", name: "Writing/Editing/Publishing"),
        Industry(industryId: "zx6Kg4QMC3qEcsAHH", name: "Other")]
    }
    
}

// MARK: - Equatable
extension Industry: Equatable {
    
    // MARK: - Public Functions
    
    static func == (lhs: Industry, rhs: Industry) -> Bool {
        return lhs.name == rhs.name
    }
    
}
