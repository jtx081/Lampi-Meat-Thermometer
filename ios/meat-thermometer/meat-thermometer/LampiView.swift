import SwiftUI

struct LampiView: View {
    @ObservedObject var lamp : Lampi
    @State private var isPresented = false
    @State private var isStart = false
    @Environment(\.presentationMode) var presentationMode
    @Binding var goal: Int
    @Binding var meat: String
    @Binding var done: String

    
    var steakTemp = ["Rare": "125", "Medium-Rare": "130", "Medium": "140", "Medium-Well": "150", "Well-Done": "160"]
    var beefTemp = ["Medium-Rare": "125", "Medium": "130", "Medium-Well": "140", "Well-Done": "160"]
    var porkTemp = ["Medium": "150", "Well-Done": "160"]
    var lambTemp = ["Rare": "125", "Medium-Rare": "130", "Medium": "140", "Medium-Well": "150", "Well-Done": "160"]
    
    func setGoalTemp(){
        if meat == "Steak"{
            goal = Int(steakTemp[done]!)!
            lamp.state.goal = goal
        }
        if meat == "Ground Beef"{
            goal = Int(beefTemp[done]!)!
            lamp.state.goal = goal
        }
        if meat == "Poultry"{
            goal = 165
            lamp.state.goal = goal
        }
        if meat == "Pork"{
            goal = Int(porkTemp[done]!)!
            lamp.state.goal = goal
        }
        if meat == "Lamb"{
            goal = Int(lambTemp[done]!)!
            lamp.state.goal = goal
        }
        if meat == "Boiled Water"{
            goal = 150
            lamp.state.goal = goal
        }
        
        if meat == "Hand"{
            goal = 80
            lamp.state.goal = goal
        }
    }

    var body: some View {
        let currentTemp = Int(lamp.state.temperature)
        
        VStack {
            if isStart == true{
                if lamp.state.isDone == 1 {
                    Text("DONE! Ready to eat.").padding().font(.system(size: 30))
                }
                
                else{
                    Text("Goal: " + "\(goal)").padding().font(.system(size: 15))
                    
                    Text("Meat Temperature:").padding().font(.system(size: 30))
                    Text("\(currentTemp)" + " F").padding().font(.system(size: 56.0))
                }
            }
            else{
                Text("Please stick thermometer in meat before pressing start.").padding().font(.system(size: 30))
                Button {
                    self.isStart = true
                    setGoalTemp()
                } label:{
                    Text("START")
                        .frame(width: 150, height: 20)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                }.clipShape(Capsule())

            }

            Button {
                self.isPresented = true
    
            } label:{
                Text("QUIT")
                    .frame(width: 150, height: 20)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.blue)
            }.clipShape(Capsule())

        }.fullScreenCover(isPresented: $isPresented){
            HomeView()
        }.ignoresSafeArea(edges: .all)
    }
        
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LampiView(lamp: Lampi(name: "LAMPI b827eb1aabd5"), goal: .constant(0), meat: .constant(""), done: .constant(""))
                    .previewDevice("iPhone 12 Pro")
                    .previewLayout(.device)
       
    }
}
