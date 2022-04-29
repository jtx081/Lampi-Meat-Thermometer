import SwiftUI

struct HelpView: View {

    
    var body: some View {
        Text("HELP").padding().font(.system(size: 30))
        
        Text("The LAMPI meat thermometer is easy to use. Simply select type of meat and desired doneness and stick the probe into the meat. The color and brightness on the lamp will change accordingly. The light/touchscreen as well as the app will all notify you when the meat is ready to eat!").padding().font(.system(size: 15))
        
        Text("Meat Temperature Guide").padding().font(.system(size: 30))
            
        Image("Meat").resizable().scaledToFit()
            
        Image("Doneness").resizable().scaledToFit()
        
    }
        
}

struct HelpView_Previews: PreviewProvider {
    static var previews: some View {
        HelpView()
    }
}


