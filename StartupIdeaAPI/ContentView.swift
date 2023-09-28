//
//  ContentView.swift
//  StartupIdeaAPI
//
//  Created by Kosuke Onishi on 2023/09/28.
//

import SwiftUI

struct Idea: Codable {
    var this: String
    var that: String
}

struct ContentView: View {
    @State private var idea: Idea?
    @State private var isFetching = false

    var body: some View {
        VStack {
            HStack {
                Text("Random")
                    .font(.title)
                    .fontWeight(.light)
                Text("Startup Idea")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(Color(.purple))
            }
            Button("Generate") {
                print("Idea Requested")
                Task {
                    isFetching = true
                    await fetchData()
                    isFetching = false
                }
            }
            .buttonStyle(.borderedProminent)
            .tint(.green)
            .fontWeight(.bold)
            .padding(.bottom, 20)
            if (isFetching) {
                ProgressView()
            } else if (idea != nil) {
                Text("This: \(idea!.this)").fontWeight(.bold)
                Text("That: \(idea!.that)").fontWeight(.bold)
            } else {
                Text("🚀")
            }

        }
        .padding()
    }

    private func fetchData() async {
        guard let url = URL(string: "https://itsthisforthat.com/api.php?json") else {
            print("URL didn't work.")
            return
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            idea = try JSONDecoder().decode(Idea.self, from: data)
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
}

#Preview {
    ContentView()
}
