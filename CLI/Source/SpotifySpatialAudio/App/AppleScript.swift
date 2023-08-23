//
//  AppleScript.swift
//
//  Created by Dervex with <3 on 04/08/2023.
//

import Foundation

struct AppleScript {
	static func initSafari() {
		let script = """
		tell application "Safari"
			make new document with properties {URL:"https://open.spotify.com/"}
			delay \(SAFARI_HIDE_DELAY)
			set miniaturized of window 1 to true
		end tell
		"""
		
		var error: NSDictionary?
		if let scriptObject = NSAppleScript(source: script) {
			scriptObject.executeAndReturnError(&error)
		}
	}
	
	static func clearSafari() {
		let script = """
		tell application "Safari"
			close (every window whose name contains "Spotify")
		end tell
		"""
		
		var error: NSDictionary?
		if let scriptObject = NSAppleScript(source: script) {
			scriptObject.executeAndReturnError(&error)
		}
	}
}
