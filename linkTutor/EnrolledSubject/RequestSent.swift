//
//  RequestSent.swift
//  linkTutor
//
//  Created by Aditya Pandey on 13/03/24.
//

//This code is working it is not showing anything because if the userId mathces then only it will show details as of now there is now details added in the database related to this id

import SwiftUI
import Firebase
import FirebaseAuth

struct RequestSent: View {
    @StateObject var viewModel = RequestListViewModel()
    @State private var isRefreshing = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Request")
                    .font(.title)
                    .padding()
                
                let userId = Auth.auth().currentUser?.uid
                
                List {
                    ForEach(viewModel.enrolledStudents.filter { $0.studentUid == userId && $0.requestSent == 1 }, id: \.id) { student in
                        enrolledSubjectCard(teacherName: student.teacherName, phoneNumber: student.teacherNumber, id: student.id, className: student.className)
                    }
                    .onAppear() {
                        Task {
                            await AuthViewModel().fetchUser()
                        }
                    }
                }
                .onAppear {
                    viewModel.fetchEnrolledStudents()
                }
                .refreshable {
                    await refreshData()
                }
                .overlay(refreshControl)
            }
        }
    }
    
    private func refreshData() async {
        isRefreshing = true
        // Perform your refresh logic here
        viewModel.fetchEnrolledStudents()
        isRefreshing = false
    }
    
    private var refreshControl: some View {
        GeometryReader { geometry in
            if isRefreshing {
                ProgressView()
                    .offset(y: -geometry.size.height / 2)
            }
        }
        .frame(height: 0)
    }
}


#Preview {
    RequestSent()
}
