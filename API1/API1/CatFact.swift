//
//  CatFact.swift
//  API1
//
//  Created by khloud on 11/11/1444 AH.
//

import SwiftUI

struct Cat: Codable {
    
    let fact: String
    let length : Int
}


struct CatFact: View {
    @State private var cats = Cat(fact: "", length : Int())
    
    var body: some View {
        VStack{
            Text(cats.fact)
            Text("\(cats.length)")
        }
        
        .task {
            await loadData()
        }
    }
    
    func loadData() async{
        guard let url = URL(string: "https://catfact.ninja/fact") else{
            print("OH ... URL NOT WOK")
            return
        }
    
        do {
            let (data , _) = try await URLSession.shared.data(from: url)
            
            let serverData = try JSONDecoder().decode(Cat.self, from: data)
            cats = serverData
            
            
        } catch {
            print("ERROR \(error)")
        }
    }
    
}

struct CatFact_Previews: PreviewProvider {
    static var previews: some View {
        CatFact()
    }
}
