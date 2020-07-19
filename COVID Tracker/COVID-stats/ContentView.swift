//
//  ContentView.swift
//  COVID-stats
//
//  Created by Wohooo on 7/17/20.
//

import SwiftUI
import Foundation


struct ContentView: View {
    @State private var showingAlert = false
    @State private var deaths2 = ""
    @State private var tested2 = ""
    @State private var positive2 = ""
    @State private var positivityrate = 1.0
    @State private var deathrate = 1.0
    @State private var stateName = "PLACEHOLDER"
    @State private var epoch = 1.0
    @State private var newdate = ""
    var body: some View {
        
        
            
        NavigationView {
            
            List(allStates, id: \.self) { state in
                

                Text(state)
                    .font(.system(size: 25.0))
                    .fontWeight(.semibold)
                    .padding()
                    
                    
                Spacer()
                Button(action: {
                  
                    var result = api(state: state, completion: {finaldeaths, finaltested, finalpositive, finalepoch in
                        print("\(state) deaths: \(finaldeaths)")
                        deaths2 = finaldeaths
                        tested2 = finaltested
                        positive2 = finalpositive
                        positivityrate = (Double(positive2)!/Double(tested2)!) * 100
                        deathrate = (Double(deaths2)!/Double(positive2)!) * 100
                        epoch = finalepoch
                        let date = NSDate(timeIntervalSince1970: epoch)
                        let dayTimePeriodFormatter = DateFormatter()
                        dayTimePeriodFormatter.dateFormat = "MMM dd YYYY hh:mm a"

                        newdate = dayTimePeriodFormatter.string(from: date as Date)
                        
                        
                        
                    })
                    self.showingAlert = true
                }) {
//
                    HStack {
                            Image(systemName: "info.circle")
                                .font(.system(size: 20.0))
                            Text("Details")
                                .fontWeight(.semibold)
                                .font(.system(size: 20.0))
                        }
                        .padding()
                        .foregroundColor(.blue)
                        
                        .cornerRadius(40)
                }
                
                .alert(isPresented: $showingAlert) {
                    return Alert(title: Text("\(state) stats "), message: Text("Deaths: \(deaths2) \n Tested Positive: \(positive2) \n Total Tested: \(tested2) \n \n Positivity Rate: \(positivityrate)% \n Death Rate: \(deathrate)% \n \n Last Update: \(newdate)"), dismissButton: .default(Text("Dismiss")))
                }
                .padding()
                .cornerRadius(25)
            }
            
            .navigationTitle("COVID-19 Stats")

        }
            
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

func api(state: String, completion: @escaping (_ finaldeaths: String, _ finaltested: String, _ finalpositive: String, _ finalepoch: Double) -> ()) {
    
    var finaldeaths = "PLACE"
    var finaltested = "PLACE"
    var finalpositive = "PLACE"
    var finalepoch = 1.0
    
    let url = URL(string: "http://coronavirusapi.com/getTimeSeries/\(state)")!

    let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
        if error == nil {
            let loaded = String(data: data!, encoding: String.Encoding.utf8)
            var currentstate = state
            var sortedData = sort(data: loaded!)
            var deaths = (sortedData.last)?[3]
            var tested = (sortedData.last)?[1]
            var positive = (sortedData.last)?[2]
            var epoch = (sortedData.last)?[0]
            
            finaldeaths = deaths ?? "nil"
            finaltested = tested ?? "nil"
            finalpositive = positive ?? "nil"
            finalepoch = Double(epoch!) ?? 0.0
        }
        completion(finaldeaths, finaltested, finalpositive, finalepoch)
    })

    task.resume()
    
}

func sort(data: String) -> [[String]] {
    var result: [[String]] = []
    let rows = data.components(separatedBy: "\n")
    for row in rows {
        let columns = row.components(separatedBy: ",")
        result.append(columns)
    }
    return result
}

let allStates = ["NY", "CA", "TX", "FL", "NJ", "IL", "AZ", "GA", "MA", "PA", "NC", "LA", "MI", "MD", "VA", "OH", "TN", "AL", "SC", "IN", "CT", "MN", "WA", "MS", "CO", "WI", "IA", "NV", "UT", "AR", "MO", "OK", "KY", "NE", "KS", "RI", "NM", "ID", "DE", "OR", "DC", "PR", "SD", "NH", "ND", "WV", "ME", "MT", "WY", "AK", "VT", "HI"]

