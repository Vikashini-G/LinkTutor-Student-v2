//
//  AuthViewModel.swift
//  linkTutor
//
//  Created by user2 on 03/03/24.
//


//It will be handling all the error associated with signIn
import Foundation
import FirebaseAuth
import FirebaseFirestoreSwift
import FirebaseFirestore
import FirebaseStorage


protocol AuthenticationFormProtocol {
    var FormIsValid: Bool { get }
}

@MainActor
class AuthViewModel: ObservableObject {
    
    // This is firebaseAuth user
    @Published var userSession : FirebaseAuth.User?
    
    
    // This is our user
    @Published var currentUser: User?
   
    
    init() {
    self.userSession = Auth.auth().currentUser
      
       
        Task {
            await fetchUser()
        }
    }
    
    
    func signIn(withEmail email: String , password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            await fetchUser()
        } catch {
            print("DEBUG: Failed to log in with error \(error.localizedDescription)")
        }
    }
    
    func createUser(withEmail email : String , password: String , fullName: String ) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            let user = User(id: result.user.uid , fullName: fullName, email: email)
            // here user store data which you can't store directly on the firebase you have to store in form of json like raw data format with key value pair
            let encodedUser = try Firestore.Encoder().encode(user)
            try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
            
            //This is how we got information uploaded to firebase
            //first we go to firestore.firestore then collection there we got user then we create document using user id then set all the data of the user
            await fetchUser()
            //we need to fetch user because the above code will upload data into firebase and it will take some time to upload
            //and it won't go to next line until that process is complete that is why we use await fetchUser()
        } catch {
            print("DEBUG: Failed to create user with error \(error.localizedDescription)")
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut() //signOUt user on backened
            self.userSession = nil   //wipes out user session and teakes us back to login screen
            self.currentUser = nil   // wipes out current user data model
        } catch {
            print("DEBUG: Failed to sign out with error \(error.localizedDescription)")
        }
    }
    
    func deleteAccount() {
            Auth.auth().currentUser?.delete()
            self.userSession = nil
            self.currentUser = nil

        let userId = Auth.auth().currentUser!.uid

                Firestore.firestore().collection("users").document(userId).delete() { err in
                    if let err = err {
                        print("error: \(err)")
                    } else {
                        print("Deleted user in db users")
                        Storage.storage().reference(forURL: "gs://myapp.appspot.com").child("users").child(userId).delete() { err in
                            if let err = err {
                                print("error: \(err)")
                            } else {
                                print("Deleted User image")
                                Auth.auth().currentUser!.delete { error in
                                   if let error = error {
                                       print("error deleting user - \(error)")
                                   } else {
                                        print("Account deleted")
                                   }
                                }
                            }
                        }
                    }
                }
    }
    func changePassword(password : String) {
        Task{
            
            await fetchUser()
        }
       Auth.auth().currentUser?.updatePassword(to: password) { err in
            if let err = err {
                print("error: \(err)")
            } else {
                print("Password has been updated")
                self.signOut()
            }
        }
    }
    
    func fetchUser() async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        //If there is data it will go and fetch data if there is not then it will return will wasting api calls
        guard let snapshot = try? await Firestore.firestore().collection("users").document(uid).getDocument() else { return }
        self.currentUser = try? snapshot.data(as: User.self)
        
       // print("DEBUG: Current user is \(String(describing: self.currentUser))")
    }
    
    
    //To add New Review
    func addReview(comment: String, documentUid: String, ratingStar: Int, skillOwnerDetailsUid: String, skillUid: String, teacherUid: String, time: String, className: String) async throws {
        let db = Firestore.firestore()

        // Fetch user asynchronously
        await fetchUser()

        guard let userId = Auth.auth().currentUser?.uid else {
            throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Current user not found"])
        }

        // Create a dictionary representing the review data
        let data: [String: Any] = [
            "academy": comment,
            "id": documentUid,
            "className": className,
            "ratingStar": ratingStar,
            "skillOwnerDetailsUid": skillOwnerDetailsUid,
            "skillUid": skillUid,
            "teacherUid": teacherUid,
            "time": time,
            "userId": userId
        ]

        do {
            // Add the document to the "review" collection
            try await db.collection("review").addDocument(data: data)
            print("Review added successfully to \(className) collection")
        } catch {
            print("Error adding document: \(error.localizedDescription)")
            throw error
        }
    }

     
     //To delete Review
     
    func deleteReview(userId: String, skillOwnerDetailsUid: String, teacherUid: String) async throws {
        let db = Firestore.firestore()

        do {
            // Fetch documents asynchronously
            let querySnapshot = try await db.collection("review")
                .whereField("userId", isEqualTo: userId)
                .whereField("skillOwnerDetailsUid", isEqualTo: skillOwnerDetailsUid)
                .whereField("teacherUid", isEqualTo: teacherUid)
                .getDocuments()

            // Delete each document found
            for document in querySnapshot.documents {
                try await db.collection("review").document(document.documentID).delete()
                print("Review deleted successfully")
            }
        } catch {
            print("Error deleting documents: \(error.localizedDescription)")
            throw error
        }
    }


     
     
  //    To Update Review
    func updateReview(comment: String, documentUid: String, ratingStar: Int, skillOwnerDetailsUid: String, skillUid: String, teacherUid: String, time: String, className: String) async throws {
        let db = Firestore.firestore()

        // Fetch user asynchronously
        await fetchUser()

        guard let userId = Auth.auth().currentUser?.uid else {
            throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Current user not found"])
        }

        // Create a dictionary representing the updated data
        let updatedData: [String: Any] = [
            "comment": comment,
            "id": documentUid,
            "ratingStar": ratingStar,
            "skillOwnerDetailsUid": skillOwnerDetailsUid,
            "skillUid": skillUid,
            "teacherUid": teacherUid,
            "time": time,
            "userId": userId
        ]

        do {
            // Update the document in the "review" collection with the provided documentUid
            try await db.collection("review").document(documentUid).setData(updatedData, merge: true)
            print("Document updated successfully")
        } catch {
            print("Error updating document: \(error.localizedDescription)")
            throw error
        }
    }

    
    //When Enroll Now button will be clicked this function will be called
    
    func addEnrolledStudent(teacherName: String , skillOwnerDetailsUid: String, studentName: String, studentUid: String, studentNumber: Int, requestAccepted: Int, requestSent: Int, className: String, teacherNumber: Int , teacherUid : String , skillUid : String , startTime : Timestamp , week : [String]) async throws {
        let db = Firestore.firestore()
        
        let data: [String: Any] = [
            "teacherName": teacherName,
            "skillOwnerDetailsUid": skillOwnerDetailsUid,
            "studentName": studentName,
            "studentUid": studentUid,
            "studentNumber": studentNumber,
            "RequestAccepted": requestAccepted,
            "RequestSent": requestSent,
            "className": className,
            "teacherNumber": teacherNumber,
            "teacherUid" : teacherUid,
            "skillUid" : skillUid,
            "startTime" : startTime,
            "week" : week ,
            "enrolledDate" : Date()
        ]
        
        do {
            _ = try await db.collection("enrolledStudent").addDocument(data: data)
            print("Document added successfully")
        } catch {
            print("Error adding document: \(error.localizedDescription)")
            throw error
        }
    }

    func updateStudentProfile(fullName: String, email: String, aboutParagraph: String, age: String, city: String, location: GeoPoint, occupation: String, phoneNumber: Int, selectedImage: UIImage?) {
        let db = Firestore.firestore()
        let userId = Auth.auth().currentUser!.uid
        
        guard let imageData = selectedImage?.jpegData(compressionQuality: 0.8) else {
            print("No image data available")
            return
        }
        
        let storageRef = Storage.storage().reference()
        let fileRef = storageRef.child("students/\(userId).jpg")
        
        let uploadTask = fileRef.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                print("Error uploading image: \(error.localizedDescription)")
                return
            }
            
            print("Image has been uploaded")
            
            fileRef.downloadURL { url, error in
                if let error = error {
                    print("Error getting download URL: \(error.localizedDescription)")
                    return
                }
                
                guard let downloadURL = url else {
                    print("Download URL not found")
                    return
                }
                
                // Update user document with profile data and image URL
                let userData: [String: Any] = [
                    "email": email,
                    "fullName": fullName,
                    "aboutParagraph": aboutParagraph,
                    "age": age,
                    "city": city,
                    "location": location,
                    "occupation": occupation,
                    "phoneNumber": phoneNumber,
                    "imageUrl": downloadURL.absoluteString
                ]
                
                db.collection("users").document(userId).setData(userData, merge: true) { error in
                    if let error = error {
                        print("Error updating user document: \(error.localizedDescription)")
                    } else {
                        print("User document updated successfully")
                    }
                }
            }
        }
    }

    
}


//do {
//    if let fullName = try await getFullName(forUserId: "yourUserId") {
//        print("Full Name: \(fullName)")
//    } else {
//        print("Full Name not found.")
//    }
//} catch {
//    print("Error: \(error.localizedDescription)")
//}
