import SwiftUI

struct listClassesScreen: View{
  
  //  @State private var selectedSortOption: SortOption = .lowToHigh

   
    
    let skillType: SkillType
  //  var skillId : SkillType.ID
    @ObservedObject var viewModel = SkillViewModel()
    @State private var isAscendingOrder = true
    @State private var showActionSheet = false
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
                    VStack(alignment: .leading) {
                        HStack{
                            Spacer()
                            Button(action: {
                                showActionSheet.toggle()
                            }) {
                                HStack{
                                    Text("Filter")
                                    Image(systemName: "line.3.horizontal.decrease")
                                        .font(.system(size: 20))
                                }
                            }
                            .font(AppFont.actionButton)
                            .frame(minWidth: 90, minHeight: 30)
                            .foregroundColor(.accent)
                            .background(Color.elavated)
                            .cornerRadius(8)
                            .actionSheet(isPresented: $showActionSheet) {
                                ActionSheet(
                                    title: Text("Filter Options"),
                                    buttons: [
                                        .default(Text("Low to High Price")) {
                                            isAscendingOrder = true
                                        },
                                        .default(Text("High to Low Price")) {
                                            isAscendingOrder = false
                                        },
                                        .cancel(),
                                    ]
                                )
                            }
                        }
                        if let skillTypeIndex = viewModel.skillTypes.firstIndex(where: { $0.id == skillType.id }) {
                            let skillTypeDetails = viewModel.skillTypes[skillTypeIndex] 
                            
                            ForEach(skillTypeDetails.skillOwnerDetails) { detail in
                                VStack(alignment: .leading, spacing: 10) {
                                    
                              
                                    
                                    NavigationLink(destination: classLandingPage(teacherUid: detail.teacherUid, academy: detail.academy , skillUid: detail.skillUid , skillOwnerUid: detail.id, className: detail.className, startTime: detail.startTime, endTime: detail.endTime, week: detail.week)) {
                                        
                                        classPreviewCard(academy: detail.academy, className: detail.className, phoneNumber: 1234567890, price: Int(detail.price) , teacherUid : detail.teacherUid)
                                        
                                    }
//                                    .padding()
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




