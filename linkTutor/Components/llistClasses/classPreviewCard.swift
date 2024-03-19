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
                        Image(systemName: "person.crop.square")
                            .resizable()
                            .clipped()
                            .frame(width: 85, height: 85)
                            .cornerRadius(50)
                            .padding(.trailing, 5)
                    }
                    .frame(width: 90, height: 90)
                } else {
                    Image(systemName: "person.crop.square")
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
                            .padding([.top, .bottom], 4)
                            .padding([.leading, .trailing], 8)
                            .background(Color.white)
                            .cornerRadius(50)
                            .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 12)
                        Text("40 reviews")
                            .foregroundColor(.gray)
                    }
                }
                
                Spacer()
            }
            
            HStack {
                Image(systemName: "phone.fill")
                    .font(.system(size: 20))
                Text("\(phoneNumber)")
                    .font(.subheadline)
                    .padding([.top, .bottom], 4)
                    .padding([.leading, .trailing], 12)
                    .background(Color.blue)
                    .cornerRadius(50)
                
                Spacer()
                Text("\(price)")
                    .font(.subheadline)
            }
        }
        .padding()
        .foregroundColor(Color.black)
        .background(Color.accentColor)
        .cornerRadius(20)
        .onAppear {
            Task {
                await teacherViewModel.fetchTeacherDetailsByID(teacherID: teacherUid)
            }
        }
    }
}




#Preview {
    classPreviewCard(academy: "unknown's Acadmey", className: "Unknown", phoneNumber: 123456789, price: 2000, teacherUid: "https://firebasestorage.googleapis.com:443/v0/b/linktutor-22f14.appspot.com/o/students%2F5OYog91j2HYFjY3va5vQ356fJ9W2.jpg?alt=media&token=a42b28c3-8d89-4a08-a975-649787509045")
}
