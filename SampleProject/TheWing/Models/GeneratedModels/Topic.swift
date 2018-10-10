//
//  Topic.swift
//  TheWing
//
//  Created by The Wing Developers on 08/14/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

/*
    Auto-Generated using ModelSynchro
*/

struct Topic: Codable {
    
    // MARK: - Public Properties
    
	let name: String
	let topicId: String // let _id: String
	let topicImage: TopicImage // let url: TopicImage

	enum CodingKeys: String, CodingKey {
		case name = "name"
		case topicId = "_id"
		case topicImage = "url"
	}
}
