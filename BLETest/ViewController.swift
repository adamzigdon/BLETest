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

class ViewController: UIViewController {
    var centralManager: CBCentralManager!
    var locationManager: CLLocationManager!
    var lastNotifiedFind: NSDate = NSDate()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        centralManager = CBCentralManager(delegate: self, queue: nil)
        locationManager = CLLocationManager()
        locationManager.requestAlwaysAuthorization()
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager!.pausesLocationUpdatesAutomatically = false
        locationManager.delegate = self;
        let region = CLBeaconRegion(proximityUUID: UUID(uuidString: "7E5BF3C6-B093-4523-8CCE-B02AE0BC4C39")!,
        //             major: 1234,
        //             minor: 1234,
                identifier: "MyBeacons")
        locationManager.startMonitoring(for: region)
    }
}

extension ViewController: CBCentralManagerDelegate, CLLocationManagerDelegate {
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print(peripheral)
        print(advertisementData)
        print(RSSI)
    }

    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        for beacon in beacons {
            print("\(beacon.proximityUUID)\t\(beacon.major)\t\(beacon.minor)\t\(beacon.rssi)");
        }
    }

    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("Entered")

        let region = CLBeaconRegion(proximityUUID: UUID(uuidString: "7E5BF3C6-B093-4523-8CCE-B02AE0BC4C39")!,
        //             major: 1234,
        //             minor: 1234,
                identifier: "MyBeacons")
        locationManager.startRangingBeacons(in: region)
        manager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("Exited")
        manager.stopUpdatingLocation()
    }

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
//        central.scanForPeripherals(withServices: [CBUUID(string: "FEAA")], options: [CBCentralManagerScanOptionAllowDuplicatesKey: true])
//        central.scanForPeripherals(withServices: nil, options: nil)
    }
}
