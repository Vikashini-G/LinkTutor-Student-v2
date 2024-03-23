//
//  myProfileView.swift
//  linkTutor
//
//  Created by Vikashini G on 31/01/24.
//

import SwiftUI
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

struct myProfileView: View {
    @EnvironmentObject var viewModel : AuthViewModel
    @State var showEditView = false
    @ObservedObject var studentViewModel = StudentViewModel.shared
    @State private var showAlert = false
    
    
    var body: some View {
        NavigationStack{
            VStack(alignment: .leading){
                HStack{
                    Text("My Profile")
                        .font(AppFont.largeBold)
                    Spacer()
                }
                
                
                
                HStack{
                    if let imageUrl = studentViewModel.userDetails.first?.imageUrl {
                        AsyncImage(url: URL(string: imageUrl)) { image in
                            image
                                .resizable()
                                .clipped()
                                .frame(width: 85, height: 85)
                                .cornerRadius(50)
                                .padding(.trailing, 5)
                        } placeholder: {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .clipped()
                                .frame(width: 70, height: 70)
                                .cornerRadius(50)
                                .padding(.trailing, 5)
                        }
                        .frame(width: 90, height: 90)
                    } else {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .clipped()
                            .frame(width: 70, height: 70)
                            .cornerRadius(50)
                            .padding(.trailing, 5)
                    }
                    
                    if let user = viewModel.currentUser {
                        VStack(alignment: .leading){
                            Text(user.fullName)
                                .font(AppFont.mediumSemiBold)
                                .foregroundStyle(Color.black)
                            Text(user.email)
                                .font(AppFont.actionButton)
                                .foregroundStyle(Color.black).opacity(0.7)
                        }
                        .padding(.trailing)
                    }
                    Spacer()
                    VStack{
                        Button(action: {
                            showEditView.toggle()
                        }) {
//                            Image(systemName: "pencil")
                            Text("Edit")
                                .foregroundColor(.blue)
                                .font(AppFont.actionButton)
                        }
                        .fullScreenCover(isPresented: $showEditView) {
                            ProfileInputView()
                        }
//                        NavigationLink(destination: ProfileInputView()){
//                            Image(systemName: "pencil")
//                                .foregroundColor(.black)
//                        }
                        Spacer()
                    }
                }
                .padding()
                .frame(width: 350, height: 100)
                .background(Color.accent)
                .cornerRadius(20)
                
                
                List{
                    HStack{
                        Text("Change password")
                        NavigationLink(destination : newPassword()){}
                            .opacity(0.0)
                        Spacer()
                        Image(systemName: "arrow.right")
                            .foregroundColor(.accent)
                    }
                    .listRowBackground(Color.clear)
                    HStack{
                        Text("Delete my account")
                        Spacer()
                        Button{
                            showAlert = true
                        } label: {
                            Image(systemName: "arrow.right")
                                .foregroundColor(.accent)
                        }
                    }
                    .alert(isPresented: $showAlert) {
                                // Alert asking for confirmation
                                Alert(
                                    title: Text("Delete Account"),
                                    message: Text("Are you sure you want to delete your account?"),
                                    primaryButton: .destructive(Text("Delete")) {
                                        viewModel.deleteAccount()
                                        print("Account deleted")
                                    },
                                    secondaryButton: .cancel(Text("Cancel"))
                                )
                            }
                    .listRowBackground(Color.clear)
                   
                }
                .listStyle(PlainListStyle())
                .padding(.top)
                .frame(maxWidth: .infinity, maxHeight: 200,  alignment: .center)
                
                Spacer()
                HStack{
                    Spacer()
                    Button {
                        viewModel.signOut()
                    } label: {
                        Text("Logout")
                            .font(AppFont.mediumSemiBold)
                            .foregroundStyle(Color.text)
                            .frame(width: 200, height: 35)
                            .padding()
                            .background(Color.elavated)
                            .cornerRadius(50)
                    }
                    
                    Spacer()
                }
                //.frame(maxWidth: .infinity, alignment: .center)
                
                Spacer()
            }
            .padding()
            .background(Color.background)
        }
        .onAppear {
          
            Task {
                let userId = Auth.auth().currentUser?.uid
                await studentViewModel.fetchStudentDetailsByID(studentID: userId!)
            }
        }
    }
}

#Preview {
    let viewModel = AuthViewModel()
          viewModel.currentUser = User(id: "mockUserID", fullName: "John Doe", email: "john@example.com")
          
          return myProfileView()
              .environmentObject(viewModel)
}


