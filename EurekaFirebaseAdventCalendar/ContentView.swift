//
//  ContentView.swift
//  EurekaFirebaseAdventCalendar
//
//  Created by Antoine Marandon on 20/11/2019.
//  Copyright © 2019 Antoine Marandon. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var caption: Caption
    var body: some View {
        VStack {
            TextField("Change caption", text: $caption.text)
                .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(Caption())
    }
}

