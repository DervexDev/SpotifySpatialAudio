//
//  App.swift
//
//  Created by Dervex with <3 on 23/08/2023.
//

import SwiftUI

let core = Bundle.main.url(forResource: "ssa-core", withExtension: "")
var process = Process()

@main
struct SpotifySpatialAudio: App {
	@State var isRunning = true
	
    var body: some Scene {
		MenuBarExtra("Spotify Spatial Audio", systemImage: "waveform") {
			Text("Spotify Spatial Audio")
			
			Divider()
			
			Button(isRunning ? "Stop" : "Start") {
				isRunning = !isRunning
				startStop(run: isRunning)
			}.keyboardShortcut("s")
			
			Button("Quit") {
				startStop(run: false)
				NSApplication.shared.terminate(nil)
			}.keyboardShortcut("q")
		}
    }
	
	init() {
		if isRunning {
			startStop(run: true)
		}
	}
}

func startStop(run: Bool) {
	if run {
		if !process.isRunning {
			Task {
				process.executableURL = core
				try process.run()
			}
		}
	} else if process.isRunning {
		process.terminate()
		process = Process()
	}
}
