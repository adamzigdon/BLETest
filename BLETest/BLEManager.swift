//
//  ViewController.swift
//  BLETest
//
//  Created by Adam Zigdon on 24/03/2020.
//  Copyright © 2020 Adam Zigdon. All rights reserved.
//

import UIKit
import CoreBluetooth
import CoreLocation

fileprivate let beaconUUID = UUID(uuidString: "7E5BF3C6-B093-4523-8CCE-B02AE0BC4C39")!
fileprivate let beaconConstraint = CLBeaconIdentityConstraint(uuid: beaconUUID)

class BleManager : NSObject, ObservableObject {
  @Published var stateDescription = "Initializing" {
    didSet {
      print(stateDescription)
    }
  }
  @Published var detectedBeacons : [String] = [] {
    didSet {
      print(detectedBeacons)
    }
  }

  fileprivate var centralManager: CBCentralManager!
  fileprivate var locationManager: CLLocationManager!

  func load() {
    stateDescription = "Launching..."
    centralManager = CBCentralManager(delegate: self, queue: DispatchQueue.main)
    locationManager = CLLocationManager()
    locationManager.requestAlwaysAuthorization()
    locationManager.allowsBackgroundLocationUpdates = true
    locationManager.pausesLocationUpdatesAutomatically = false
    locationManager.delegate = self
  }
  fileprivate func startUpdatingLocation(_ manager: CLLocationManager) {
    manager.startRangingBeacons(satisfying: beaconConstraint)
    manager.startUpdatingLocation()
  }

  fileprivate func stopUpdatingLocation(_ manager: CLLocationManager) {
    manager.stopUpdatingLocation()
    manager.stopRangingBeacons(satisfying: beaconConstraint)
  }
}

extension BleManager: CBCentralManagerDelegate, CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
    stateDescription = "Entered Region"
    startUpdatingLocation(manager)
  }

  func locationManager(_ manager: CLLocationManager, didRange beacons: [CLBeacon], satisfying beaconConstraint: CLBeaconIdentityConstraint) {
    for beacon in beacons {
      let detectedBeaconString = "\(beacon.proximity)\t\(beacon.major)\t\(beacon.minor)\t\(beacon.rssi)"
      detectedBeacons = detectedBeacons + [detectedBeaconString]
    }
   }

  func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
    stateDescription = "Exited Region"
    stopUpdatingLocation(manager)
  }

  func locationManager(_ manager: CLLocationManager, didFailRangingFor beaconConstraint: CLBeaconIdentityConstraint, error: Error) {
    stateDescription = "Failed Ranging"
    stopUpdatingLocation(manager)
  }

  func centralManagerDidUpdateState(_ central: CBCentralManager) {
    if centralManager.state == .poweredOn {
      stateDescription = "Scanning"
      let region = CLBeaconRegion(uuid: beaconUUID , identifier: "MyBeacons")
      locationManager.startMonitoring(for: region)
    } else {
      stateDescription = "Bluetooth N/A"
    }
  }
}

