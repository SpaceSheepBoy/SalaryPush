import Foundation
import Combine

/// Fetches and caches exchange rates from a free API
final class ExchangeRateService: ObservableObject {
    @Published var rates: [String: Double] = [:]
    @Published var lastUpdated: Date?
    @Published var isLoading: Bool = false
    @Published var error: String?

    private var cancellables = Set<AnyCancellable>()
    private let cacheKey = "cachedExchangeRates"
    private let cacheTimestampKey = "cachedExchangeRatesTimestamp"

    init() {
        loadCachedRates()
    }

    // MARK: - Public API

    /// Get the exchange rate from one currency to another
    func rate(from: String, to: String) -> Double {
        if from == to { return 1.0 }

        // All rates are relative to USD
        guard let fromRate = rates[from], fromRate > 0,
              let toRate = rates[to] else {
            return 1.0 // Fallback: no conversion
        }

        return toRate / fromRate
    }

    /// Fetch latest rates
    func fetchRates() {
        guard !isLoading else { return }
        isLoading = true
        error = nil

        guard let url = URL(string: "https://api.exchangerate-api.com/v4/latest/USD") else {
            isLoading = false
            error = "Invalid URL"
            return
        }

        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: ExchangeRateResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    if case .failure(let err) = completion {
                        self?.error = err.localizedDescription
                    }
                },
                receiveValue: { [weak self] response in
                    self?.rates = response.rates
                    self?.lastUpdated = Date()
                    self?.cacheRates(response.rates)
                }
            )
            .store(in: &cancellables)
    }

    /// Start periodic refresh (every hour)
    func startPeriodicRefresh() {
        fetchRates()
        Timer.publish(every: 3600, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.fetchRates()
            }
            .store(in: &cancellables)
    }

    // MARK: - Cache

    private func cacheRates(_ rates: [String: Double]) {
        if let data = try? JSONEncoder().encode(rates) {
            UserDefaults.standard.set(data, forKey: cacheKey)
            UserDefaults.standard.set(Date().timeIntervalSince1970, forKey: cacheTimestampKey)
        }
    }

    private func loadCachedRates() {
        if let data = UserDefaults.standard.data(forKey: cacheKey),
           let cached = try? JSONDecoder().decode([String: Double].self, from: data) {
            rates = cached
            let timestamp = UserDefaults.standard.double(forKey: cacheTimestampKey)
            if timestamp > 0 {
                lastUpdated = Date(timeIntervalSince1970: timestamp)
            }
        }
    }
}

// MARK: - API Response
private struct ExchangeRateResponse: Decodable {
    let rates: [String: Double]
}
