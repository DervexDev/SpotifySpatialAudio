//
//  Config.swift
//
//  Created by Dervex with <3 on 03/08/2023.
//

let SERVER_HOST: String = "localhost"
let SERVER_PORT: Int = 8888

let SAFARI_HIDE_DELAY = 3

let CLIENT_ID: String = "" // Add your client id here
let CLIENT_SECRET: String = "" // Add you client secret here

let START_URL: String = "http://" + SERVER_HOST + ":" + String(SERVER_PORT) + "/login"
let REDIRECT_URL: String = "http://" + SERVER_HOST + ":" + String(SERVER_PORT) + "/callback"

let SCOPES: Array<String> = [
	"user-read-playback-state",
	"user-modify-playback-state"
]
