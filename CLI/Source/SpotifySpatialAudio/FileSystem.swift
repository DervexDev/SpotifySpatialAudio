//
//  FileSystem.swift
//
//  Created by Dervex with <3 on 04/08/2023.
//

import Foundation

let FILE_NAME: String = ".ssa.json"

struct FileSystem {
	static func loadJSON() throws -> Any? {
		let fileManager = FileManager.default
		let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
		
		if let url = urls.first {
			let file = url.appendingPathComponent(FILE_NAME)
			
			if !fileManager.fileExists(atPath: file.path()) {
				return nil
			}
			
			let data = try Data(contentsOf: file)
			let json = try JSONSerialization.jsonObject(with: data, options: [.mutableContainers, .mutableLeaves])
			
			return json
		}
		
		return nil
	}
	
	@discardableResult
	static func saveJSON(json: Any) throws -> Bool {
		let fileManager = FileManager.default
		let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
		
		if let url = urls.first {
			let file = url.appendingPathComponent(FILE_NAME)
			let data = try JSONSerialization.data(withJSONObject: json, options: [.prettyPrinted])
			try data.write(to: file, options: [.atomicWrite])
			
			return true
		}
		
		return false
	}
	
}
