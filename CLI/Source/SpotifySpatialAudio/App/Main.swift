//
//  Main.swift
//
//  Created by Dervex with <3 on 04/08/2023.
//

import Foundation
import Cocoa

@main
struct App {
	static func main() throws {
		var data: LocalData = LocalData(dictionary: [
			"accessToken": "",
			"refreshToken": "",
			"lifetime": 0,
			"lastUsed": Double(0)
		])
		
		Task {
			data = try await getData()
		}
		
		Events.listen() { () in
			Task {
				if data.accessToken == "" || data.refreshToken == "" || data.lifetime == 0 || data.lastUsed == 0 {
					print("ERROR: unauthorized!")
					return
				}
				
				let now = NSDate().timeIntervalSince1970.rounded()
				
				if now - data.lastUsed >= 3600 {
					data.accessToken = Requests.updateToken(refreshToken: data.refreshToken)
					data.lastUsed = now
					
					try FileSystem.saveJSON(json: data.dictionary)
				}
				
				var id = Requests.getSafariId(accessToken: data.accessToken)
				
				if id == "null" {
					AppleScript.clearSafari()
					AppleScript.initSafari()
				} else if id == "active" {
					return
				}
				
				id = Requests.getSafariId(accessToken: data.accessToken)
				
				Requests.changeOutput(accessToken: data.accessToken, id: id)
			}
		}
		
		RunLoop.main.run()
	}
	
	static func getData() async throws -> LocalData {
		var json: [String: Any]
		
		if let temp = try FileSystem.loadJSON() {
			json = temp as! [String : Any]
		} else {
			NSWorkspace.shared.open(URL(string: START_URL)!)
			json = try await AuthServer.start()
		}
		
		return LocalData(dictionary: json)
	}
}
