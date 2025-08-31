import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var coordinator: Coordinator
    @StateObject var viewModel = ProfileViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            profileInfoView
            
            contactDetailsView
            
            Spacer()
            
            actionButtonsView
        }
        .navigationBarBackButtonHidden(false)
        .background(Color.backgroundApp.ignoresSafeArea())
        .navigationBarTitle("profile_information".localized, displayMode: .inline)
        .onAppear {
            viewModel.getUserData()
        }
        .alert("error".localized, isPresented: $viewModel.showError) {
            Button("ok".localized) { }
        } message: {
            Text(viewModel.errorMessage ?? "unknown_error".localizedString())
        }
    }
    
    private var profileInfoView: some View {
        HStack(spacing: 16) {
            FirstLetterAvatar(name: viewModel.userData?.fullname ?? "Aman Amanow")
            
            VStack(alignment: .leading, spacing: 4) {
                Text(viewModel.userData?.phone_number ?? "")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Text(viewModel.userData?.fullname ?? "")
                    .font(.title3)
                    .fontWeight(.medium)
                    .foregroundColor(.black)
            }
            
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 20)
        .background(Color.white)
    }
    
    private var contactDetailsView: some View {
        VStack(spacing: 0) {
            ContactRow(
                title: "phone".localizedString(),
                value: viewModel.userData?.phone_number ?? "+993 64 411955",
                icon: "phone"
            )
            
            Divider()
                .padding(.leading, 16)
            
            ContactRow(
                title: "gender".localizedString(),
                value: viewModel.userData?.gender ?? "male".localizedString(),
                icon: "person"
            )
        }
        .background(Color.white)
    }
    
    private var actionButtonsView: some View {
        VStack(spacing: 12) {
            Button(action: {
                
            }) {
                Text("log_out".localized)
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color.blue)
                    .cornerRadius(8)
            }
            
            Button(action: {
                
            }) {
                Text("delete_account".localized)
                    .font(.headline)
                    .foregroundColor(.red)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color.clear)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.red, lineWidth: 1)
                    )
            }
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 32)
    }
}

struct FirstLetterAvatar: View {
    let name: String
    
    private var firstLetter: String {
        let components = name.components(separatedBy: " ")
        return components.first?.first?.uppercased() ?? "default_avatar_letter".localizedString()
    }
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.blue.opacity(0.7))
                .frame(width: 80, height: 80)
            
            Text(firstLetter)
                .font(.system(size: 32, weight: .medium))
                .foregroundColor(.white)
        }
    }
}

struct ContactRow: View {
    let title: String
    let value: String
    let icon: String
    var isPassword: Bool = false
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Text(value)
                    .font(.body)
                    .foregroundColor(.black)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .contentShape(Rectangle())
        .onTapGesture {
            // Handle row tap
        }
    }
}

#Preview{
    ProfileView()
}
