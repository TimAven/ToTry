//
//  ContentView.swift
//  ToTry
//
//  Created by Tim Aven on 5/26/21.
//

import SwiftUI

//{
//  "total": 8228,
//  "businesses": [
//    {
//      "rating": 4,
//      "price": "$",
//      "phone": "+14152520800",
//      "id": "E8RJkjfdcwgtyoPMjQ_Olg",
//      "alias": "four-barrel-coffee-san-francisco",
//      "is_closed": false,
//      "categories": [
//        {
//          "alias": "coffee",
//          "title": "Coffee & Tea"
//        }
//      ],
//      "review_count": 1738,
//      "name": "Four Barrel Coffee",
//      "url": "https://www.yelp.com/biz/four-barrel-coffee-san-francisco",
//      "coordinates": {
//        "latitude": 37.7670169511878,
//        "longitude": -122.42184275
//      },
//      "image_url": "http://s3-media2.fl.yelpcdn.com/bphoto/MmgtASP3l_t4tPCL1iAsCg/o.jpg",
//      "location": {
//        "city": "San Francisco",
//        "country": "US",
//        "address2": "",
//        "address3": "",
//        "state": "CA",
//        "address1": "375 Valencia St",
//        "zip_code": "94103"
//      },
//      "distance": 1604.23,
//      "transactions": ["pickup", "delivery"]
//    },
//    // ...
//  ],
//  "region": {
//    "center": {
//      "latitude": 37.767413217936834,
//      "longitude": -122.42820739746094
//    }
//  }
//}


struct jsonFeed: Decodable {
    let businesses: businesses
}

struct businesses: Decodable {
    let results: [Result]
}

struct Result: Decodable {
    let rating, price, phone, name, image_url: String
}

class GridViewModel: ObservableObject {
    
    @Published var items = 0..<10
    
    init() {
        //json decoding simulation
//        Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { (_) in
//            self.items = 0..<15
//        }
        /*
        https://api.yelp.com/v3/businesses/search?term=delis&latitude=37.786882&longitude=-122.399972
        */
            let latitude = 37.786882
            let longitude = -122.399972
            guard let url = URL(string: "https://api.yelp.com/v3/businesses/search?latitude=\(latitude)&longitude=\(longitude)"
            ) else { return }
            URLSession.shared.dataTask(with: url) { (data, URLResponse, err) in
               
                guard let data = data else { return }
                do {
                    
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                    print(">>>>>>>", json, #line, "<<<<<<<<<<")
                    
                    /*
                    let jsonFeed = try JSONDecoder().decode(jsonFeed.self, from: data)
                    print(jsonFeed)
 */
                } catch {
                    print("Failed to decode \(error)")
                }
            }.resume()
        
    }
}

struct ContentView: View {
    
    @ObservedObject var viewModel = GridViewModel()
    
    
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: [
                    GridItem(.flexible(minimum: 100, maximum: 200), spacing: 12),
                    GridItem(.flexible(minimum: 100, maximum: 200), spacing: 12),
                    GridItem(.flexible(minimum: 100, maximum: 200), spacing: 12)
                ], spacing: 12, content: {
                    
                    ForEach(viewModel.items, id: \.self) { num in
                        VStack(alignment: .leading) {
                            Spacer()
                                .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height:100)
                                .background(Color.blue)
                            
                            Text("Place Title")
                                .font(.system(size: 10, weight: .semibold))
                            Text("Release Date")
                                .font(.system(size: 9, weight: .regular))
                            Text("Copyright")
                                .font(.system(size: 9, weight: .regular))
                                .foregroundColor(.gray)
                        }
                        .background(Color.red)
                    }
                }).padding(.horizontal, 12)
                
            }.navigationTitle("ToTry")
        }
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice("iPhone 12 Pro")
    }
}
