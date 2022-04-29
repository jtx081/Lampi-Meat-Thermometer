import SwiftUI

enum ActiveSheet: Identifiable {
    case first, second
    
    var id: Int {
        hashValue
    }
}

struct HomeView: View {
    @State var activeSheet: ActiveSheet?
    
    var body: some View {
 
        VStack {
            
            Image(systemName: "thermometer")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 150, height: 150)
            
            Text("LAMPI meat thermometer").padding().font(.system(size: 30))
            
            Button {
                activeSheet = .first
            } label:{
                Text("START")
                    .frame(width: 150, height: 20)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.blue)
            }.clipShape(Capsule())
            
            Button {
                activeSheet = .second
            } label:{
                Text("HELP")
                    .frame(width: 150, height: 20)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.blue)
            }.clipShape(Capsule())

        }
        .sheet(item: $activeSheet) { item in
                    switch item {
                    case .first:
                        SelectView()
                    case .second:
                        HelpView()
                    }
        }
       
    }
        
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
