struct PoseTemplateOverlay: View {
    @Binding var templateImage: UIImage?
    
    // 控制模板位置和大小
    @State private var position = CGPoint.zero
    @State private var scale: CGFloat = 1.0
    @State private var rotation: Angle = .zero
    @State private var opacity: Double = 0.7
    
    // 手势状态
    @GestureState private var dragState = CGSize.zero
    @GestureState private var scaleState: CGFloat = 1.0
    @GestureState private var rotationState: Angle = .zero
    
    var body: some View {
        GeometryReader { geometry in
            if let image = templateImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .opacity(opacity)
                    .scaleEffect(scale * scaleState)
                    .rotationEffect(rotation + rotationState)
                    .offset(x: position.x + dragState.width,
                           y: position.y + dragState.height)
                    .gesture(
                        SimultaneousGesture(
                            DragGesture()
                                .updating($dragState) { value, state, _ in
                                    state = value.translation
                                }
                                .onEnded { value in
                                    position.x += value.translation.width
                                    position.y += value.translation.height
                                },
                            SimultaneousGesture(
                                MagnificationGesture()
                                    .updating($scaleState) { value, state, _ in
                                        state = value
                                    }
                                    .onEnded { value in
                                        scale *= value
                                    },
                                RotationGesture()
                                    .updating($rotationState) { value, state, _ in
                                        state = value
                                    }
                                    .onEnded { value in
                                        rotation += value
                                    }
                            )
                        )
                    )
                    .overlay(alignment: .topTrailing) {
                        // 透明度调节滑块
                        Slider(value: $opacity, in: 0.1...1.0)
                            .frame(width: 100)
                            .rotationEffect(.degrees(-90))
                            .offset(x: 30, y: 50)
                    }
            }
        }
    }
} 