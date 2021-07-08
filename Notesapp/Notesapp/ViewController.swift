//
//  ViewController.swift
//  Notesapp
//
//  Created by DCS on 07/07/21.
//  Copyright © 2021 DCS. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    private var noteState = [Int]()
    private var noteArray = [String]()
    private let tableview = UITableView()
    private func FetchNotesData(){
        
        let path = NoteService.getDocDir()
        do{
            let notes = try FileManager.default.contentsOfDirectory(at: path, includingPropertiesForKeys: nil)
            noteArray.removeAll()
            for item in notes{
            
                noteArray.append(item.lastPathComponent)
            }
        }catch{
            print(error)
        }
        tableview.reloadData()
    }
    private let btn1:UIButton = {
        let btn = UIButton()
        btn.setTitle("+", for: .normal)
        btn.setTitleColor(UIColor.black, for: .normal)
        btn.layer.cornerRadius = 30
        btn.layer.borderWidth = 2
        btn.addTarget(self, action: #selector(addNotes), for: .touchUpInside)
         btn.backgroundColor = UIColor.orange
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        title = "NotesApp"
        let additem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(logout))
        navigationItem.setRightBarButton(additem, animated: true)
        view.addSubview(tableview)
        setuptable()
        view.addSubview(btn1)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableview.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.width,  height: view.height - view.safeAreaInsets.top - view.safeAreaInsets.bottom)
        btn1.frame = CGRect(x: view.width / 2 - 30  , y: view.height - 80, width: 60 , height:60)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         checkAuth()
        FetchNotesData()
        tableview.reloadData()
    }
    @objc func logout(){
        UserDefaults.standard.setValue(nil, forKey: "LoginTokenKey")
        UserDefaults.standard.setValue(nil, forKey: "UserName")
       checkAuth()
    }
    @objc func addNotes(){
        let vc = NewNoteVc()
        navigationController?.pushViewController(vc, animated: true)
    }
    @objc func checkAuth(){
        if let token = UserDefaults.standard.string(forKey: "LoginTokenKey"),
            let name  = UserDefaults.standard.string(forKey: "UserName"){
            print("\(token) ,name :- \(name)")
        }else{
            let vc = LoginVC ()
            let nv = UINavigationController(rootViewController: vc)
            nv.modalPresentationStyle = .fullScreen
            nv.setNavigationBarHidden(true, animated: false)
            present(nv,animated: false)
        }
    }
}

extension ViewController :UITableViewDelegate,UITableViewDataSource {
    private func setuptable(){
        tableview.delegate = self
        tableview.dataSource = self
        tableview.register(noteTableVc.self, forCellReuseIdentifier: "notes")
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return noteArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "notes", for: indexPath) as! noteTableVc
        cell.setupTodoCellWith(title: noteArray[indexPath.row], index: indexPath.row,and: (noteState.contains(indexPath.row) ? true : false))
        
        cell.mybtn.addTarget(self, action: #selector(editpage), for:.touchUpInside)
        cell.mybtn1.addTarget(self, action: #selector(deletepage), for:.touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    @objc private func editpage (_ sender : UIButton){
        let vc = NewNoteVc()
        let filename = noteArray[sender.tag]
        vc.UpdateFile = filename
        navigationController?.pushViewController(vc, animated: true)
    }
    @objc private func deletepage (_ sender : UIButton){
         let filename = noteArray[sender.tag]
        let filepath = NoteService.getDocDir()
    let path = URL(string: filename, relativeTo: filepath)
        do {
            try  FileManager.default.removeItem(at: path!)
            let alert = UIAlertController(title: "Success ! ", message: "File Delete Successfully ..", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ok", style: .cancel, handler: { [weak self] _ in
                self?.navigationController?.popToRootViewController(animated: true)
            }))
            DispatchQueue.main.async {
                self.present(alert,animated: true,completion: nil)
            }
        }catch{
            print(error)
        }
      tableview.reloadData()
    }

}



