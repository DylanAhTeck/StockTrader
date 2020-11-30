//
//  SearchBar.swift
//  Stock Trader
//
//  Created by Dylan Ah Teck on 11/28/20.
//

import SwiftUI
import Combine
import Alamofire
import SwiftyJSON

class SearchBar: NSObject, ObservableObject {
    let searchController: UISearchController = UISearchController(searchResultsController: nil)
    @Published var searchText: String = ""
    @Published var stocks: [Stock] = []
    
    var subscription: Set<AnyCancellable> = []
    
    private var cancellable: AnyCancellable? = nil

    override init(){
        super.init()
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.searchResultsUpdater = self
        $searchText
            .debounce(for: .seconds(1), scheduler: RunLoop.main)
            .removeDuplicates()
            .map({
                (string) -> String? in
                if string.count < 3 {
                    self.stocks = [];
                    return nil
                }
                
                return string
            })
            .compactMap{ $0 } // removes the nil values so the search string does not get passed down to the publisher chain
            .sink { (_) in
                //
            } receiveValue: { [self] (searchField) in
                search(ticker: searchField)
            }.store(in: &subscription)
    }
    
    private func search(ticker: String){
        AF.request("http://test-env.eba-ufqt4wd9.us-east-1.elasticbeanstalk.com/autocomplete/\(ticker)", method: .get, encoding: JSONEncoding.default)
            .responseJSON {
            (response) in
                switch response.result {
                case .success(let data):
                    let json = JSON(data)
                    if let stocksArray = json.to(type: Stock.self){
                        self.stocks = stocksArray as! [Stock]
                    }
                case .failure(let error):
                    print(error)
                }
        }
        
    }
}

extension SearchBar: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        // Publish search bar text changes.
        if let searchBarText = searchController.searchBar.text {
            print(searchBarText)
            self.searchText = searchBarText
        }
    }
}


public class Debouncer {
    private let delay: TimeInterval
    private var workItem: DispatchWorkItem?

    public init(delay: TimeInterval) {
        self.delay = delay
    }

    /// Trigger the action after some delay
    public func run(action: @escaping () -> Void) {
        workItem?.cancel()
        workItem = DispatchWorkItem(block: action)
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: workItem!)
    }
}

struct SearchBarModifier: ViewModifier {
    
    let searchBar: SearchBar
    
    func body(content: Content) -> some View {
        content
            .overlay(
                ViewControllerResolver { viewController in
                    viewController.navigationItem.searchController = self.searchBar.searchController
                }
                    .frame(width: 0, height: 0)
            )
    }
}

extension View {
    
    func add(_ searchBar: SearchBar) -> some View {
        return self.modifier(SearchBarModifier(searchBar: searchBar))
    }
}
