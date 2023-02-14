

import SwiftUI
import AudioKit

struct RView: View {
    var feature: Feature
    
    var body: some View {
        Text("Tuner")
            .navigationTitle(feature.name)
            .navigationBarTitleDisplayMode(.inline)
    }
    
    struct Detail_Previews: PreviewProvider {
        static var previews: some View {
            FeatureDetail(feature: features[0])
        }
    }
}


