//
//  CSVDemo.swift
//  COVID-stats
//
//  Created by Wohooo on 7/17/20.
//

import UIKit

class CSVDemo: NSObject {
    var  data:[[String:AnyObject]] = []
    var  columnTitles:[String] = []
    var  columnType:[String] = ["NSDate","Int","Int"]
    var  importDateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
     
    func cleanRows(stringData:String)->[String]{
        //use a uniform \n for end of lines.
        var cleanFile = stringData
        cleanFile = cleanFile.replacingOccurrences(of: "\r", with: "\n")
        cleanFile = cleanFile.replacingOccurrences(of: "\n\n", with: "\n")
        return cleanFile.components(separatedBy: "\n")
    }
 
    func cleanFields(oldString:String) -> [String]{
        let delimiter = "\t"
        var newString = oldString.replacingOccurrences(of: "\",\"", with: delimiter)
        newString = newString.replacingOccurrences(of: ",\"", with: delimiter)
        newString = newString.replacingOccurrences(of: "\",", with: delimiter)
        newString = newString.replacingOccurrences(of: "\"", with: "")
        return newString.components(separatedBy: delimiter)
    }
     
    func convertCSV(stringData:String) -> [[String:AnyObject]] {
        //for date formatting
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = importDateFormat
        //dateFormatter.timeZone = NSTimeZone(abbreviation: "GMT")
         
        let rows = cleanRows(stringData: stringData)
        if rows.count > 0 {
            data = []
            columnTitles = cleanFields(oldString: rows.first!)
            for row in rows{
                let fields = cleanFields(oldString: row)
                if fields.count != columnTitles.count {continue}
                var newRow = [String:AnyObject]()
                for index in 1..<fields.count{
                    let column = columnTitles[index]
                    let field = fields[index]
                    switch columnType[index]
                    { case "Int": newRow[column] = Int(field) case "NSDate": guard let newField = dateFormatter.dateFromString(field) else { print ("\(field) didn\'t convert") continue } newRow[column] = newField default: //default keeps as string newRow[column] = field } } data += [newRow] } } else { print("No data in file") } return data } func printTotalsAndRatio()-> String{
        var north = 0
        var south = 0
        for index in 1..<data.count{ let row = data[index] north += row["fremont_bridge_nb"] as! Int south += row["fremont_bridge_sb"] as! Int } let totalCrossings = north + south let totalAverageCrossings = totalCrossings / 30 let averageNorthCrossings = north / 30 let averageSouthCrossings = south / 30 let crossingRatio = Double(north) / Double(south) var displayString = "Fremont Bridge April 2016 Data\n" displayString += String(format:"North Side Count:%8i SouthSide Count%8i\n",north,south) displayString += String(format:"Total Crossings:%8i\n",totalCrossings) displayString += String(format:"Average Crossings per day:%8i\n",totalAverageCrossings) displayString += String(format:"North Side Average:%8i SouthSide Average%8i\n", averageNorthCrossings,averageSouthCrossings) displayString += String(format:"North/South ratio:%8.3f",crossingRatio) return displayString } func readStringFromURL(stringURL:String)-> String!{
        if let url = NSURL(string: stringURL) {
            do {
                 return try String(contentsOfURL: url, usedEncoding: nil)
                 
            } catch {
                print("Cannot load contents")
                return nil
            }
        } else {
            print("String was not a URL")
            return nil
        }
    }
 
 
}
