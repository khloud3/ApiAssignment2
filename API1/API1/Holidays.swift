//
//  Holidays.swift
//  API1
//
//  Created by khloud on 12/11/1444 AH.
//

import SwiftUI

struct HolidaysDays: Codable{
    let events: [Events]
}


struct Events: Codable , Identifiable{
    let id: UUID
    let title: String
    let date: String
    
}


struct Holidays: View {
    @State private var events = [Events]()
    
    var body: some View {
        List(events){ event  in
            VStack{
                Text(event.title)
                Text(event.date)
            }
            
        }.task {
            await fetchProducts()
        }
    }
    
    func fetchProducts() async {
        let EventApiUrl = "https://www.gov.uk/bank-holidays.json"
        
        guard let url = URL(string: EventApiUrl) else {
            print("OH ... THE URL DOES NOT WORK")
            return
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                print("Can not get status code")
                return
            }
            
            if statusCode < 200 || statusCode > 299 {
                print("Status code: \(statusCode), is not in 200s.")
                return
            }
            
            guard let dataAsString = String(data: data, encoding: .utf8) else {
                print("Can not convert data to string")
                return
            }
            
            print("Data as String: \(dataAsString)")
            
            let apiData = try JSONDecoder().decode(HolidaysDays.self, from: data)
            events = apiData.events
            
        } catch {
            print("Error \(error)")
        }
    }
}

struct Holidays_Previews: PreviewProvider {
    static var previews: some View {
        Holidays()
    }
}
