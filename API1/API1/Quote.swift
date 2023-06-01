//
//  Quote.swift
//  API1
//
//  Created by khloud on 11/11/1444 AH.
//

import SwiftUI

struct Quotes: Codable {
    let data: [Datum]
    
}

struct Datum: Codable ,Identifiable {
    let quoteText :String
    let quoteAuthor: String
    
    var id : String{
        quoteText
    }
}


struct Quote: View {
    @State private var quotes = [Datum]()
    
    var body: some View {
        List(quotes) { quote  in
            VStack{
                Text(quote.id)
                Text(quote.quoteText)
                Spacer()
                Text(quote.quoteAuthor)
                
                
            }
        }.task {
            await loadData()
        }
    }
    
    
        func loadData() async{
            guard let url = URL(string: "https://quote-garden.onrender.com/api/v3/quotes") else{
                print("OH ... URL NOT WOK")
                
                return
            }
            
            do{
                let (data , _) = try await URLSession.shared.data(from: url)
                
                if let dataAsString = String (data: data, encoding: .utf8){
                    print("Data as String:\(dataAsString)")
                }
                
                let serverData = try JSONDecoder().decode(Quotes.self, from: data)
                quotes = serverData.data
                
                
            }catch {
                print("ERROR \(error)")
                
            }
        }
    }

struct Quote_Previews: PreviewProvider {
    static var previews: some View {
        Quote()
    }
}
