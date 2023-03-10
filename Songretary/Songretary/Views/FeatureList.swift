

import SwiftUI

struct FeatureList: View {
    var body: some View {
        NavigationView {
            List(features) { feature in
                NavigationLink {
                    FeatureDetail(feature: feature)
                } label: {
                    FeatureRow(feature: feature)
                }
            }
            .navigationTitle("features")
        }
    }
}

struct FeatureList_Previews: PreviewProvider {
    static var previews: some View {
        FeatureList()
    }
}
