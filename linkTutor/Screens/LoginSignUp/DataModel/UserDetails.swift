import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine

struct UserData: Identifiable, Codable, Equatable {
    var id: String
    var aboutParagraph: String
    var city: String
    var email: String
    var documentUid: String
    var fullName: String
    var location: GeoPoint // Assuming location is of type GeoPoint
    var occupation: String
    var phoneNumber: Int
    var imageUrl: String
}

class StudentViewModel: ObservableObject {
    @Published var userDetails = [UserData]()
    private let db = Firestore.firestore()
    static let shared = StudentViewModel()
    
    func fetchStudentDetails() async {
        do {
            let snapshot = try await db.collection("users").getDocuments()
            
            DispatchQueue.main.async {
                var details: [UserData] = []
                for document in snapshot.documents {
                    let data = document.data()
                    let id = document.documentID
                    let aboutParagraph = data["aboutParagraph"] as? String ?? ""
                    let city = data["city"] as? String ?? ""
                    let email = data["email"] as? String ?? ""
                    let documentUid = data["id"] as? String ?? ""
                    let fullName = data["fullName"] as? String ?? ""
                    let location = data["location"] as? GeoPoint ?? GeoPoint(latitude: 0.0, longitude: 0.0)
                    let occupation = data["occupation"] as? String ?? ""
                    let phoneNumber = data["phoneNumber"] as? Int ?? 0
                    let imageUrl = data["imageUrl"] as? String ?? ""
                    
                    let userDetail = UserData(id: id,
                                              aboutParagraph: aboutParagraph,
                                              city: city,
                                              email: email,
                                              documentUid: documentUid,
                                              fullName: fullName,
                                              location: location,
                                              occupation: occupation,
                                              phoneNumber: phoneNumber,
                                              imageUrl: imageUrl)
                    details.append(userDetail)
                }
                self.userDetails = details
            }
        } catch {
            print("Error fetching teacher details: \(error.localizedDescription)")
        }
    }
    
    func fetchStudentDetailsByID(studentID: String) async {
        do {
            let document = try await db.collection("users").document(studentID).getDocument()
            
            // Check if the document exists
            if document.exists {
                if let data = document.data() {
                    let userDetail = UserData(
                        id: document.documentID,
                        aboutParagraph: data["aboutParagraph"] as? String ?? "",
                        city: data["city"] as? String ?? "",
                        email: data["email"] as? String ?? "",
                        documentUid: data["id"] as? String ?? "",
                        fullName: data["fullName"] as? String ?? "",
                        location: data["location"] as? GeoPoint ?? GeoPoint(latitude: 0, longitude: 0),
                        occupation: data["occupation"] as? String ?? "",
                        phoneNumber: data["phoneNumber"] as? Int ?? 0,
                        imageUrl: data["imageUrl"] as? String ?? ""
                    )
                    
                    DispatchQueue.main.async {
                        self.userDetails = [userDetail]
                    }
                }
            } else {
                print("Student document does not exist")
            }
        } catch {
            print("Error fetching student details: \(error.localizedDescription)")
        }
    }
    
    func loadImage(from urlString: String) async throws -> UIImage {
        guard let url = URL(string: urlString) else {
            throw NSError(domain: "InvalidURL", code: 0, userInfo: nil)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        guard let image = UIImage(data: data) else {
            throw NSError(domain: "InvalidImageData", code: 0, userInfo: nil)
        }
        
        return image
    }
}

struct UserDetails: View {
    @ObservedObject var studentViewModel = StudentViewModel.shared

    var body: some View {
        NavigationView {
            ScrollView {
                ForEach(studentViewModel.userDetails) { studentDetail in
                    VStack(alignment: .leading) {
                        Text("ID: \(studentDetail.id)")
                        Text("Full Name: \(studentDetail.fullName)")
                        Text("Email: \(studentDetail.email)")
                        Text("City: \(studentDetail.city)")
                        Text("About: \(studentDetail.aboutParagraph)")
                        Text("Occupation: \(studentDetail.occupation)")
                        Text("Phone Number: \(studentDetail.phoneNumber)")
                        Text("Location: Latitude: \(studentDetail.location.latitude), Longitude: \(studentDetail.location.longitude)")
                        Text("Image Link: \(studentDetail.imageUrl)")
                        
                        // Async image loading
                        AsyncImage(url: URL(string: studentDetail.imageUrl)) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 200, height: 200)
                    }
                    .padding()
                }
            }
            .navigationBarTitle("Student Details")
            .onAppear {
                Task {
                    await studentViewModel.fetchStudentDetails()
                }
            }
        }
    }
}

#Preview {
    UserDetails()
}
