import SwiftUI

struct LandmarkView: View {
    var body: some View {
        VStack {
            LandmarkMapView()
                .ignoresSafeArea(edges: .top)
                .frame(height: 300)

            LandmarkCircleImage()
                .offset(y: -130)
                .padding(.bottom, -130)

            VStack(alignment: .leading) {
                Text("Turtle Rock")
                    .font(.title)

                HStack {
                    Text("Joshua Tree National Park")
                    Spacer()
                    Text("California")
                }
                .font(.subheadline)
                .foregroundColor(.secondary)

                Divider()

                Text("About Turtle Rock").font(.title2)

                Text("Descriptive text goes here.")
            }
            .padding()

            Spacer()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LandmarkView()
    }
}
