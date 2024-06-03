//
//  ViewController.swift
//  Assignment_3
//
//  Created by E5000861 on 02/06/24.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var jsonDataLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .black
        label.backgroundColor = .gray
        label.text = "JSON Data will be displayed here"
        return label
    }()
    
    lazy var parsedDataLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = "Parsed Data will be displayed here"
        label.textColor = .black
        label.backgroundColor = .gray
        return label
    }()
    
    struct MyData: Codable {
        let name: String
        let age: Int
    }
    
    var jsonData: Data? {
        didSet {
            print("JSON data updated")
            updateJsonLabel()
        }
    }
    
    var parsedData: MyData? {
        didSet {
            print("Parsed data updated")
            updateParsedLabel()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(jsonDataLabel)
        NSLayoutConstraint.activate([
            jsonDataLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            jsonDataLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100),
            jsonDataLabel.widthAnchor.constraint(equalToConstant: 300)
        ])
        
        view.addSubview(parsedDataLabel)
        NSLayoutConstraint.activate([
            parsedDataLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            parsedDataLabel.topAnchor.constraint(equalTo: jsonDataLabel.bottomAnchor, constant: 20),
            parsedDataLabel.widthAnchor.constraint(equalToConstant: 300)
        ])
        
        let parseButton = UIButton(type: .system)
        parseButton.setTitle("Parse Data", for: .normal)
        parseButton.addTarget(self, action: #selector(parseData), for: .touchUpInside)
        parseButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(parseButton)
        
        NSLayoutConstraint.activate([
            parseButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            parseButton.topAnchor.constraint(equalTo: parsedDataLabel.bottomAnchor, constant: 20)
        ])
        
        // Simulate loading of JSON data
        let jsonString = """
        {
            "name": "John",
            "age": 30
        }
        """
        jsonData = jsonString.data(using: .utf8)
    }
    
    func updateJsonLabel() {
        if let jsonData = self.jsonData,
           let jsonString = String(data: jsonData, encoding: .utf8) {
            jsonDataLabel.text = jsonString
        }
    }
    
    func updateParsedLabel() {
        if let parsedData = self.parsedData {
            parsedDataLabel.text = "Name: \(parsedData.name)\nAge: \(parsedData.age)"
        }
    }
    
    @objc func parseData() {
        guard let jsonData = jsonData else {
            print("No JSON data to parse")
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let myData = try decoder.decode(MyData.self, from: jsonData)
            parsedData = myData
        } catch {
            print("Error parsing JSON data: \(error)")
        }
    }
}
