//
//  MainView.swift
//  BLETest
//
//  Created by Guy Livneh on 30/03/2020.
//  Copyright © 2020 Adam Zigdon. All rights reserved.
//

import SwiftUI

struct MainView: View {
  @ObservedObject var bleManager = BleManager()
  init() {
    bleManager.load()
  }
  
  var body: some View {
    VStack {
      Text(bleManager.stateDescription)
        .font(.title)
      List(0..<bleManager.detectedBeacons.count){ itemIndex in
        Text(self.bleManager.detectedBeacons[itemIndex])
      }
    }
  }
}

struct MainView_Previews: PreviewProvider {
  static var previews: some View {
    MainView()
  }
}
