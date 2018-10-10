//
//  Announcement.swift
//  TheWing
//
//  Created by The Wing Developers on 07/20/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

/*
    Auto-Generated using ModelSynchro
*/

struct Announcement: Codable {
    
    // MARK: - Public Properties
    
	let createdAt: String
	let description: String
	let imageUrl: String? // let imageUrl: String
	let postId: String
	let posterIcon: String?
	let title: String? // let title: String

	enum CodingKeys: String, CodingKey {
		case createdAt = "createdAt"
		case description = "description"
		case imageUrl = "imageUrl"
		case postId = "postId"
		case posterIcon = "posterIcon"
		case title = "title"
	}
}
