//
//  TopicImage.swift
//  TheWing
//
//  Created by The Wing Developers on 08/14/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

/*
    Auto-Generated using ModelSynchro
*/

struct TopicImage: Codable {
    
    // MARK: - Public Properties
    
	let png2x: String
	let png3x: String

	enum CodingKeys: String, CodingKey {
		case png2x = "png2x"
		case png3x = "png3x"
	}
}
