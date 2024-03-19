//
//  ReviewDetails.swift
//  linkTutor
//
//  Created by Aditya Pandey on 10/03/24.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine

struct reviewData : Identifiable, Codable ,  Equatable {
    var id: String
    var comment : String
    var documentUid: String
    var ratingStar : Int
    var teacherUid: String
    var time: Date
    var skillUid: String
    var userUid : String
    var skillOwnerDetailsUid : String
}

class ReviewViewModel: ObservableObject {
    @Published var reviewDetails = [reviewData]()
    private let db = Firestore.firestore()
    static let shared = ReviewViewModel()
    
    init() {
        // Initialize the view model asynchronously
        initialize()
    }
    
    func initialize() {
        Task {
            do {
                let snapshot = try await db.collection("review").getDocuments()
                DispatchQueue.main.async {
                    var details: [reviewData] = []
                    for document in snapshot.documents {
                        let data = document.data()
                        let id = document.documentID
                        let comment = data["comment"] as? String ?? ""
                        let documentUid = data["documentUid"] as? String ?? ""
                        let ratingStar = data["ratingStar"] as? Int ?? 0
                        let teacherUid = data["teacherUid"] as? String ?? ""
                        let time = data["time"] as? Date ?? Date()
                        let skillUid = data["skillUid"] as? String ?? ""
                        let userUid = data["userUid"] as? String ?? ""
                        let skillOwnerDetailsUid = data["skillOwnerDetailsUid"] as? String ?? ""
                        
                        let reviewDetail = reviewData(id: id,
                                                      comment: comment,
                                                      documentUid: documentUid,
                                                      ratingStar: ratingStar,
                                                      teacherUid: teacherUid,
                                                      time: time,
                                                      skillUid: skillUid,
                                                      userUid: userUid,
                                                      skillOwnerDetailsUid: skillOwnerDetailsUid)
                        details.append(reviewDetail)
                    }
                    self.reviewDetails = details
                }
            } catch {
                print("Error fetching review details: \(error.localizedDescription)")
            }
        }
    }
}

struct ReviewDetails: View {
    @ObservedObject var reviewViewModel = ReviewViewModel()
    @State private var isFetching = false // Track whether fetching is in progress

    var body: some View {
        NavigationView {
            ScrollView {
                ForEach(reviewViewModel.reviewDetails.filter { $0.teacherUid == "1" && $0.skillUid == "dance" &&  $0.skillOwnerDetailsUid == "1" }) { teacherDetail in
                    if let formattedDate = formatDate(teacherDetail.time) {
                        reviewCard(reviewRating: teacherDetail.ratingStar, review: "\(teacherDetail.comment)", time : "\(formattedDate)")
                    }
                }
            }
            .navigationBarTitle("Teacher Details")
        }
        .onAppear {
            // Fetch review details only if not already fetching
            if !isFetching {
                fetchReviewDetails()
            }
        }
    }
    
    func fetchReviewDetails() {
        Task {
            do {
                // Mark fetching as in progress
                isFetching = true
                await reviewViewModel.initialize()
            } catch {
                print("Error fetching review details: \(error.localizedDescription)")
                // Handle error here
            }
            // Mark fetching as completed
            isFetching = false
        }
    }
    
    func formatDate(_ date: Date) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM YYYY" // Date format: dayOfMonth month
        return dateFormatter.string(from: date)
    }
}





#Preview {
    ReviewDetails()
}



//ForEach(reviewViewModel.reviewDetails, id: \.id) { teacherDetail in
//                                    VStack(alignment: .leading) {
//                                        Text("ID: \(teacherDetail.id)")
//                                        Text("Comments: \(teacherDetail.comment)")
//                                        Text("Rating: \(teacherDetail.ratingStar)")
//                                        if let formattedDate = formatDate(teacherDetail.time) {
//                                            Text("Date: \(formattedDate)")
//                                        }
//                                        Text("Skill UID: \(teacherDetail.skillUid)")
//                                    }
//                                    .padding()
//                                }




// if skillUid == skillUid and teacherUid == teacherUid then print data else dont print

//    func fetchReviewDetailsByID(teacherID: String , skillUid: String) {
//        db.collection("Teachers").document(teacherID).getDocument { document, error in
//            if let error = error {
//                print("Error fetching teacher details: \(error.localizedDescription)")
//                return
//            }
//            guard let document = document, document.exists else {
//                print("Teacher document does not exist")
//                return
//            }
//            if let data = document.data(),
//               let teacherUid = data["teacherUid"] as? String,
//               let documentSkillUid = data["skillUid"] as? String,
//               teacherUid == teacherID && documentSkillUid == skillUid {
//                DispatchQueue.main.async {
//                    let reviewDetail = reviewData(
//                        id: document.documentID,
//                        comment: data["comment"] as? String ?? "",
//                        documentUid: data["documentUid"] as? String ?? "",
//                        ratingStar: data["ratingStar"] as? Int ?? 0,
//                        teacherUid: teacherUid,
//                        time: (data["time"] as? Timestamp)?.dateValue() ?? Date(),
//                        skillUid: documentSkillUid,
//                        userUid: data["userUid"] as? String ?? ""
//                    )
//                    // Append to reviewDetails array
//                    self.reviewDetails.append(reviewDetail)
//                }
//            }
//            else {
//                print("loading")
//            }
//
//        }
//    }
