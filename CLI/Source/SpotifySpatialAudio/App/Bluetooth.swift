//
//  Bluetooth.swift
//
//  Created by Dervex with <3 on 12/09/2023.
//

import Foundation
import IOBluetooth

struct Bluetooth {
	static func isUsingSupportedDevice() -> Bool {
		guard let devices = IOBluetoothDevice.pairedDevices() else {
			return false
		}
		
		for item in devices {
			if let device = item as? IOBluetoothDevice {
				if device.isConnected() && SUPPORTED_DEVICES.contains(device.name) {
					return true
				}
			}
		}
		
		return false
	}
}
