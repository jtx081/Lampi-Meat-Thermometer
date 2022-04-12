import SwiftUI

struct LampiView: View {
    @ObservedObject var lamp : Lampi
    

    var body: some View {
        let brightness = Double(round(lamp.state.brightness * 1000) / 1000)
        
        VStack {
            Text("\(brightness)").padding()
//            Text("\(round(lamp.state.brightness * 1000) / 1000.0)")
//                        .padding()
//            Rectangle()
//                .fill(lampi.color)
//                .edgesIgnoringSafeArea(.top)

//            Group {
//                GradientSlider(value: $lampi.hue,
//                               handleColor: lampi.baseHueColor,
//                               trackColors: Color.rainbow())
//
//                GradientSlider(value: $lampi.saturation,
//                               handleColor: Color(hue: lampi.hue,
//                                                  saturation: lampi.saturation,
//                                                  brightness: 1.0),
//                               trackColors: [.white, lampi.baseHueColor])
//
//                GradientSlider(value: $lampi.brightness,
//                               handleColor: Color(white: lampi.brightness),
//                               handleImage: Image(systemName: "sun.max"),
//                               trackColors: [.black, .white])
//                    .foregroundColor(Color(white: 1.0 - lampi.brightness))
//            }.padding()

//            Button(action: {
//                lampi.isOn.toggle()
//            }) {
//                HStack {
//                    Spacer()
//                    Image(systemName: "power")
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
//                    Spacer()
//                }.padding()
//            }
//            .frame(height: 100)
//            .background(Color.black.edgesIgnoringSafeArea(.bottom))
//            .foregroundColor(lampi.isOn ? lampi.color : .gray)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LampiView(lamp: Lampi(name: "LAMPI b827eb1aabd5"))
                    .previewDevice("iPhone 12 Pro")
                    .previewLayout(.device)
    }
}
