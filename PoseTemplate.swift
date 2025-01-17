struct PoseTemplate: Identifiable {
    let id = UUID()
    let image: String  // 图片资源名称
    let name: String
    let category: PoseCategory
}

enum PoseCategory: String, CaseIterable {
    case couple = "情侣"
    case single = "个人"
    case group = "团体"
}

// 示例数据
extension PoseTemplate {
    static let samples = [
        PoseTemplate(image: "pose_couple_1", name: "甜蜜相依", category: .couple),
        PoseTemplate(image: "pose_couple_2", name: "背靠背", category: .couple),
        PoseTemplate(image: "pose_single_1", name: "街拍风", category: .single),
        // 后续可以添加更多模板
    ]
} 