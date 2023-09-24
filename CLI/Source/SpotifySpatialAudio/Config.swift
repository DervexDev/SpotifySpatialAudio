//
//  Config.swift
//
//  Created by Dervex with <3 on 03/08/2023.
//

let SERVER_HOST: String = "localhost"
let SERVER_PORT: Int = 8888

let DATA_FILE_NAME: String = ".ssa.json"
let OPEN_SAFARI_MAX_ATTEMPTS = 10

let CLIENT_ID: String = "" // Add your client id here
let CLIENT_SECRET: String = "" // Add you client secret here

let START_URL: String = "http://" + SERVER_HOST + ":" + String(SERVER_PORT) + "/login"
let REDIRECT_URL: String = "http://" + SERVER_HOST + ":" + String(SERVER_PORT) + "/callback"

let SCOPES: Array<String> = [
	"user-read-playback-state",
	"user-modify-playback-state"
]

let SUPPORTED_DEVICES = [
	"AirPods Pro",
	"AirPods Max",
	"AirPods",
	"Beats Fit Pro",
	"Beats Studio Pro"
]
