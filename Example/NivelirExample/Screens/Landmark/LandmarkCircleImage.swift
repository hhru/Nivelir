import SwiftUI

struct LandmarkCircleImage: View {
    var body: some View {
        Image("Turtlerock")
            .accessibilityLabel("Turtle Rock")
            .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
            .overlay {
                Circle().stroke(.white, lineWidth: 4)
            }
            .shadow(radius: 7)
    }
}

struct CircleImage_Previews: PreviewProvider {
    static var previews: some View {
        LandmarkCircleImage()
    }
}
