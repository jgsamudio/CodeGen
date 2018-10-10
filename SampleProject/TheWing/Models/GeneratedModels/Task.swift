//
//  Task.swift
//  TheWing
//
//  Created by The Wing Developers on 08/10/18.
//  Copyright © 2018 Prolific Interactive. All rights reserved.
//

/*
    Auto-Generated using ModelSynchro
*/

struct Task: Codable {
    
    // MARK: - Public Properties
    
	let buttonAction: String
	let buttonActionType: String
	let buttonLabel: String
	let createdAt: String?
	let description: String
	let imageUrl: String
	let taskId: String // let _id: String
	let title: String
	let type: String

	enum CodingKeys: String, CodingKey {
		case buttonAction = "buttonAction"
		case buttonActionType = "buttonActionType"
		case buttonLabel = "buttonLabel"
		case createdAt = "createdAt"
		case description = "description"
		case imageUrl = "imageUrl"
		case taskId = "_id"
		case title = "title"
		case type = "type"
	}
}
