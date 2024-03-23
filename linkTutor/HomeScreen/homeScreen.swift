import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct homeScreen: View{
    @StateObject var viewModel = listClassesScreenModel()
    @EnvironmentObject var dataModel : AuthViewModel
    @ObservedObject var studentViewModel = StudentViewModel.shared
    
    @ObservedObject var skillViewModel = SkillViewModel()
    @State private var selectedSkillType: SkillType?
   
    
    var body: some View{
       
        NavigationStack{
            VStack{
                VStack{
                    if let fullName = studentViewModel.userDetails.first?.fullName {
                        let nameComponents = fullName.components(separatedBy: " ")
                        let firstName = nameComponents.first ?? ""
                        header(yourName: firstName)
                            .padding(.bottom)
                    
                    }
                    else {
                        header(yourName: "there")
                            .padding(.bottom)
                    }
                       
                    NavigationLink(destination: SearchView()){
                        HStack{
                            Image(systemName: "magnifyingglass")
                                .foregroundStyle(Color.myGray)
                            Text("Skills, tutors, centers...")
                            
                            Spacer()
                        }
                        .foregroundStyle(Color.myGray).opacity(0.6)
                        .padding(3)
                        .padding(.leading, 10)
                        .frame(width: 370, height: 35)
                        .background(.ultraThinMaterial)
                        .cornerRadius(8)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 15)
                .onAppear {
                  
                    Task {
                        let userId = Auth.auth().currentUser?.uid
                        await studentViewModel.fetchStudentDetailsByID(studentID: userId ?? "")
                    }
                }
                
                ScrollView(.vertical, showsIndicators: false){
                    VStack{
                        //Enrolled classes section
                        SectionHeader(sectionName: "Enrolled Classes", fileLocation: enrolledSubjectList())
                            .onTapGesture {
                                viewModel.enrolledClassFramework = enrolledClassVList(classdata: enrolledClassMockData.sampleClassData)
                            }
                            .padding(.horizontal)
                        
                        //enrolled classes cards
                        enrolledClassList(classdata: enrolledClassMockData.sampleClassData)
                        
                        
                        //Explore skills section
                        HStack {
                            Text("Explore Skills!")
                                .font(AppFont.mediumSemiBold)
                            Spacer()
                        }
                        .padding(.top, 30)
                        .padding(.bottom, 15)
                        .padding(.horizontal)
                        
                        
                        //explore classes cards
                        allPopularCard()
                        
                        Spacer().frame(height: 150)
                        
                        HStack{
                            Spacer()
                            Text("Here's to unlocking your full potential!")
                                .font(AppFont.actionButton)
                                .foregroundStyle(Color.gray)
                            Spacer()
                        }
                        
                        Spacer().frame(height: 30)
                    }
                }
                    .edgesIgnoringSafeArea(.bottom)
            }
            .background(Color.background)
            .environment(\.colorScheme, .dark)
        }
    }
        
}
    


#Preview {
    homeScreen()
}


