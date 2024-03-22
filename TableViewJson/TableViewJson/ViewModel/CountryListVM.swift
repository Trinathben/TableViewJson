//
//  CountryListVM.swift
//  TableViewJson
//
//  Created by Trinath Vikkurthi on 3/21/24.
//

import Foundation

let urlString = "https://gist.githubusercontent.com/peymano-wmt/32dcb892b06648910ddd40406e37fdab/raw/db25946fd77c5873b0303b858e861ce724e0dcd0/countries.json"

class CountryListVM {
    var countries = [CountryListM]()
}

extension CountryListVM {
    
    func fetchCountries(onSuccess: @escaping([CountryListM])->Void) {
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            onSuccess([])
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil else {
                print("Error fetching data: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            do {
                let countries = try JSONDecoder().decode([CountryListM].self, from: data)
                DispatchQueue.main.async {
                    self.countries = countries
                    onSuccess(self.countries )
                    debugPrint(countries)
                }
            } catch {
                onSuccess([])
                print("Error decoding JSON: \(error.localizedDescription)")
            }
        }
        task.resume()
    }
}
