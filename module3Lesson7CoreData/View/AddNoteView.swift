import SwiftUI
import PhotosUI



//struct AddNoteView: View {
//    @Binding var text: String
//    @Binding var imageData: Data?
//    let onSave: () -> Void
//    @State private var selectedPhoto: PhotosPickerItem?
//    
//    var body: some View {
//        NavigationView {
//            Form {
//                Section("Текст задачи") {
//                    TextField("Введите текст...", text: $text)
//                }
//                
//                Section("Фото") {
//                    PhotosPicker(selection: $selectedPhoto, matching: .images) {
//                        if let data = imageData, let uiImage = UIImage(data: data) {
//                            Image(uiImage: uiImage)
//                                .resizable()
//                                .frame(height: 150)
//                        } else {
//                            Text("Выбрать фото")
//                                .foregroundColor(.blue)
//                        }
//                    }
//                    
//                    .onChange(of: selectedPhoto) { _, newValue in
//                        Task {
//                            if let data = try? await newValue?.loadTransferable(type: Data.self) {
//                                imageData = data
//                            }
//                        }
//                    }
//                }
//            }
//            .navigationTitle("Новая задача")
//            .toolbar {
//                ToolbarItem(placement: .cancellationAction) {
//                    Button("Отмена") {
//                        // Очищаем текст
//                        text = ""
//                        // Очищаем картинку
//                        imageData = nil
//                        // Сбрасываем выбор в пикере (чтобы при следующем открытии он был пустым)
//                        selectedPhoto = nil
//                    }
//                }
//                ToolbarItem(placement: .confirmationAction) {
//                    Button("Сохранить") {
//                        onSave()
//                    }
//                    .disabled(text.isEmpty)
//                }
//            }
//        }
//    }
//}


struct AddNoteView: View {
    @Binding var text: String
    @Binding var imageData: Data?
    let onSave: () -> Void
    @State private var selectedPhoto: PhotosPickerItem?
    
    var body: some View {
        NavigationView {
            Form {
                Section("Текст задачи") {
                    TextField("Введите текст...", text: $text)
                }
                
                Section("Фото") {
                    PhotosPicker(selection: $selectedPhoto, matching: .images) {
                        if let data = imageData, let uiImage = UIImage(data: data) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .frame(height: 150)
                        } else {
                            Text("Выбрать фото")
                                .foregroundColor(.blue)
                        }
                    }
                    .onChange(of: selectedPhoto) { _, newValue in
                        Task {
                            if let data = try? await newValue?.loadTransferable(type: Data.self) {
                                imageData = data
                            }
                        }
                    }
                }
            }
            .navigationTitle("Новая задача")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Отмена") {
                        text = ""
                        imageData = nil
                        selectedPhoto = nil
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Сохранить") {
                        onSave()
                        // Сбрасываем selectedPhoto после сохранения
                        selectedPhoto = nil
                    }
                    .disabled(text.isEmpty)
                }
            }
        }
    }
}
