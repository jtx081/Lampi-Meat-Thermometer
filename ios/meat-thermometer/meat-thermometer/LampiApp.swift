import SwiftUI

@main
struct LampiApp: App {

    let DEVICE_NAME = "LAMPI b827ebe4ff09"

    var body: some Scene {
        WindowGroup {
            LampiView(lamp: Lampi(name: DEVICE_NAME))
        }
    }
}
