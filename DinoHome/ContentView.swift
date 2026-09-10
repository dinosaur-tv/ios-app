import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var model: DinoHomeWebModel
    @AppStorage("dinoServer") private var server = ""
    @State private var editingServer = false
    @State private var serverInput = ""

    var body: some View {
        ZStack {
            Color.dinoInk.ignoresSafeArea()
            DinoHomeWebView(model: model)
                .opacity(model.isLoading ? 0 : 1)
                .ignoresSafeArea(.container, edges: .bottom)

            if model.isLoading {
                VStack(spacing: 14) {
                    Text("DINO TV")
                        .font(.system(size: 11, weight: .bold, design: .rounded))
                        .tracking(3)
                        .foregroundStyle(Color.dinoBrass)
                    ProgressView()
                        .tint(Color.dinoPaper)
                    Text("Домашняя консоль")
                        .font(.system(size: 16, design: .serif))
                        .foregroundStyle(Color.dinoPaper)
                }
            }

            if model.showOfflineOverlay {
                VStack(spacing: 16) {
                    Text("Нет соединения")
                        .font(.system(size: 28, design: .serif))
                    Text("Проверьте интернет и попробуйте ещё раз.")
                        .multilineTextAlignment(.center)
                        .foregroundStyle(Color.dinoMuted)
                    Button("Повторить") { model.reload() }
                        .buttonStyle(.borderedProminent)
                        .tint(Color.dinoBrass)
                }
                .padding(32)
                .background(Color.dinoPanel)
            }
        }
        .animation(.easeOut(duration: 0.22), value: model.isLoading)
        .animation(.easeOut(duration: 0.22), value: model.showOfflineOverlay)
        .overlay(alignment: .topTrailing) {
            Button("Сервер") { serverInput = server; editingServer = true }
                .padding(12)
                .foregroundStyle(Color.dinoBrass)
        }
        .onAppear {
            if DinoHomeLinks.serverURL(server) == nil { editingServer = true }
        }
        .sheet(isPresented: $editingServer) {
            NavigationStack {
                Form {
                    Section("Ваш сервер Dino TV") {
                        TextField("https://home.example.com", text: $serverInput)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                            .keyboardType(.URL)
                        Text(
                            "Дом создаётся в Telegram-боте. Телевизор привязывается кодом с экрана, "
                            + "телефон — одноразовым кодом из консоли."
                        )
                    }
                    Button("Подключиться") {
                        guard let url = DinoHomeLinks.serverURL(serverInput) else { return }
                        server = url.absoluteString
                        model.open(url)
                        editingServer = false
                    }
                    .disabled(DinoHomeLinks.serverURL(serverInput) == nil)
                }
                .navigationTitle("Подключение")
            }
        }
    }
}

extension Color {
    static let dinoInk = Color(red: 23 / 255, green: 22 / 255, blue: 20 / 255)
    static let dinoPanel = Color(red: 33 / 255, green: 30 / 255, blue: 26 / 255)
    static let dinoPaper = Color(red: 239 / 255, green: 230 / 255, blue: 215 / 255)
    static let dinoBrass = Color(red: 178 / 255, green: 140 / 255, blue: 84 / 255)
    static let dinoMuted = Color(red: 170 / 255, green: 160 / 255, blue: 146 / 255)
}
