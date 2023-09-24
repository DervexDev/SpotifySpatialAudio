//
//  AppleScript.swift
//
//  Created by Dervex with <3 on 04/08/2023.
//

import Foundation

struct AppleScript {
	static func openSafari() {
		let script = """
		tell application "Safari"
			open location "https://open.spotify.com/"
			activate
		end tell
		"""
		
		var error: NSDictionary?
		if let scriptObject = NSAppleScript(source: script) {
			scriptObject.executeAndReturnError(&error)
		}
	}
	
	static func hideSafari() {
		let script = """
		tell application "Safari"
			set miniaturized of window 1 to true
		end tell
		"""
		
		var error: NSDictionary?
		if let scriptObject = NSAppleScript(source: script) {
			scriptObject.executeAndReturnError(&error)
		}
	}
	
	static func fakeSpace() {
		let script = """
		tell application "System Events"
			key code 49
		end tell
		"""
		
		var error: NSDictionary?
		if let scriptObject = NSAppleScript(source: script) {
			scriptObject.executeAndReturnError(&error)
		}
		
		if error != nil {
			print("ERROR: missing privileges!")
		}
	}
}
