import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/enums/vehicle_list_mode.dart';
import '../../models/vehicle_model.dart';
import '../../providers/auth_provider.dart';
import '../../services/vehicle_service.dart';
import 'add_vehicle_screen.dart';
import '../../core/theme/app_colors.dart';
class VehicleListScreen extends StatefulWidget {

  final VehicleListMode mode;

  final int? selectedVehicleId;

  const VehicleListScreen({
    super.key,
    required this.mode,
    this.selectedVehicleId,
  });

  @override
  State<VehicleListScreen> createState() =>
      _VehicleListScreenState();
}

class _VehicleListScreenState
    extends State<VehicleListScreen> {

  List<VehicleModel> vehicles = [];

  bool isLoading = true;
  Future<void> loadVehicles() async {

  try {

    final token =
        Provider.of<AuthProvider>(
      context,
      listen: false,
    ).token!;

    final response =
        await VehicleService()
            .getMyVehicles(
      token,
    );

    final data =
        response.data as List;

    setState(() {

      vehicles = data
    .map(
      (e) => VehicleModel.fromJson(e),
    )
    .toList();

if (widget.mode == VehicleListMode.selection) {
  vehicles.sort((a, b) {
    if (a.isDefault == b.isDefault) {
      return 0;
    }
    return a.isDefault ? -1 : 1;
  });
}

      isLoading = false;
    });

  } catch (e) {

    setState(() {
      isLoading = false;
    });

  }
}
Future<void> setDefaultVehicle(
  VehicleModel vehicle,
) async {
  try {
    final token = Provider.of<AuthProvider>(
      context,
      listen: false,
    ).token!;

    await VehicleService().updateVehicle(
      token: token,
      vehicleId: vehicle.id,
      vehicleType: vehicle.vehicleType,
      makeModel: vehicle.makeModel,
      licensePlate: vehicle.licensePlate,
      isElectric: vehicle.isElectric,
      color: vehicle.color,
      isDefault: true,
    );
    
    if (!mounted) return;

setState(() {

  vehicles = vehicles.map((v) {

    return VehicleModel(
      id: v.id,
      userId: v.userId,
      vehicleType: v.vehicleType,
      makeModel: v.makeModel,
      licensePlate: v.licensePlate,
      isElectric: v.isElectric,
      color: v.color,

      // Only this changes
      isDefault: v.id == vehicle.id,
    );

  }).toList();

});

ScaffoldMessenger.of(context).showSnackBar(
  const SnackBar(
    content: Text("Default vehicle updated"),
  ),
);
  } catch (e) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          e.toString().replaceFirst(
            "Exception: ",
            "",
          ),
        ),
      ),
    );
  }
}
@override
void initState() {
  super.initState();

  loadVehicles();
}
@override
Widget build(BuildContext context) {

  if (isLoading) {

    return const Scaffold(
      body: Center(
        child:
            CircularProgressIndicator(),
      ),
    );
  }

  return Scaffold(
      backgroundColor: const Color(0xfff8f8f8),
    appBar: AppBar(
  elevation: 0,
  toolbarHeight: 72,
  titleSpacing: 20,
  title: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [

      Text(
        widget.mode == VehicleListMode.selection
            ? "Select Vehicle"
            : "My Vehicles",
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),

      if (widget.mode == VehicleListMode.management)
        const SizedBox(height: 2),

      if (widget.mode == VehicleListMode.management)
        Text(
          "Manage your registered vehicles",
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),

    ],
  ),
),

    body: ListView.builder(

  padding: const EdgeInsets.all(18),

  itemCount: vehicles.length,

  itemBuilder: (context, index) {

    final vehicle = vehicles[index];

    return Card(
  elevation: 0,
  color: Colors.white,
  margin: const EdgeInsets.only(bottom: 18),
  shadowColor: Colors.black12,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(22),
    side: BorderSide(
      color: vehicle.id == widget.selectedVehicleId
          ? AppColors.primary
          : Colors.grey.shade100,
      width: vehicle.id == widget.selectedVehicleId ? 2 : 1,
    ),
  ),
  child: InkWell(
  borderRadius: BorderRadius.circular(18),
  onTap: () async {

    if (widget.mode ==
        VehicleListMode.selection) {

      Navigator.pop(
        context,
        vehicle,
      );

    } else {

      final updated =
          await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              AddVehicleScreen(
            vehicle: vehicle,
          ),
        ),
      );

      if (updated == true) {
        loadVehicles();
      }

    }

  },

  child: Padding(
    padding: const EdgeInsets.all(18),

    child: Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,

      children: [

        Row(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            Container(
              width: 54,
              height: 54,

              decoration: BoxDecoration(
                color: const Color(0xffE8F5E9),
                borderRadius:
                    BorderRadius.circular(14),
              ),

              child: Icon(
  vehicle.vehicleType == "CAR"
      ? Icons.directions_car
      : Icons.two_wheeler,
                color: AppColors.primary,
                size: 30,
              ),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  Text(
                    vehicle.makeModel,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    vehicle.licensePlate,
                    style: TextStyle(
                      color:
                          Colors.grey.shade600,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

          

          ],
        ),

        const SizedBox(height: 18),

        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [

            _chip(
  vehicle.vehicleType == "CAR"
      ? "Car"
      : "Bike",
),

            _chip(
              vehicle.isElectric
                  ? "Electric"
                  : "Petrol",
              icon: Icons.bolt,
            ),

            _chip(vehicle.color),

          ],
        ),

        const SizedBox(height: 18),

        Divider(
          color: Colors.grey.shade200,
        ),

        const SizedBox(height: 14),

        SizedBox(
  height: 46,
  child: OutlinedButton.icon(
    onPressed: vehicle.isDefault
        ? null
        : () async {
            await setDefaultVehicle(vehicle);
          },
    
    label: Text(
      vehicle.isDefault
          ? "Default"
          : "Set as Default",
      style: TextStyle(
        fontWeight: FontWeight.w600,
        color: vehicle.isDefault
            ? Colors.white
            : Colors.black87,
      ),
    ),
    style: OutlinedButton.styleFrom(
      elevation: 0,
      disabledBackgroundColor:
          const Color(0xff0A7A34),
      disabledForegroundColor:
          Colors.white,
      backgroundColor: vehicle.isDefault
          ? const Color(0xff0A7A34)
          : Colors.white,
      side: BorderSide(
        color: vehicle.isDefault
            ? const Color(0xff0A7A34)
            : Colors.grey.shade300,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
    ),
  ),
),

      ],
    ),
  ),
),
    );
  },
),
floatingActionButton: FloatingActionButton.extended(
  elevation: 4,
  backgroundColor: const Color(0xff0A7A34),
  icon: const Icon(
    Icons.add,
    color: Colors.white,
  ),
  label: const Text(
    "ADD VEHICLE",
    style: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      letterSpacing: 0.3,
    ),
  ),
  onPressed: () async {

    final created =
        await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            const AddVehicleScreen(),
      ),
    );

    if (created == true) {
      loadVehicles();
    }

  },
),
  );
}
Widget _chip(
  String text, {
  IconData? icon,
}) {

  return Container(

    padding: const EdgeInsets.symmetric(
      horizontal: 10,
      vertical: 6,
    ),

    decoration: BoxDecoration(

      color: const Color(0xffF3F5FA),

      borderRadius:
          BorderRadius.circular(30),

    ),

    child: Row(

      mainAxisSize:
          MainAxisSize.min,

      children: [

        if (icon != null) ...[
          Icon(
            icon,
            size: 14,
            color: AppColors.primary,
          ),
          const SizedBox(width: 4),
        ],

        Text(
  text,
  style: TextStyle(
    color: Colors.grey.shade700,
    fontSize: 12,
    fontWeight: FontWeight.w600,
  ),
         
        ),

      ],
    ),
  );
}
    }