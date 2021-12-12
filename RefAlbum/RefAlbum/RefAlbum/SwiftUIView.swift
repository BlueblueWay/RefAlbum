//
//  SwiftUIView.swift
//  RefAlbum
//
//  Created by lingshun kong on 11/30/21.
//

import SwiftUI

//init database
var data = RefAlbumRepository.get()
let conn = Database()
let tb1 = conn.tb1!
let tb2 = conn.tb2!

// collection view
struct SwiftUIView: View {

    //sellected event id
    @State var id: Int = 0
    @State var collectionModels: [CollectionModel] = conn.listCollection()
    
    var body: some View {
        
        NavigationView {
                    ScrollView {
                        VStack(spacing: 20) {
                            ForEach(self.collectionModels) { element in
                                HStack {
                                    NavigationLink(
                                        destination: EventScreen(id: element.id),
                                        label: {
                                            Text("Collection: \(element.content)")
                                            
                                            Button(action: {
                                                
                                                conn.deleteCollection(element.id)
                                                collectionModels = conn.listCollection()
                                            }, label: {
                                                Text("Delete")
                                                    .foregroundColor(Color.red)
                                            })
                                        })
                                }
                            }
                        }.padding()
                        .frame(maxWidth: .infinity)
                        .onAppear(perform: {
                            self.collectionModels = conn.listCollection()
                            print("collcetion view on appear")
                        })
                    }
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationTitle("Collection")
                    
                    //add more collection
                    .navigationBarItems(trailing:
                                            NavigationLink(
                                                destination: AddCollection(),
                                                label: {
                                                    Image(systemName: "plus")
                                                })
                    )
        }

    }
}



// event view
struct EventScreen : View {
    //event id
    var id: Int
    @State var list: [EventModel] = []
    @State var content: String=""
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Collection id: \(id)")
                
                
                ForEach(self.list) { element in
                    
                    HStack {
                        Text("event \(element.content)")
                        
                        //delete event
                        Button(action: {
                            conn.deleteEvent(element.id)
                            list = conn.listEvents(id)
                        }, label: {
                            Text("Delete")
                                .foregroundColor(Color.red)
                        })
                        
                    }
                    
                    
                }
                
                //add more event
                TextField("Enter content", text: $content)
                    .padding(10)
                    .cornerRadius(5)
                    .background(Color(.systemGray6))
                    .disableAutocorrection(true)
                    .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                
                Button(action: {
                    print(content)
                    data.insertEvent(id, content)
                    list = conn.listEvents(id)
                    
                }, label: {
                    Text("Done")
                })
            }.padding()
            .onAppear(perform: {
                list = conn.listEvents(id)
            })
            .frame(maxWidth: .infinity)
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Event")
        
    }
}

// add collection view
struct AddCollection : View {
    @State var content: String=""
    
    //back to previous page
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    var body: some View {
        VStack {
            TextField("Enter Name", text: $content)
                .padding(10)
                .cornerRadius(5)
                .background(Color(.systemGray6))
                .disableAutocorrection(true)
                .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
            
            Button(action: {
                print(content)
                data.insertCollection(content)
                self.mode.wrappedValue.dismiss()
                
            }, label: {
                Text("Done")
            })
        }
    }
}


