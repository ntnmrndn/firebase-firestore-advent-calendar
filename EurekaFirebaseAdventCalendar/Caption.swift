//
//  CaptionModel.swift
//  EurekaFirebaseAdventCalendar
//
//  Created by Antoine Marandon on 20/11/2019.
//  Copyright © 2019 Antoine Marandon. All rights reserved.
//

import SwiftUI
import FirebaseFirestore

final class Caption: ObservableObject  {
    private let document: DocumentReference
    private var observation: ListenerRegistration? = nil

    init() {

        let db = Firestore.firestore()
        self.document = db.collection("Caption").document("HardCodedSharedID")

        self.observation = self.document.addSnapshotListener({ [weak self] (snap, _) in
            // Warning: Ignoring errors is often a bad idea !
            guard let self = self, let text = snap?.data()?["text"] as? String  else { return }
            self.text = text
        })
    }

    @Published var text = "Hello World" {
        didSet {
            document.setData(["text" : text])
        }
    }
}
