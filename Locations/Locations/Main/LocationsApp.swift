//
//  Created by Peter Combee on 05/11/2024.
//

import SwiftUI

@main
struct LocationsApp: App {
    var body: some Scene {
        WindowGroup {
            LocationsView(
                model: LocationsViewModel(
                    locationsProvider: RemoteLocationsProvider(
                        httpClient: UrlSessionHttpClient(
                            session: URLSession(configuration: .ephemeral)
                        )
                    ),
                    onLocationSelection: { location in
                        WikipediaLocationNavigator(openUrl: { UIApplication.shared.open($0) })
                        .showLocationOnWikipedia(location)
                    }
                )
            )
        }
    }
}
