import SwiftUI


struct ContentView: View {
    @State private var viewModel = Assembly.createContentViewModel()
    
    // Флаги и данные для создания
    @State private var isAddingFolder = false
    @State private var newFolderName = ""
    
    // Флаги и данные для редактирования
    @State private var isEditingFolder = false
    @State private var editingFolderId: String? = nil 
    @State private var editingFolderName = ""
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.folders) { folder in
                    NavigationLink(destination: NoteListView(folderModel: folder)) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(folder.name)
                                    .font(.headline)
                                Text("Задачи")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                        }
                    }
                    .swipeActions(edge: .trailing) {
                        Button(role: .destructive) {
                            viewModel.deleteFolder(folder)
                        } label: {
                            Label("Удалить", systemImage: "trash")
                        }
                        
                        Button {
                            editingFolderId = folder.id
                            editingFolderName = folder.name
                            isEditingFolder = true
                        } label: {
                            Label("Изменить", systemImage: "pencil")
                        }
                        .tint(.blue)
                    }
                }
            }
            .navigationTitle("Мои Папки")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { isAddingFolder = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .alert("Новая папка", isPresented: $isAddingFolder) {
                TextField("Название", text: $newFolderName)
                Button("Создать") {
                    viewModel.createFolder(titleFolder: newFolderName)
                    newFolderName = ""
                }
                Button("Отмена", role: .cancel) {}
            }
            .alert("Переименовать папку", isPresented: $isEditingFolder) {
                TextField("Новое название", text: $editingFolderName)
                Button("Готово") {
                    if let id = editingFolderId,
                       let folder = viewModel.folders.first(where: { $0.id == id }) {
                        viewModel.updateFolder(folder, newName: editingFolderName)
                    }
                }
                Button("Отмена", role: .cancel) {}
            }
        }
    }
}
