//
//  AdviceView.swift
//  DissDemoV1
//
//  Created by Emily Kerkhof on 24/02/2023.
//

import SwiftUI

struct AdviceView: View {
    var body: some View {
        ZStack{
            Color.brown.ignoresSafeArea()
            VStack{
                Text("Advice Page").font(.title).bold()
            }
            
        }
        
    }
}

struct AdviceView_Previews: PreviewProvider {
    static var previews: some View {
        AdviceView()
    }
}
