import SwiftUI

struct DriverListView: View {
    @StateObject private var viewModel = DriverViewModel()
    @State private var showingAddDriver = false
    @State private var selectedDriver: Driver? = nil
    @State private var showingDeleteAlert = false
    @State private var driverToDelete: Driver? = nil

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text("Drivers")
                    .font(.largeTitle)
                    .bold()
                    .padding(.horizontal)
                    .padding(.top, 10)

                HStack(spacing: 15) {
                    DriverStatusView(title: "Available", count: viewModel.drivers.count)
                    DriverStatusView(title: "On Leave", count: 5)
                }
                .padding(.horizontal)

                List {
                    ForEach(viewModel.drivers) { driver in
                        DriverCardView(driver: driver)
                            .onTapGesture {
                                selectedDriver = driver
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    showingAddDriver = true
                                }
                            }
                            .swipeActions(edge: .trailing) {
                                Button(role: .destructive) {
                                    driverToDelete = driver
                                    showingDeleteAlert = true
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                    }
                }
            }
            .toolbar {
                Button(action: {
                    selectedDriver = nil
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        showingAddDriver = true
                    }
                }) {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $showingAddDriver) {
                NavigationView {
                    AddEditDriverView(
                        viewModel: viewModel,
                        driver: selectedDriver
                    )
                }
            }
            .alert("Are you sure you want to delete this driver?", isPresented: $showingDeleteAlert) {
                Button("Cancel", role: .cancel) {}
                Button("Delete", role: .destructive) {
                    if let driver = driverToDelete {
                        deleteDriver(driver)
                    }
                }
            }
        }
    }
    
    private func deleteDriver(_ driver: Driver) {
        if let index = viewModel.drivers.firstIndex(where: { $0.id == driver.id }) {
            viewModel.drivers.remove(at: index)
        }
    }
}

struct DriverListView_Previews: PreviewProvider {
    static var previews: some View {
        DriverListView()
    }
}
