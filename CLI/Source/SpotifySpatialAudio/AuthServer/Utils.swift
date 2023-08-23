//
//  Utils.swift
//
//  Created by Dervex with <3 on 02/08/2023.
//

import Foundation

struct Utils {
	static func generateRandomString(length: Int) -> String {
		let possible = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
		return String((0..<length).map{ _ in possible.randomElement()! })
	}
	
	static func getScopes(scopes: Array<String>) -> String {
		var string = ""
		
		for scope in scopes {
			string += scope + " "
		}
		
		return string
	}
}
