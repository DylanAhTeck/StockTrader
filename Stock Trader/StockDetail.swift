//
//  StockDetail.swift
//  Stock Trader
//
//  Created by Dylan Ah Teck on 11/28/20.
//

import SwiftUI

struct StockDetail: View {
    var stock: Stock;
   // let stock = Stock(ticker: "MSFT", shares: 10.00, price: 111.20, change: -5.40)
    let rows = [
        GridItem(.flexible(), alignment:.leading),
        GridItem(.flexible(), alignment:.leading),
        GridItem(.flexible(), alignment:.leading)
       ]
    
    @State var moreText = false
    
    let statKeys = ["last", "Open Price", "High", "Low", "Mid", "Volume", "Bid Price"]
    
    
    let data = ["last": 12, "Open Price": 4, "High": 2, "Low": 34.2, "Mid": 32.2,
                "Volume": 12,"Bid Price": 12]
    
    var body: some View {
        
        
        VStack{
             HStack{
                Text(stock.name).font(.subheadline).foregroundColor(.secondary)
                Spacer()
            }
            HStack(alignment: .firstTextBaseline){
                Text("$\(String(format: "%.2f", stock.price))").bold().font(.largeTitle)
                Text("$(\(String(format: "%.2f", stock.change)))").font(.title2).foregroundColor(.green)
                Spacer()
            }
            Spacer()
            Section{
                VStack(alignment: .leading){
                    Text("Portfolio").font(.title2).padding(.bottom, 5)
                    HStack
                    {
                        VStack(alignment: .leading){
                            Text("Shares Owned: 5.000").padding(1)
                            Text("Market Value: $1013.40").padding(1)
                        }
                       Spacer()
                        Button("Trade"){}
                            .padding()
                            .frame(minWidth: 0, maxWidth:150)
                            .background(Color.green)
                            .foregroundColor(Color.white)
                            .cornerRadius(40)
                    }.padding(.trailing)
                }
            }
            Section{
                VStack(alignment: .leading){
                    HStack(){
                        Text("Stats").font(.title2).padding(.bottom, 5)
                        Spacer()
                    }
                    ScrollView(.horizontal) {
                        LazyHGrid(rows: rows, alignment:.top) {
                            ForEach(statKeys, id: \.self){
                                statKey in
                                
                                let key = statKey != "last" ? statKey : "Current Price"
                                let value = String(format: "%.2f", data[statKey, default: 0.0])
                                Text("\(key): \(value)")
                            }
                        }
                    }
                }
            }
            
            //About
            Section{
                VStack(alignment: .leading){
                    HStack(){
                        Text("About").font(.title2).padding(.bottom, 5)
                        Spacer()
                    }
                    HStack(){
                        Text("Amazon is guided by four principles: customer obsession rather than competitior focus, passion for invention, commitment to customers, etc.").lineLimit(moreText ? nil : 2)
                        Spacer()
                    }
                    HStack(){
                        Spacer()
                        Button(action: {
                            self.moreText.toggle()
                        }){Text(self.moreText ? "Show less" : "Show more..." ).font(.subheadline).foregroundColor(.secondary)}.padding(.trailing).padding(.top, 1)
                    }
                }
            }
            
            //News
            Section {
                
            }
        }.navigationTitle(stock.ticker).padding(.leading)
     
        
    }
}

struct StockDetail_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            StockDetail(stock: Stock(ticker: "MSFT", name: "Microsoft Corporation", shares: 10.00, price: 111.20, change: -5.40))
        }
    }
}
