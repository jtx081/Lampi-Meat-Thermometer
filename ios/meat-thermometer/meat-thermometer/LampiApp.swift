import SwiftUI

@main
struct LampiApp: App {

    let DEVICE_NAME = "LAMPI b827eb1aabd5"

    var body: some Scene {
        WindowGroup {
            LampiView(lamp: Lampi(name: DEVICE_NAME))
        }
    }
}
