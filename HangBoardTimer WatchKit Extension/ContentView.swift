import SwiftUI
import UIKit
import WatchKit
import HealthKit
import Foundation

struct ContentView: View {
    @State var secondScreenShown = false
    @State var workTime: Double = 10
    @State var restTime: Double = 7
    
    var body: some View {
        VStack{
            Text("Work/Rest : \(String(format: "%.0f",workTime)) / \(String(format: "%.0f",restTime))").font(.system(size: 14))
            HStack {
                ForEach(0..<2) { j in
                    Picker(selection: [$workTime, $restTime][j], label: Text("")) {
                        ForEach(0..<21) { i in Text(i.description).tag(Double(i))}
                    }
                }
            }.padding(.bottom)
            NavigationLink(destination: SecondView(secondScreenShown: $secondScreenShown, workTime: workTime, restTime: restTime, workTimeLimit: workTime, restTimeLimit: restTime), isActive: $secondScreenShown, label: {Text("Go")})
        }
    }
}

struct SecondView: View{
    @Binding var secondScreenShown:Bool
    @State var workTime: Double
    @State var restTime: Double
    var workTimeLimit: Double
    var restTimeLimit: Double
    
    var body: some View {
        var workTimer = Timer()
        var restTimer = Timer()
        
        VStack{
            if workTime >= 0 {
                Text("WORK").font(.system(size: 20))
                Text("\(String(format: "%.0f",workTime))").font(.system(size: 50))
                    .onAppear(){
                        workTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
                                if self.workTime >= 0 {
                                    self.workTime -= 0.1
                                }
                                else {
                                    workTimer.invalidate()
                                    restTime = restTimeLimit
                                    WKInterfaceDevice.current().play(.directionDown)
                                }
                            }
                    }
                Text("seconds").font(.system(size: 20))
            }
            else if restTime >= 0 {
                Text("REST").font(.system(size: 20))
                Text("\(String(format: "%.0f",restTime))").font(.system(size: 50))
                    .onAppear(){
                        restTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
                            if self.restTime >= 0 {
                                self.restTime -= 0.1
                                }
                                else {
                                    restTimer.invalidate()
                                    workTime = workTimeLimit
                                    WKInterfaceDevice.current().play(.directionUp)
                                }
                            }
                    }
                Text("seconds").font(.system(size: 20))
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

