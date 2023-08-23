//
//  Structures.swift
//
//  Created by Dervex with <3 on 04/08/2023.
//

import Vapor

struct Code: Content {
	let code: String
}

struct State: Content {
	let state: String
}

struct SpotifyData: Decodable {
	let access_token: String
	let token_type: String
	let expires_in: Int
	let refresh_token: String
	let scope: String
}

struct LocalData: Decodable {
	var accessToken: String
	var refreshToken: String
	var lastUsed: Double
	var lifetime: Int
	
	var dictionary: [String: Any] {
		return [
			"accessToken": accessToken,
			"refreshToken": refreshToken,
			"lastUsed": lastUsed,
			"lifetime": lifetime
		]
	}
	
	init (dictionary: [String: Any]) {
		self.accessToken = dictionary["accessToken"] as! String
		self.refreshToken = dictionary["refreshToken"] as! String
		self.lastUsed = dictionary["lastUsed"] as! Double
		self.lifetime = dictionary["lifetime"] as! Int
	}
}
