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
                HStack{
                    Text("Request")
                        .font(AppFont.largeBold)
                    Spacer()
                }
                let userId = Auth.auth().currentUser?.uid
                
                VStack(spacing: 10) {
                    ForEach(viewModel.enrolledStudents.filter { $0.studentUid == userId && $0.requestAccepted == 0 }, id: \.id) { student in
                        RequestSentCard(teacherName: student.teacherName, phoneNumber: student.teacherNumber, id: student.id, className: student.className)
                    }
                    .onAppear() {
                        Task {
                            await AuthViewModel().fetchUser()
                        }
                    }
                }
//                .padding()
                .onAppear {
                    viewModel.fetchEnrolledStudents()
                }
                .refreshable {
                    await refreshData()
                }
                .overlay(refreshControl)
                
                Spacer()
            } //v end
            .padding()
            .background(Color.background)
        } //nav end
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
