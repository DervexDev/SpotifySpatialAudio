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
				var attempts = 0
				
				if id == "none" {
					AppleScript.openSafari()
				} else if id == "active" || id == "inactive" {
					return
				}
				
				while id == "none" && attempts < OPEN_SAFARI_MAX_ATTEMPTS {
					sleep(1)
					id = Requests.getSafariId(accessToken: data.accessToken)
					attempts += 1
				}
				
				if id == "none" {
					print("ERROR: Safari cannot be opened!")
					return
				}
				
				Requests.changeOutput(accessToken: data.accessToken, id: id)
				
				sleep(1)
				AppleScript.fakeSpace()
				//Requests.resumePlayback(accessToken: data.accessToken)
				sleep(1)
				AppleScript.hideSafari()
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
