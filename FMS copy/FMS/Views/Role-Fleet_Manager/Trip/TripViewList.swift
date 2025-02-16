import SwiftUI

struct TripListView: View {
    @StateObject var viewModel = TripViewModel()
    @State private var showingAddTrip = false
    @State private var editingTrip: Trip? = nil
    @State private var showingDeleteAlert = false
    @State private var tripToDelete: Trip? = nil

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.trips) { trip in
                    TripsCardView(trip: trip)
                        .onTapGesture {
                            editingTrip = trip
                        }
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                tripToDelete = trip
                                showingDeleteAlert = true
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                }
            }
            .navigationTitle("Trips")
            .toolbar {
                Button(action: { showingAddTrip = true }) {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $showingAddTrip) {
                NavigationView {
                    AddEditTripView(viewModel: viewModel, trip: nil)
                }
            }
            .sheet(item: $editingTrip) { trip in
                NavigationView {
                    AddEditTripView(viewModel: viewModel, trip: trip)
                }
            }
            .alert("Are you sure you want to delete this trip?", isPresented: $showingDeleteAlert) {
                Button("Cancel", role: .cancel) {}
                Button("Delete", role: .destructive) {
                    if let trip = tripToDelete {
                        deleteTrip(trip)
                    }
                }
            }
        }
    }
    
    private func deleteTrip(_ trip: Trip) {
        if let index = viewModel.trips.firstIndex(where: { $0.id == trip.id }) {
            viewModel.trips.remove(at: index)
        }
    }
}

struct TripsCardView: View {
    let trip: Trip
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(trip.startLocation)
                    .font(.headline)
                    .bold()
                
                Text("───")
                    .foregroundColor(.blue)
                
                Text(trip.endLocation)
                    .font(.headline)
                    .bold()
                Spacer()
                
                Text(trip.distance)
                    .font(.caption)
                    .padding(6)
                    .background( Color.green.opacity(0.3))
                    .cornerRadius(8)
            }
            
            Text("Start Date: \(trip.startDate, formatter: dateFormatter)")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            Text("Distance: \(trip.distance) km, ETA: \(trip.eta) hrs")
                .font(.subheadline)
                .foregroundColor(.blue)
                .underline()
            
            Text("Type: \(trip.vehicleType)")
                .font(.subheadline)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 2)
    }
}

struct TripListView_Preview: PreviewProvider {
    static var previews: some View {
        TripListView()
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    return formatter
}()
