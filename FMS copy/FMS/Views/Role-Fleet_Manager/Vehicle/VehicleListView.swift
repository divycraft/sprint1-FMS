import SwiftUI

struct VehicleListView: View {
    @StateObject private var vehicleViewModel = VehicleViewModel()
    @State private var showAddEditVehicle = false
    @State private var selectedVehicle: Vehicle?
    @State private var showingDeleteAlert = false
    @State private var vehicleToDelete: Vehicle?
    
    var body: some View {
        NavigationView {
            List {
                ForEach(vehicleViewModel.vehicles) { vehicle in
                    VehicleCard(vehicle: vehicle)
                        .environmentObject(vehicleViewModel) // Pass environment object
                        .onTapGesture {
                            selectedVehicle = vehicle
                            showAddEditVehicle = true
                        }
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                vehicleToDelete = vehicle
                                showingDeleteAlert = true
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                }
                .onDelete(perform: deleteVehicleAt)
            }
            .navigationTitle("Vehicles")
            .navigationBarItems(trailing: Button(action: {
                selectedVehicle = nil
                showAddEditVehicle = true
            }) {
                Image(systemName: "plus")
            })
            .sheet(isPresented: $showAddEditVehicle) {
                AddEditVehicleView(vehicle: selectedVehicle)
                    .environmentObject(vehicleViewModel)
            }
            .alert("Are you sure you want to delete this vehicle?", isPresented: $showingDeleteAlert) {
                Button("Cancel", role: .cancel) {}
                Button("Delete", role: .destructive) {
                    if let vehicle = vehicleToDelete {
                        deleteVehicle(vehicle)
                    }
                }
            }
        }
    }
    
    private func deleteVehicle(_ vehicle: Vehicle) {
        if let index = vehicleViewModel.vehicles.firstIndex(where: { $0.id == vehicle.id }) {
            vehicleViewModel.vehicles.remove(at: index)
        }
    }
    
    private func deleteVehicleAt(offsets: IndexSet) {
        offsets.map { vehicleViewModel.vehicles[$0] }.forEach(deleteVehicle)
    }
}

// MARK: - Vehicle Card View
struct VehicleCard: View {
    var vehicle: Vehicle
    @EnvironmentObject var vehicleViewModel: VehicleViewModel // Add environment object
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading) {
                    Text(vehicle.vehicleName)
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                    
                    Text(vehicle.vin)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                Text(vehicle.status)
                    .font(.footnote)
                    .fontWeight(.semibold)
                    .padding(.vertical, 6)
                    .padding(.horizontal, 12)
                    .background(Color.green.opacity(0.2))
                    .foregroundColor(.green)
                    .cornerRadius(10)
            }
            
            Divider()
            
            HStack {
                Image(systemName: "calendar.badge.clock")
                    .foregroundColor(.gray)
                Text("Year Purchased: \(String(vehicle.year))")
                    .font(.subheadline)
                    .foregroundColor(.black)
            }
            
            HStack {
                Image(systemName: "mappin.and.ellipse")
                    .foregroundColor(.gray)
                Text("Total Trips: \(vehicle.totalTrips)")
                    .font(.subheadline)
                    .foregroundColor(.black)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.black, lineWidth: 0.5)
                .background(Color.white)
                .cornerRadius(12)
        )
    }
}

struct VehicleListView_Previews: PreviewProvider {
    static var previews: some View {
        VehicleListView()
    }
}
