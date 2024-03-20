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
                
                VStack{
                    //Enrolled classes section
                    SectionHeader(sectionName: "Enrolled Classes", fileLocation: enrolledSubjectList())
                        .padding(.horizontal)
                        .onTapGesture {
                            viewModel.enrolledClassFramework = enrolledClassVList(classdata: enrolledClassMockData.sampleClassData)
                        }
                    
                    //enrolled classes cards
                    enrolledClassList(classdata: enrolledClassMockData.sampleClassData)
                    
                    
                    //Explore skills section
                    SectionHeader(sectionName: "Explore Skills!", fileLocation: allPopularCard())
                        .padding(.horizontal)
                        .onTapGesture {
                            viewModel.popularClassFramework = allPopularCard()
                        }
                       
                    
                    //explore classes cards
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack(spacing : 10){
                            ForEach(skillViewModel.skillTypes.prefix(3)) { skillType in
                                let skillTypeName: String = skillType.id
                                NavigationLink(destination: listClassesScreen(skillType: skillType)) {
                                    popularClassCardV(skillId: skillTypeName.prefix(1).capitalized + skillTypeName.dropFirst(), iconName: "book")
                                }
                            }

                            
                        }
                        
                        
                        Spacer()
                    }

                    .padding(.leading)

                    
                    
                    Spacer()
                    
                    
                }
            }
            .background(Color.background)
            .environment(\.colorScheme, .dark)
        }
    }
        
}
    


#Preview {
    homeScreen()
}


