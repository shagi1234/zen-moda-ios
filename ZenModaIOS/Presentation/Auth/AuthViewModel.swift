import SwiftUI
import Combine

class AuthViewModel: ObservableObject {
    @Published var phoneNumber = ""
    
    @Published var otpField = "" {
        didSet {
            guard otpField.count <= 5,
                  otpField.last?.isNumber ?? true else {
                otpField = oldValue
                return
            }
        }
    }
    
    @Published var fullName = ""
    @Published var selectedGender = 0
    
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showError = false
    
    @Published var isPhoneValid = false
    @Published var isOTPValid = false
    @Published var isNameValid = false
    @Published var acceptedTerms = false
    
    @Published var currentStep: AuthStep = .signUp
    @Published var otpTimer = 47
    @Published var canResendOTP = false
    
    private var cancellables = Set<AnyCancellable>()
    private var otpTimerCancellable: AnyCancellable?
    private let authRepository: AuthRepository
    
    init(authRepository: AuthRepository = AuthRepositoryImpl()) {
        self.authRepository = authRepository
        setupValidation()
    }
    
    var otp1: String {
        guard otpField.count >= 1 else { return "" }
        return String(Array(otpField)[0])
    }
    var otp2: String {
        guard otpField.count >= 2 else { return "" }
        return String(Array(otpField)[1])
    }
    var otp3: String {
        guard otpField.count >= 3 else { return "" }
        return String(Array(otpField)[2])
    }
    var otp4: String {
        guard otpField.count >= 4 else { return "" }
        return String(Array(otpField)[3])
    }
    var otp5: String {
        guard otpField.count >= 5 else { return "" }
        return String(Array(otpField)[4])
    }
    
    @Published var borderColor: Color = .borderLight
    @Published var isTextFieldDisabled = false
    var successCompletionHandler: (() -> ())?
    
    @Published var showResendText = false
    
    private func setupValidation() {
        $phoneNumber
            .map { phone in
                self.isValidPhoneNumber(phone)
            }
            .assign(to: \.isPhoneValid, on: self)
            .store(in: &cancellables)
        
        $otpField
            .map { otp in
                otp.count == 5 && otp.allSatisfy { $0.isNumber }
            }
            .assign(to: \.isOTPValid, on: self)
            .store(in: &cancellables)
        
        $fullName
            .map { name in
                name.trimmingCharacters(in: .whitespaces).count >= 2
            }
            .assign(to: \.isNameValid, on: self)
            .store(in: &cancellables)
    }
    
    private func isValidPhoneNumber(_ phone: String) -> Bool {
        return phone.count == 8 && phone.allSatisfy { $0.isNumber }
    }
    
    func sendOTP() {
        guard isPhoneValid else { return }
        
        isLoading = true
        errorMessage = nil
        
        let request = RequestLogin(phone: phoneNumber)
        
        authRepository.login(request: request)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    
                    if case .failure(let error) = completion {
                        self?.handleError(error)
                    }
                },
                receiveValue: { [weak self] response in
                    self?.currentStep = .verification
                    Defaults.phoneNumber = self?.phoneNumber ?? ""
                    self?.startOTPTimer()
                }
            )
            .store(in: &cancellables)
    }
    
    func verifyOTP() {
        guard isOTPValid else { return }
        
        isLoading = true
        errorMessage = nil
        
        let request = RequestConfirmOtp(
            phone_number: phoneNumber,
            code: otpField
        )
        
        authRepository.confirm(request: request)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    
                    if case .failure(let error) = completion {
                        self?.handleError(error)
                    }
                },
                receiveValue: { [weak self] response in
                    
                    if !response.userAlreadyExist {
                        self?.currentStep = .nameEntry
                    } else {
                        self?.currentStep = .completed
                        Defaults.username = response.user?.fullname ?? ""
                        Defaults.gender = response.user?.gender ?? ""
                        Defaults.userId = response.user?.id ?? ""
                        Defaults.token = response.access_token ?? ""
                    }
                    
                    
                }
            )
            .store(in: &cancellables)
    }
    
    func completeRegistration() {
        guard isNameValid else { return }
        
        isLoading = true
        errorMessage = nil
        
        let request = RequestUpdateProfile(
            fullname: fullName,
            phone_number: Defaults.phoneNumber,
            gender: selectedGender == 0 ? "MALE" : "FEMALE"
        )
        
        authRepository.completeRegistration(request: request)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    
                    if case .failure(let error) = completion {
                        self?.handleError(error)
                    }
                },
                receiveValue: { [weak self] response in
                    self?.isLoading = false
                    
                    Defaults.username = response.user.fullname ?? ""
                    Defaults.userId = response.user.id
                    Defaults.gender = response.user.gender ?? ""
                    Defaults.token = response.access_token
                    
                    self?.currentStep = .completed
                }
            )
            .store(in: &cancellables)
    }
    
    func resendOTP() {
        guard canResendOTP else { return }
        sendOTP()
    }
    
    private func startOTPTimer() {
        otpTimer = 47
        canResendOTP = false
        
        otpTimerCancellable = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                
                if self.otpTimer > 0 {
                    self.otpTimer -= 1
                } else {
                    self.canResendOTP = true
                    self.otpTimerCancellable?.cancel()
                }
            }
    }
    
    private func handleError(_ error: NetworkError) {
        errorMessage = error.userFriendlyMessage
        showError = true
    }
    
    func goBack() {
        switch currentStep {
        case .verification:
            currentStep = .signUp
        case .nameEntry:
            currentStep = .verification
        default:
            break
        }
    }
}

enum AuthStep {
    case signUp
    case verification
    case nameEntry
    case completed
}
