//
//  CoreApp
//  Core
//
//  Created by aaronevanjulio on 12/06/26.
//

import SwiftUI

@main
struct CoreApp: App {

    // Wire up the DI container once at app launch
    @State private var container = DIContainer.shared

    var body: some Scene {
        WindowGroup {
            AppRootView()
        }
    }
}
