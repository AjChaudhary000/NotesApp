//
//  NewNoteVc.swift
//  Notesapp
//
//  Created by DCS on 07/07/21.
//  Copyright © 2021 DCS. All rights reserved.
//

import UIKit

class NewNoteVc: UIViewController {
  var UpdateFile = ""
    private let myview : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 30
        return view
    }()
    private let label1:UILabel = {
        let lb = UILabel()
        lb.text = "Notes !"
        lb.textColor = .white
        lb.font = UIFont.boldSystemFont(ofSize: 35)
        return lb
    }()
    
    private let label2:UILabel = {
        let lb = UILabel()
        lb.text = "File Name "
        lb.textColor = .black
        lb.font = UIFont.boldSystemFont(ofSize: 15)
        return lb
    }()
    private let txt:UITextField = {
        let txt = UITextField()
        txt.layer.cornerRadius = 10
        txt.layer.borderWidth = 2
        txt.layer.borderColor = UIColor.orange.cgColor
        txt.placeholder = " File Names.."
        txt.textAlignment = .center
        return txt
    }()
    private let label3:UILabel = {
        let lb = UILabel()
        lb.text = "File Contents "
        lb.textColor = .black
        lb.font = UIFont.boldSystemFont(ofSize: 20)
        return lb
    }()
    private let txt1:UITextField = {
        let txt = UITextField()
        txt.layer.cornerRadius = 10
        txt.layer.borderWidth = 2
        txt.layer.borderColor = UIColor.orange.cgColor
        txt.placeholder = "Enter The Contents"
       
        txt.textAlignment = .center
        return txt
    }()
    private let btn:UIButton = {
        let btn = UIButton()
        btn.setTitle("Add Notes", for: .normal)
        btn.backgroundColor = UIColor.orange
        btn.layer.cornerRadius = 20
        btn.addTarget(self, action: #selector(AddNotes), for: .touchUpInside)
        return btn
    }()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.orange
        UIView.animate(withDuration: 0.9){
            self.view.addSubview(self.myview)
            self.view.addSubview(self.label1)
            
            self.view.addSubview(self.label2)
            self.view.addSubview(self.txt)
            self.view.addSubview(self.label3)
            self.view.addSubview(self.txt1)
            self.view.addSubview(self.btn)
           
            
            if  self.UpdateFile != "" {
                self.label1.text = "Upadte Notes !"
                self.txt.text = self.UpdateFile.components(separatedBy: ".").first
                self.txt.isEnabled = false
                let filepath = NoteService.getDocDir().appendingPathComponent(self.UpdateFile)
                do{
                            let content =  try String(contentsOf: filepath)
                    self.txt1.text = content
                }catch{
                    
                }
                self.btn.setTitle("Update Notes", for: .normal)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        myview.frame = CGRect(x: 0, y: view.height / 3, width: view.width, height: view.height / 2 + 200)
        label1.frame = CGRect(x: 20, y: 100, width: 300, height: 40)
        label2.frame = CGRect(x: 20, y: view.height / 3 + 20, width: 100, height: 40)
        txt.frame = CGRect(x: label2.right + 20, y: view.height / 3 + 20, width: 150, height: 45)
        label3.frame = CGRect(x: 20, y: txt.bottom + 10, width: view.width, height: 40)
        txt1.frame = CGRect(x: 20, y: label3.bottom + 5 , width: view.width - 40, height: 200)
        btn.frame = CGRect(x: 20, y: txt1.bottom + 30, width: view.width - 40 , height: 45)
       
        
    }
    
    
    @objc func AddNotes(){
        
                let filename = txt.text!
        let contents = txt1.text!
        let filepath = NoteService.getDocDir().appendingPathComponent("\(filename).txt")
        do{
            try contents.write(to: filepath, atomically: true, encoding: .utf8)
            if UpdateFile != "" {
                let alert = UIAlertController(title: "Success ! ", message: "File Updated Successfully ..", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: { [weak self] _ in
                    self?.navigationController?.popViewController(animated: true)
                }))
                DispatchQueue.main.async {
                    self.present(alert,animated: true,completion: nil)
                }
            }else{
                let alert = UIAlertController(title: "Success ! ", message: "File Add Successfully ..", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: { [weak self] _ in
                    self?.navigationController?.popViewController(animated: true)
                }))
                DispatchQueue.main.async {
                    self.present(alert,animated: true,completion: nil)
                }
            }
            
        }
        catch{
            print(error)
        }
    }


}
