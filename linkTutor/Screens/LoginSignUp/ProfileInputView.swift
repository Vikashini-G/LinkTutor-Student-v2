import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseStorage

struct ProfileInputView: View {
    
    @EnvironmentObject var viewModel: AuthViewModel
  
    @State private var fullName: String = ""
    @State private var email: String = ""
    @State private var city: String = ""
    @State private var phoneNumber: Int = 91
    @State private var about: String = ""
    @State private var occupation : String = ""
    @State private var age : String = ""

  
    @State private var location: GeoPoint = GeoPoint(latitude: 12.8096, longitude: 80.8097)
    
    @State var isPickerShowing = false
    @State var selectedImage: UIImage?
    
    @State private var isProfileIsSubmit = false
    
    var body: some View {
       
        NavigationStack{
            
            VStack {
                VStack{
                    HStack{
                        Text("Edit Profile ")
                            .font(AppFont.largeBold)
                        Spacer()
                    }
                    
                    
                    Button(action: {
                        isPickerShowing = true
                    }) {
                        if let image = selectedImage {
                            Image(uiImage: image)
                                .resizable() // Call resizable on Image, not UIImage
                                .frame(width: 100, height: 100)
                                .cornerRadius(50.0)
                        } else {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .foregroundColor(.gray)
                                .frame(width: 90, height: 90)
                                .cornerRadius(50.0)
                        }
                    }
                    .sheet(isPresented: $isPickerShowing , onDismiss: nil) {
                        ImagePicker(selectedImage: $selectedImage, isPickerShowing: $isPickerShowing)
                    }
                }
                .padding()
                
                List{
                    Section(header: Text("")){
                        // Name TextField
                        TextField("Name", text: $fullName)
                            .listRowBackground(Color.elavated)
                        
                        // About TextField
                        TextField("About", text: $about)
                            .listRowBackground(Color.elavated)
                        
                        // Email TextField
                        TextField("Email Address", text: $email)
                            .listRowBackground(Color.elavated)
                            .autocapitalization(.none)
                        
                        TextField("City", text: $city)
                            .listRowBackground(Color.elavated)
                        
                        
                        
                        TextField("Age", text: $age)
                            .listRowBackground(Color.elavated)
                        TextField("Occupation", text: $occupation)
                            .listRowBackground(Color.elavated)
                    }
                    
                    Section(header: Text("Phone Number")){
                        // Password SecureField
                        TextField("PhoneNumber", value: $phoneNumber, formatter: NumberFormatter())
                            .keyboardType(.numberPad)
                    }
                    
                    
                    
                }
                .listStyle(.plain)
                .background(.clear)
                NavigationLink(destination: homepageComplete(), isActive: $isProfileIsSubmit) {
                    Button(action: {
                        // Handle add class action
                        viewModel.updateStudentProfile(fullName: fullName,
                                                       email: email,
                                                       aboutParagraph: about,
                                                       age: age,
                                                       city: city,
                                                       location: location,
                                                       occupation: occupation,
                                                       phoneNumber: phoneNumber ,
                                                       selectedImage: selectedImage)
                        // Activate the navigation to TeacherHomePage
                        
                        
                        isProfileIsSubmit = true
                    }) {
                        Text("Submit Profile")
                            .foregroundColor(.white)
                            .font(AppFont.mediumSemiBold)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(20)
                    }
                }
               
                // Submit Button
               
                
            } //v end
            .background(Color.background)
            
        }
    }
        
    }





struct ImagePicker: UIViewControllerRepresentable {
    
    @Binding var selectedImage: UIImage?
    @Binding var isPickerShowing: Bool
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let imagePicker1 = UIImagePickerController()
        imagePicker1.sourceType = .photoLibrary
        imagePicker1.delegate = context.coordinator
        
        return imagePicker1
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
}

class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    var parent: ImagePicker
    init(_ picker: ImagePicker){
        self.parent = picker
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("Image selected")
        if let image = info[UIImagePickerController.InfoKey.originalImage] as?
            UIImage{
            DispatchQueue.main.async {
                self.parent.selectedImage = image
            }
        }
        parent.isPickerShowing = false
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("Cancelled")
        parent.isPickerShowing = false
    }
}


#Preview {
    ProfileInputView()
    }



