

import SwiftUI

struct FeatureDetail: View {
    var feature: Feature
    
    var body: some View {
            CircleImage(image: feature.image)
                    .offset(y: -270)
                    .padding(.bottom, -130)
            VStack (alignment: .leading) {

                
                Divider()
                
                Text(feature.description)
                    .padding()
        }
        .navigationTitle(feature.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct Detail_Previews: PreviewProvider {
    static var previews: some View {
        FeatureDetail(feature: features[0])
    }
}
