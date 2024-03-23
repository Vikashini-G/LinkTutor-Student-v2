import SwiftUI

struct classPreviewCard: View {
    var academy: String
    var className: String
    var phoneNumber: Int
    var price: Int
    var teacherUid: String
    
    @ObservedObject var teacherViewModel = TeacherViewModel.shared
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                if let imageUrl = teacherViewModel.teacherDetails.first?.imageUrl {
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
                            .frame(width: 85, height: 85)
                            .cornerRadius(50)
                            .padding(.trailing, 5)
                    }
                    .frame(width: 90, height: 90)
                } else {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .clipped()
                        .frame(width: 85, height: 85)
                        .cornerRadius(50)
                        .padding(.trailing, 5)
                }
                
                VStack(alignment: .leading) {
                    Text("\(academy)")
                        .font(.headline)
                    Text("by \(className)")
                        .font(.subheadline)
                    
                    HStack {
                        Text("4.0 ⭐️")
//                            .padding([.top, .bottom], 4)
//                            .padding([.leading, .trailing], 8)
//                            .background(Color.white).opacity(0.5)
//                            .cornerRadius(50)
//                            .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 12)
                        Text("40 reviews")
                            .foregroundColor(.black).opacity(0.6)
                    }
                    Text("Rs. \(price) /month").font(AppFont.smallSemiBold)
//                        .padding([.top, .bottom], 1)
                }
                
                Spacer()
            }
            
            HStack{
                HStack{
                    Image(systemName: "phone.fill")
                        .font(.system(size: 20))
                    Text(String("\(phoneNumber)"))
                        .font(AppFont.actionButton)
                   
                }
                .padding([.top, .bottom], 4)
                .padding([.leading, .trailing], 12)
                .background(Color.phoneAccent)
                .cornerRadius(50)
                
                Spacer()
//                Text("\(price)")
            
            }
        }
        
        .frame(maxWidth: .infinity, maxHeight: 150)
        .padding()
        .foregroundColor(Color.black)
        .background(Color.accent)
        .cornerRadius(20)
        .onAppear {
            Task {
                await teacherViewModel.fetchTeacherDetailsByID(teacherID: teacherUid)
            }
        }
    }
}




#Preview {
    classPreviewCard(academy: "unknown's Acadmey", className: "Unknown", phoneNumber: 123456789, price: 2000, teacherUid: "1")
}
