

import SwiftUI

struct FeatureDetail: View {
    var feature: Feature
    
    var body: some View {
        ScrollView {
            CircleImage(image: feature.image)
                    .offset(y: -130)
                    .padding(.bottom, -130)
            VStack (alignment: .leading) {
                Text(feature.name)
                    .font(.title)
                    .foregroundColor(.black)
                .font(.subheadline)
                .foregroundColor(.secondary)
                
                Divider()
                
                Text("About \(feature.name)")
                    .font(.title2)
                Text(feature.description)
            }
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
