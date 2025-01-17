struct PoseLibraryView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var selectedTemplate: UIImage?
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 10) {
                    ForEach(PoseTemplate.samples) { template in
                        Button {
                            // 加载模板图片
                            selectedTemplate = UIImage(named: template.image)
                            dismiss()
                        } label: {
                            VStack {
                                Image(template.image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 120)
                                    .cornerRadius(8)
                                
                                Text(template.name)
                                    .font(.caption)
                                    .foregroundColor(.primary)
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("选择姿势模板")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("关闭") {
                        dismiss()
                    }
                }
            }
        }
    }
} 