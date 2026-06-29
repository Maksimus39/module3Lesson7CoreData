import SwiftUI


struct NoteListView: View {
    let folderModel: FolderModel
    
    @State private var viewModel: NoteListViewModel
    
    @State private var isAddingNote = false
    @State private var newNoteText = ""
    @State private var noteImageData: Data?
    
    @State private var isEditingNote = false
    @State private var editingNoteId: String? = nil
    @State private var editingNoteText = ""
    
    init(folderModel: FolderModel) {
        self.folderModel = folderModel
        _ = NoteListViewModel(folder: folderModel)
        self._viewModel = State(wrappedValue: Assembly.shared.createNoteListViewModel(folder: folderModel))
    }
    
    var body: some View {
        List {
            ForEach(viewModel.notes) { note in
                HStack {
                    VStack(alignment: .leading) {
                        Text(note.text)
                            .font(.body)
                        
                        if let imageName = note.imageFileName,
                           let uiImage = StorageManager.shared.loadImage(fileName: imageName) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 150)
                                .cornerRadius(8)
                        }
                    }
                    Spacer()
                }
                .swipeActions(edge: .trailing) {
                    Button(role: .destructive) {
                        viewModel.deleteNote(note)
                    } label: {
                        Label("Удалить", systemImage: "trash")
                    }
                    
                    Button {
                        editingNoteId = note.id
                        editingNoteText = note.text
                        isEditingNote = true
                    } label: {
                        Label("Изменить", systemImage: "pencil")
                    }
                    .tint(.blue)
                }
            }
        }
        .navigationTitle(folderModel.name)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    isAddingNote = true
                }) {
                    Image(systemName: "plus")
                }
            }
            
            ToolbarItem(placement: .principal) {
                if viewModel.showError {
                    Text(viewModel.errorMessage ?? "")
                        .font(.caption)
                        .foregroundColor(.red)
                }
            }
        }
        
        .alert("Изменить задачу", isPresented: $isEditingNote) {
            TextField("Новый текст", text: $editingNoteText)
            Button("Готово") {
                saveEditedNote()
            }
            Button("Отмена", role: .cancel) {}
        }
        
        .sheet(isPresented: $isAddingNote) {
            AddNoteView(
                text: $newNoteText,
                imageData: $noteImageData,
                onSave: {
                    var imageName: String? = nil
                    if let data = noteImageData {
                        imageName = StorageManager.shared.saveImage(data: data)
                    }
                    viewModel.addNote(text: newNoteText, imageFileName: imageName)
                    newNoteText = ""
                    noteImageData = nil
                    isAddingNote = false
                }
            )
        }
    }
    
    private func saveEditedNote() {
        guard let id = editingNoteId,
              let note = viewModel.notes.first(where: { $0.id == id }) else { return }
        
        viewModel.updateNoteText(note, newText: editingNoteText)
        editingNoteId = nil
    }
}
