//
//  MediaPlayer.swift
//
//  Created by Dervex with <3 on 04/08/2023.
//

import Foundation
import MediaPlayer
import Cocoa

struct Events {
	static func listen(callback:@escaping () -> ()) {
		let bundle = CFBundleCreate(kCFAllocatorDefault, NSURL(fileURLWithPath: "/System/Library/PrivateFrameworks/MediaRemote.framework"))
		
		let nowPlayingPointer = CFBundleGetFunctionPointerForName(bundle, "MRMediaRemoteRegisterForNowPlayingNotifications" as CFString)
		typealias nowPlayingFunction = @convention(c) (DispatchQueue) -> Void
		let nowPlaying = unsafeBitCast(nowPlayingPointer, to: nowPlayingFunction.self)
		
		let nowPlayingInfoPointer = CFBundleGetFunctionPointerForName(bundle, "MRMediaRemoteGetNowPlayingInfo" as CFString)
		typealias nowPlayingInfoFunction = @convention(c) (DispatchQueue, @escaping ([String: Any]) -> Void) -> Void
		let nowPlayingInfo = unsafeBitCast(nowPlayingInfoPointer, to: nowPlayingInfoFunction.self)
		
		var lastValue = false
		var lastUsed = NSDate().timeIntervalSince1970.rounded()
		
		NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "kMRMediaRemoteNowPlayingInfoDidChangeNotification"), object: nil, queue: nil) { _ in
			nowPlayingInfo(DispatchQueue.main, { information in
				let isPlaying = type(of: information["kMRMediaRemoteNowPlayingInfoPlaybackRate"] ?? 0) != Int.self
				
				if isPlaying != lastValue && isPlaying {
					let now = NSDate().timeIntervalSince1970.rounded()
					
					if now - lastUsed == 1 {
						return
					}
					
					lastUsed = now
					callback()
				}
				
				lastValue = isPlaying
			})
		}
		
		nowPlaying(DispatchQueue.main)
	}
}
