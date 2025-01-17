import SwiftUI
import Photos

struct PhotoPreviewView: View {
    @Environment(\.dismiss) var dismiss
    let photo: UIImage
    @State private var isSaving = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                
                Image(uiImage: photo)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("返回") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        savePhoto()
                    } label: {
                        Image(systemName: "square.and.arrow.down")
                    }
                    .disabled(isSaving)
                }
            }
        }
        .alert("提示", isPresented: $showAlert) {
            Button("确定", role: .cancel) {}
        } message: {
            Text(alertMessage)
        }
    }
    
    private func savePhoto() {
        isSaving = true
        
        PHPhotoLibrary.requestAuthorization { status in
            if status == .authorized {
                PHPhotoLibrary.shared().performChanges {
                    let request = PHAssetCreationRequest.forAsset()
                    request.addResource(with: .photo, data: photo.jpegData(compressionQuality: 0.8)!, options: nil)
                } completionHandler: { success, error in
                    DispatchQueue.main.async {
                        isSaving = false
                        alertMessage = success ? "照片保存成功" : "保存失败：\(error?.localizedDescription ?? "")"
                        showAlert = true
                    }
                }
            } else {
                DispatchQueue.main.async {
                    isSaving = false
                    alertMessage = "需要相册访问权限才能保存照片"
                    showAlert = true
                }
            }
        }
    }
} 