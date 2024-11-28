//
//  FormFieldsShowcase.swift
//  CarePaper2
//
//  Created by Travis Ma on 8/17/23.
//

import SwiftUI
import PhotosUI
import QuickLook

struct FormFieldsShowcase: View {
    @State private var text: String = ""
    @State private var isToggled: Bool = false
    @State private var selectedPickerOption = "Option1"
    private let pickerOptions = ["Option1", "Option2", "Option2"]
    @State private var sliderValue: Double = 50
    @State private var date = Date()
    @State private var stepper = 1
    @State var selectedPhoto: PhotosPickerItem?
    @State var imageData: Data?
    @State var imageFileUrl: URL?
    
    //use for default focus
    @FocusState private var isFocused: Bool
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Text("Just Non-Editable Text")
                    LabeledContent("Non-Editable: Title", value: "Value")
                    TextField("Text Field", text: $text)
                        .focused($isFocused)
                    Toggle(isOn: $isToggled) {
                        Text("Toggle")
                    }
                    Stepper(
                        "Stepper Value: \(stepper)",
                        value: $stepper,
                        in: 1...10,
                        step: 1
                    )
                } header: {
                    Text("Common Controls")
                }
                
                Section {
                    TextEditor(text: $text)
                        .frame(height: 100)
                } header: {
                    Text("Long text Area")
                }
                
                Section {
                    Slider(value: $sliderValue, in: 0...100, step: 1)
                } header: {
                    Text("Slider")
                } footer: {
                    Text("Value: \(sliderValue)")
                }
                
                Section {
                    DatePicker(
                        "Date",
                        selection: $date,
                        displayedComponents: [.date]
                    )
                    .datePickerStyle(.compact)
                } header: {
                    Text("Date Picker - Compact")
                }
                
                Section {
                    DatePicker(
                        "Pick a Date",
                        selection: $date,
                        displayedComponents: [.date]
                    )
                    .datePickerStyle(.graphical)
                } header: {
                    Text("Date Picker - Graphical")
                }
                
                Section {
                    DatePicker(
                        "Pick a Date",
                        selection: $date,
                        displayedComponents: [.date]
                    )
                    .datePickerStyle(.wheel)
                } header: {
                    Text("Date Picker - Wheel")
                }
                
                Section {
                    Picker("Picker - Inline", selection: $selectedPickerOption) {
                        ForEach(pickerOptions, id: \.self) { option in
                            HStack {
                                Image(systemName: "envelope")
                                Text(option)
                            }
                            .tag(option) //if you need a custom tag
                            .onTapGesture {
                                selectedPickerOption = option
                            }
                        }
                    }
                    .pickerStyle(.inline)
                    Button("Add New") {
                        // Reset logic
                    }
                }
                
                Section {
                    Picker("Picker Options", selection: $selectedPickerOption) {
                        ForEach(pickerOptions, id: \.self) { option in
                            HStack {
                                Image(systemName: "envelope")
                                Text(option)
                            }
                        }
                    }
                    .pickerStyle(.menu)
                } header: {
                    Text("Picker - Menu")
                }
                
                Section {
                    Picker("Picker Options", selection: $selectedPickerOption) {
                        ForEach(pickerOptions, id: \.self) { option in
                            Text(option)
                        }
                    }
                    .pickerStyle(.segmented)
                } header: {
                    Text("Picker - Segmented")
                }
                
                Section {
                    Picker("Picker Options", selection: $selectedPickerOption) {
                        ForEach(pickerOptions, id: \.self) { option in
                            HStack {
                                Image(systemName: "envelope")
                                Text(option)
                            }
                        }
                    }
                    .pickerStyle(.wheel)
                } header: {
                    Text("Picker - Wheel")
                }
                
                Section {
                    if let selectedPhotoData = imageData,
                       let uiImage = UIImage(data: selectedPhotoData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(maxWidth: .infinity, maxHeight: 300)
                            .onTapGesture {
                                if let fileURL = saveDataToTempDirectory(
                                    data: selectedPhotoData,
                                    fileName: "tempFile",
                                    fileExtension: "png"
                                ) {
                                    print("Data saved at \(fileURL)")
                                    imageFileUrl = fileURL
                                } else {
                                    print("Data could not be saved")
                                }
                            }
                            .quickLookPreview($imageFileUrl)
                    }
        
                    if imageData == nil {
                        PhotosPicker(selection: $selectedPhoto,
                                     matching: .images,
                                     photoLibrary: .shared()
                        ) {
                            Label("Add Image", systemImage: "photo")
                        }
                    } else {
                        Button(role: .destructive) {
                            withAnimation {
                                selectedPhoto = nil
                                imageData = nil
                                imageFileUrl = nil
                            }
                        } label: {
                            Label("Remove Image", systemImage: "xmark")
                                .foregroundStyle(.red)
                        }
                    }
                }
                
                Section {
                    Button("Hide keyboard") {
                        isFocused = false
                    }
                    Button(
                        "Delete",
                        role: .destructive
                    ) {}
                }
            }
            .safeAreaInset(edge: .bottom, spacing: 0) {
                //this inset is for scrolling above any footer buttons
                Spacer()
                    .frame(height: 100)
            }
            .navigationTitle("Form Entry")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            isFocused = true
        }
        .task(id: selectedPhoto) {
            if let data = try? await selectedPhoto?.loadTransferable(
                type: Data.self
            ) {
                imageData = data
            }
        }
    }
}

func saveDataToTempDirectory(data: Data, fileName: String, fileExtension: String) -> URL? {
    let tempDirectory = FileManager.default.temporaryDirectory
    let fileURL = tempDirectory.appendingPathComponent(fileName).appendingPathExtension(fileExtension)
    
    do {
        try data.write(to: fileURL)
        return fileURL
    } catch {
        print("An error occurred while writing the data to \(fileURL): \(error)")
        return nil
    }
}

#Preview {
    FormFieldsShowcase()
}
