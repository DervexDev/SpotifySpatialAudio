//
//  Server.swift
//
//  Created by Dervex with <3 on 02/08/2023.
//

import Foundation
import Vapor

struct AuthServer {
	static var app = Application()
	
	static func start() async throws -> [String: Any] {
		let output = UnsafeMutablePointer<[String: Any]>.allocate(capacity: 1)
		var currentState = ""
		
		app.http.server.configuration.hostname = SERVER_HOST
		app.http.server.configuration.port = SERVER_PORT
		
		app.get("login") { req -> Response in
			currentState = Utils.generateRandomString(length: 16)
			
			var url = URLComponents(string: "https://accounts.spotify.com/authorize?")!
			url.queryItems = [
				URLQueryItem(name: "response_type", value: "code"),
				URLQueryItem(name: "client_id", value: CLIENT_ID),
				URLQueryItem(name: "redirect_uri", value: REDIRECT_URL),
				URLQueryItem(name: "scope", value: Utils.getScopes(scopes: SCOPES)),
				URLQueryItem(name: "state", value: currentState)
			]
			
			return req.redirect(to: url.url!.absoluteString)
		}
		
		app.get("callback") { req in
			let code = try req.query.decode(Code.self)
			let state = try req.query.decode(State.self)
			
			if state.state != currentState {
				return "Invalid state!"
			}
			
			let success = UnsafeMutablePointer<Bool>.allocate(capacity: 1)
			let headers = [
				"Authorization": "Basic " + (CLIENT_ID + ":" + CLIENT_SECRET).data(using: .utf8)!.base64EncodedString(),
				"Content-Type": "application/x-www-form-urlencoded"
			]
			
			var body = URLComponents()
			body.queryItems = [
				URLQueryItem(name: "grant_type", value: "authorization_code"),
				URLQueryItem(name: "redirect_uri", value: REDIRECT_URL),
				URLQueryItem(name: "code", value: code.code)
			]
			
			var request = URLRequest(url: URL(string: "https://accounts.spotify.com/api/token")!)
			request.httpMethod = "POST"
			request.allHTTPHeaderFields = headers
			request.httpBody = body.query?.data(using: .utf8)
			
			let group = DispatchGroup()
			group.enter()
			
			URLSession.shared.dataTask(with: request) { data, response, error in
				guard let data = data, error == nil else {
					group.leave()
					return
				}
				var saved = false
				
				do {
					let decoded = try JSONDecoder().decode(SpotifyData.self, from: data)
					let json = [
						"accessToken": decoded.access_token,
						"refreshToken": decoded.refresh_token,
						"lifetime": decoded.expires_in,
						"lastUsed": NSDate().timeIntervalSince1970.rounded()
					]
					
					output.pointee = json
					
					saved = try FileSystem.saveJSON(json: json)
				} catch {
					group.leave()
					return
				}
				
				success.pointee = saved
				group.leave()
			}.resume()
			
			group.wait()
			
			if success.pointee {
				Task {
					try await stop()
				}
				
				return "Authorization completed!"
			} else {
				return "Authorization failed!"
			}
		}
		
		try app.run()
		
		return output.pointee
	}
	
	static func stop() async throws {
		try await Task.sleep(nanoseconds: UInt64(Double(NSEC_PER_SEC)))
		app.shutdown()
	}
}
