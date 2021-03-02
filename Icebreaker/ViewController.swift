//
//  ViewController.swift
//  Icebreaker
//
//  Created by Mihir Khetale on 3/2/21.
//

import UIKit
import FirebaseFirestore

class ViewController: UIViewController {
    let db = Firestore.firestore()
    var questions = [Question]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db.collection("questions")
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        if let question = Question(id: document.documentID, data: document.data()) {
                            print("Retrieved question: id = \(question.id), text = \(question.text)")
                            self.questions.append(question)
                        }
                    }
                }
            }
        // Do any additional setup after loading the view.
    }
    
    //MARK:- Properties
    @IBOutlet weak var FirstName: UITextField!
    @IBOutlet weak var LastName: UITextField!
    @IBOutlet weak var PreferredName: UITextField!
    @IBOutlet weak var Answer: UITextField!
    
    @IBOutlet weak var LabelQuestion: UILabel!
    
    //MARK:- Actions
    @IBAction func BtnQuestion(_ sender: Any) {
        LabelQuestion.text = questions.randomElement()?.text
    }
    @IBAction func BtnSubmit(_ sender: Any) {
        let data = ["first_name": FirstName.text!,
                    "last_name": LastName.text!,
                    "preferred_name": PreferredName.text!,
                    "question": LabelQuestion.text!,
                    "answer": Answer.text!,
                    "class": "ios-spring21"]
            as [String: Any]
        
        var ref: DocumentReference? = nil
        ref = db.collection("students").addDocument(data: data) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
            
        }
        
        FirstName.text = ""
        LastName.text = ""
        PreferredName.text = ""
        Answer.text = ""
        LabelQuestion.text = ""
    }
    
}

