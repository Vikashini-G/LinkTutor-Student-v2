import SwiftUI

struct listClassesScreen: View{
  
  //  @State private var selectedSortOption: SortOption = .lowToHigh

   
    
    let skillType: SkillType
  //  var skillId : SkillType.ID
    @ObservedObject var viewModel = SkillViewModel()
    @State private var isAscendingOrder = true
    
  // @Binding var isShowingDetailView : Bool
    
//    enum SortOption: String, Identifiable {
//        case lowToHigh = "Low to High"
//        case highToLow = "High to Low"
//        var id: String { self.rawValue }
//    }
    
    var body: some View {
        NavigationStack {
            ZStack{
 
                ScrollView {
                    VStack {
                        HStack {
                            Button(action: {
                                if isAscendingOrder {
                                    viewModel.sortDetailsAscending(for: skillType)
                                } else {
                                    viewModel.sortDetailsDescending(for: skillType)
                                }
                                isAscendingOrder.toggle()
                            }) {
                                Text("Sort by Price \(isAscendingOrder ? "Descending" : "Ascending")")
                                    .padding()
                                    .foregroundColor(.white)
                                    .background(Color.blue)
                                    .cornerRadius(8)
                            }
                        }
                        .padding()
                    }
                    VStack(alignment: .leading) {
                        if let skillTypeIndex = viewModel.skillTypes.firstIndex(where: { $0.id == skillType.id }) {
                            let skillTypeDetails = viewModel.skillTypes[skillTypeIndex] 
                            
                            ForEach(skillTypeDetails.skillOwnerDetails) { detail in
                                VStack(alignment: .leading) {
                                    
                              
                                    
                                    NavigationLink(destination: classLandingPage(teacherUid: detail.teacherUid, academy: detail.academy , skillUid: detail.skillUid , skillOwnerUid: detail.id, className: detail.className, startTime: detail.startTime, endTime: detail.endTime, week: detail.week)) {
                                        
                                        classPreviewCard(academy: detail.academy, className: detail.className, phoneNumber: 1234567890, price: Int(detail.price) , teacherUid : detail.teacherUid)
                                        
                                    }
                                    .padding()
                               }
                            }
                        } else {
                            Text("Loading...")
                        }
                        
                        
                    }
                    .padding()
                }
                .navigationTitle("Details")
                .onAppear {
                    viewModel.fetchSkillOwnerDetails(for: skillType)
                }
                    
                
            }
            .background(Color.background)
          
            
        }
        
    }
    
}


#Preview {
    listClassesScreen(skillType: SkillType(id: "1"))
}




