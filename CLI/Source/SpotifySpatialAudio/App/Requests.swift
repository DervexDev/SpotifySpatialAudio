//
//  Requests.swift
//
//  Created by Dervex with <3 on 04/08/2023.
//

import Foundation

struct Requests {
	static func getSafariId(accessToken: String) -> String {
		var request = URLRequest(url: URL(string: "https://api.spotify.com/v1/me/player/devices")!)
		request.httpMethod = "GET"
		request.allHTTPHeaderFields = [
			"Authorization": "Bearer " + accessToken
		]
		
		let id = UnsafeMutablePointer<String>.allocate(capacity: 1)
		id.pointee = "null"
		
		let group = DispatchGroup()
		group.enter()
		
		URLSession.shared.dataTask(with: request) { data, response, error in
			guard let data = data, error == nil else {
				group.leave()
				return
			}
			
			do {
				let decoded = try JSONSerialization.jsonObject(with: data) as! [String: Array<[String: Any]>]
				
				for device in decoded["devices"]! {
					if device["name"] as! String == "Web Player (Safari)" {
						if device["is_active"] as! Bool {
							id.pointee = "active"
						} else {
							id.pointee = device["id"] as! String
						}
					}
				}
				
			} catch {
				group.leave()
				return
			}
			
			group.leave()
		}.resume()
		
		group.wait()
		
		return id.pointee
	}
	
	static func updateToken(refreshToken: String) -> String {
		var body = URLComponents()
		body.queryItems = [
			URLQueryItem(name: "grant_type", value: "refresh_token"),
			URLQueryItem(name: "refresh_token", value: refreshToken)
		]
		
		var request = URLRequest(url: URL(string: "https://accounts.spotify.com/api/token")!)
		request.httpMethod = "POST"
		request.allHTTPHeaderFields = [
			"Authorization": "Basic " + (CLIENT_ID + ":" + CLIENT_SECRET).data(using: .utf8)!.base64EncodedString(),
			"Content-Type": "application/x-www-form-urlencoded"
		]
		request.httpBody = body.query?.data(using: .utf8)
				
		let newToken = UnsafeMutablePointer<String>.allocate(capacity: 1)
		
		let group = DispatchGroup()
		group.enter()
		
		URLSession.shared.dataTask(with: request) { data, response, error in
			guard let data = data, error == nil else {
				group.leave()
				return
			}
			
			do {
				let decoded = try JSONSerialization.jsonObject(with: data) as! [String: Any]
				
				newToken.pointee = decoded["access_token"] as! String
			} catch {
				group.leave()
				return
			}
			
			group.leave()
		}.resume()
		
		group.wait()
		
		return newToken.pointee
	}
	
	static func changeOutput(accessToken: String, id: String) {
		let body = try! JSONSerialization.data(withJSONObject: [
			"device_ids": [id],
			"play": true
		])
		
		var request = URLRequest(url: URL(string: "https://api.spotify.com/v1/me/player")!)
		request.httpMethod = "PUT"
		request.allHTTPHeaderFields = [
			"Authorization": "Bearer " + accessToken,
			"Content-Type": "application/json"
		]
		request.httpBody = body as Data
		
		URLSession.shared.dataTask(with: request).resume()
	}
}
