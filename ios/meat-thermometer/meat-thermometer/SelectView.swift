import SwiftUI

struct SelectView: View {
    @State private var isPresented = false
    @State private var meatSelect = "Steak"
    @State private var doneSelect = "Medium"
    @State private var goalTemp = 0
    
    let meat = ["Steak", "Ground Beef", "Poultry", "Pork", "Lamb", "Boiled Water", "Hand"]
    
    let steakDone = ["Rare", "Medium-Rare", "Medium", "Medium-Well", "Well-Done"]
    let beefDone = ["Medium-Rare", "Medium", "Medium-Well", "Well-Done"]
    let porkDone = ["Medium", "Well-Done"]
    let lambDone = ["Rare", "Medium-Rare", "Medium", "Medium-Well", "Well-Done"]
    
    
    var body: some View {

        VStack {
            Text("Select Meat:").padding().font(.system(size: 30))
            
            Picker("Select meat", selection: $meatSelect) {
               ForEach(meat, id: \.self) {
                   Text($0)
               }
            }.pickerStyle(.menu)
            
            
            if meatSelect == "Steak"{
                Text("Select Doneness:").padding().font(.system(size: 30))
                
                Picker("Select doneness", selection: $doneSelect) {
                   ForEach(steakDone, id: \.self) {
                       Text($0)
                   }
                }.pickerStyle(.menu)
                
            }
            
            if meatSelect == "Ground Beef"{
                Text("Select Doneness:").padding().font(.system(size: 30))
                
                Picker("Select doneness", selection: $doneSelect) {
                   ForEach(beefDone, id: \.self) {
                       Text($0)
                   }
                }.pickerStyle(.menu)

            }
            
            if meatSelect == "Pork"{
                Text("Select Doneness:").padding().font(.system(size: 30))
                
                Picker("Select doneness", selection: $doneSelect) {
                   ForEach(porkDone, id: \.self) {
                       Text($0)
                   }
                }.pickerStyle(.menu)

            }
            
            if meatSelect == "Lamb"{
                Text("Select Doneness:").padding().font(.system(size: 30))
                
                Picker("Select doneness", selection: $doneSelect) {
                   ForEach(lambDone, id: \.self) {
                       Text($0)
                   }
                }.pickerStyle(.menu)
                
            }

           
            Button {
                self.isPresented = true
            } label:{
                Text("BEGIN")
                    .frame(width: 150, height: 20)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.blue)
            }.clipShape(Capsule())
        }
        .fullScreenCover(isPresented: $isPresented){
            LampiView(lamp: Lampi(name: "LAMPI b827eb1aabd5"), goal: $goalTemp, meat: $meatSelect, done: $doneSelect)

        }.ignoresSafeArea(edges: .all)
    }
        
}

struct SelectView_Previews: PreviewProvider {
    static var previews: some View {
        SelectView()
    }
}


