import AVFoundation
import SwiftUI

class CameraManager: ObservableObject {
    @Published var session = AVCaptureSession()
    @Published var isReady = false
    private var camera: AVCaptureDevice?
    private var photoOutput = AVCapturePhotoOutput()
    @Published var isFrontCamera = false
    
    init() {
        setupCamera()
    }
    
    private func setupCamera() {
        // 请求相机权限
        AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
            guard granted else { return }
            
            DispatchQueue.main.async {
                self?.configureCameraInput()
            }
        }
    }
    
    private func configureCameraInput() {
        // 配置照片输出
        if session.canAddOutput(photoOutput) {
            session.addOutput(photoOutput)
        }
        
        // 获取后置相机
        if let device = AVCaptureDevice.default(.builtInWideAngleCamera, 
                                              for: .video, 
                                              position: .back) {
            do {
                let input = try AVCaptureDeviceInput(device: device)
                if session.canAddInput(input) {
                    session.addInput(input)
                    camera = device
                    isReady = true
                }
            } catch {
                print("相机设置错误: \(error.localizedDescription)")
            }
        }
    }
    
    func switchCamera() {
        session.beginConfiguration()
        
        // 移除现有输入
        if let currentInput = session.inputs.first {
            session.removeInput(currentInput)
        }
        
        // 切换相机位置
        let newPosition: AVCaptureDevice.Position = isFrontCamera ? .back : .front
        if let newCamera = AVCaptureDevice.default(.builtInWideAngleCamera, 
                                                 for: .video, 
                                                 position: newPosition) {
            do {
                let newInput = try AVCaptureDeviceInput(device: newCamera)
                if session.canAddInput(newInput) {
                    session.addInput(newInput)
                    camera = newCamera
                    isFrontCamera.toggle()
                }
            } catch {
                print("切换相机失败: \(error.localizedDescription)")
            }
        }
        
        session.commitConfiguration()
    }
    
    func capturePhoto(completion: @escaping (UIImage?) -> Void) {
        let settings = AVCapturePhotoSettings()
        photoOutput.capturePhoto(with: settings) { photoData, error in
            guard let data = photoData,
                  let image = UIImage(data: data.fileDataRepresentation()!) else {
                completion(nil)
                return
            }
            completion(image)
        }
    }
} 