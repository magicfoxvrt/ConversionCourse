//
//  ViewController.swift
//  CC
//
//  Created by Алексей on 12/2/20.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: - property
    
    var base = "RUB"
    var list = ["RUB","EUR","USD","HKD","ISK","PHP","DKK","HUF","CZK","GBP","RON","SEK","IDR","INR","BRL","HRK","JPY","THB","CHF","MYR","BGN","TRY","CNY"]
    
    var currencyCode: [String] = []
    var values: [Double] = []
    var activeCurrency = 0.0
    
    
    //MARK: - Outlet
    
    @IBOutlet weak var resultConvert: UILabel!
    @IBOutlet weak var priceLabel: UITextField!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var stranaLable: UILabel!
    @IBOutlet weak var dataLabel: UILabel!
    
    
    //MARK: - Drop
    @IBOutlet weak var btnDrop: UIButton!
    @IBOutlet weak var tblview: UITableView!
    @IBOutlet weak var dropResult: UILabel!
    
    //MARK: - View
    @IBOutlet weak var viewN1: UIView!
    @IBOutlet weak var viewN2: UIButton!
    @IBOutlet weak var viewN3: UIView!
    @IBOutlet weak var viewN4: UIView!
    @IBOutlet weak var viewN5: UIView!
    
    //MARK: - Start
    override func viewDidLoad() {
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        tblview.isHidden = true
        
        makeGetRequest()
        
        priceLabel.addTarget(self, action: #selector(updateViews), for: .editingChanged)
        
        
        viewN1.layerTest1()
        viewN2.layerTest2()
        viewN3.layerTest1()
        viewN4.layerTest1()
        viewN5.layerTest1()
    }
    
    
    //MARK: - URL
    func makeGetRequest() {
        guard let url = URL(string: "https://api.exchangeratesapi.io/latest?base=\(base)") else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if error != nil {
                print(error!)
            }
            guard let safeData = data else {return}
            
            
            do {
                let result = try JSONDecoder().decode(URLDate.self, from: safeData)
                print(result)
                DispatchQueue.main.async {
                    self.currencyCode = Array(result.rates.keys)
                    self.values =  Array(result.rates.values)
                    
                    self.pickerView.reloadAllComponents()
                    self.dataLabel.text = "Обновлено: \(result.date)"
                    print(result)
                    
                    self.updateViews(input: self.activeCurrency)
                }
            } catch {
                print(error)
                
            }
            
        }.resume()
    }
    
    
    //MARK: - Metod
    @objc func updateViews (input: Double){
        guard let amountText = priceLabel.text, let theAmountText = Double(amountText) else {return}
        if priceLabel.text != "" {
            let total = theAmountText * activeCurrency
            resultConvert.text = String(format: "%.2f", total)
        }
    }
    
    
    @IBAction func btnDropview(_ sender: Any) {
        if tblview.isHidden {
            animate(toogle: true)
        } else {
            animate(toogle: false)
        }
    }
    
    
    func animate(toogle: Bool) {
        if toogle {
            UIView.animate(withDuration: 0.3) {
                self.tblview.isHidden = false
            }
        } else {
            UIView.animate(withDuration: 0.3) {
                self.tblview.isHidden = true
            }
        }
    }
    
    
}


//MARK: - Extension

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyCode.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyCode[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        activeCurrency = values[row]
        updateViews(input: activeCurrency)
        stranaLable.text = currencyCode[row]
    }
}


extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = list[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        btnDrop.setTitle("\(fruitList[indexPath.row])", for: .normal)
        animate(toogle: false)
        dropResult.text = ("\(list[indexPath.row])")
        base = ("\(list[indexPath.row])")
        makeGetRequest()
        
    }
}


extension UIView{
    func layerTest1 (){
        self.layer.cornerRadius = 10.0
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.black.cgColor
        
        self.layer.shadowRadius = 10.0 // тень
        self.layer.shadowColor = UIColor.black.cgColor // цвет
        self.layer.shadowOffset = .zero // тень круг
        self.layer.shadowOpacity = 0.2 // тень от центра
    }
}


extension UIButton{
    func layerTest2 (){
        self.layer.cornerRadius = 10.0
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.black.cgColor
        
        self.layer.shadowRadius = 10.0
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = .zero
        self.layer.shadowOpacity = 0.2 
    }
}
