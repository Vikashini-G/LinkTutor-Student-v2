//
//  SearchView.swift
//  linkTutor
//
//  Created by Aditya Pandey on 19/03/24.
//

import SwiftUI

struct SearchView: View {
    @State var searchText = ""
    @ObservedObject var viewModel = SkillViewModel()
    @State private var selectedSkillType: SkillType?
    
    var body: some View {
        VStack {
            TextField("Search", text: $searchText)
                .padding(.horizontal)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            List {
                ForEach(viewModel.skillTypes) { skillType in
                    VStack(alignment: .leading) {
                 
                        ForEach(skillType.skillOwnerDetails.filter{(self.searchText.isEmpty ? true : $0.className.localizedCaseInsensitiveContains(self.searchText))}  , id: \.id) { detail in
                            VStack(alignment: .leading) {
                                // Only print the class name
                                NavigationLink(destination: classLandingPage(teacherUid: detail.teacherUid,
                                                                              academy: detail.academy,
                                                                              skillUid: detail.skillUid,
                                                                              skillOwnerUid: detail.id,
                                                                             className: detail.className,
                                                                             startTime: detail.startTime,
                                                                             endTime: detail.endTime, week: detail.week)) {
                                
                                
                                Text("Class Name: \(detail.className)")
                                    .padding()
                            }
                                    
                                    
                                }
                                
                            }
                        
                        
                    }
                    .padding()
                    .onAppear() {
                        viewModel.fetchSkillOwnerDetails(for: skillType)
                    }
                }
            }
            .onAppear(){
                viewModel.fetchSkillTypes()
            }
        }
    }
}


struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}

