//
//  CoreApp
//  Core
//
//  Created by aaronevanjulio on 12/06/26.
//

import SwiftUI
import OwlNav

@main
struct CoreApp: App {

    init() {
        OwlInject.initFunc()
    }

    var body: some Scene {
        WindowGroup {
            AppRootView()
        }
    }
}
