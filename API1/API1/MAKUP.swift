//
//  MAKUP.swift
//  API1
//
//  Created by khloud on 10/11/1444 AH.
//

import SwiftUI

struct MakeUp: Codable {
    let products: Product
}

struct Product: Codable ,Identifiable{
    let productType: String
    let name: String
    let price: String
    let imageLink: String
    let productLink: String
    let description: String
    
    var id: String {
        name
    }
}

struct MAKUP: View {
    @State private var products = Product(productType: "", name: "", price: "", imageLink: "", productLink: "", description: "")
    
    var body: some View {
        VStack{
            
          
        }
        .task {
            await fetchProducts()
        }
    }
    
    func fetchProducts() async {
        let makeupApiUrl = "https://makeup-api.herokuapp.com/api/v1/products.json?brand=maybelline"
        
        guard let url = URL(string: makeupApiUrl) else {
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
            
            let apiData = try JSONDecoder().decode(MakeUp.self, from: data)
            products = apiData.products
           
        } catch {
            print("Error \(error)")
        }
    }
}

struct MAKUP_Previews: PreviewProvider {
    static var previews: some View {
        MAKUP()
    }
}


//struct ProductCard: View {
//    let product: Product
//
//    var body: some View {
//        VStack {
//            Text(product.name)
//            AsyncImage(url: URL(string: product.imageLink))
//            AsyncImage(url: URL(string: product.productLink))
//            Text(product.description)
//        }
//    }
//}
