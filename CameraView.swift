// 需要实现的关键功能:
// 1. 调用系统相机API
// 2. 实现预览界面
// 3. 添加拍照按钮和基础控制
struct CameraView: View {
    // 相机会话管理
    @StateObject private var camera = CameraManager()
    @State private var showingPoseLibrary = false
    @State private var capturedImage: UIImage?
    @State private var selectedTemplate: UIImage?
    @State private var showingPhotoPreview = false
    
    var body: some View {
        ZStack {
            // 相机预览层
            CameraPreviewView()
                .environmentObject(camera)
            
            // 姿势模板叠加层
            PoseTemplateOverlay(templateImage: $selectedTemplate)
            
            // 控制按钮
            VStack {
                Spacer()
                HStack {
                    Button(action: { showingPoseLibrary.toggle() }) {
                        Image(systemName: "person.2.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.white)
                            .padding()
                    }
                    
                    Spacer()
                    
                    // 拍照按钮
                    Button(action: takePhoto) {
                        Circle()
                            .stroke(Color.white, lineWidth: 3)
                            .frame(width: 70, height: 70)
                            .padding()
                    }
                    
                    Spacer()
                    
                    // 切换相机按钮
                    Button(action: switchCamera) {
                        Image(systemName: "camera.rotate.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.white)
                            .padding()
                    }
                }
                .padding(.horizontal)
            }
        }
        .sheet(isPresented: $showingPoseLibrary) {
            PoseLibraryView(selectedTemplate: $selectedTemplate)
        }
        .sheet(isPresented: $showingPhotoPreview) {
            if let image = capturedImage {
                PhotoPreviewView(photo: image)
            }
        }
    }
    
    private func takePhoto() {
        camera.capturePhoto { image in
            if let image = image {
                self.capturedImage = image
                self.showingPhotoPreview = true
            }
        }
    }
    
    private func switchCamera() {
        camera.switchCamera()
    }
} 