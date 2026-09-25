import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/vehicle_model.dart';
import '../../providers/auth_provider.dart';
import '../../services/vehicle_service.dart';

class AddVehicleScreen extends StatefulWidget {

  final VehicleModel? vehicle;

  const AddVehicleScreen({
    super.key,
    this.vehicle,
  });


  @override
  State<AddVehicleScreen> createState() =>
  
      _AddVehicleScreenState();

      
}

class _AddVehicleScreenState
    extends State<AddVehicleScreen> {
        final makeModelController =
    TextEditingController();

final licenseController =
    TextEditingController();

String vehicleType = "CAR";

bool isElectric = false;

bool isDefault = false;

String selectedColor = "White";

bool isLoading = false;
final List<String> colors = [

  "White",

  "Black",

  "Grey",

  "Blue",

  "Red",

  "Silver",
];
final VehicleService _vehicleService = VehicleService();
@override
void initState() {
  super.initState();

  if (widget.vehicle != null) {

    makeModelController.text =
        widget.vehicle!.makeModel;

    licenseController.text =
        widget.vehicle!.licensePlate;

    vehicleType =
        widget.vehicle!.vehicleType;

    isElectric =
        widget.vehicle!.isElectric;

    selectedColor =
        widget.vehicle!.color;

    isDefault =
        widget.vehicle!.isDefault;
  }
}

Future<void> saveVehicle() async {

  try {

    setState(() {
      isLoading = true;
    });

    final token =
        Provider.of<AuthProvider>(
      context,
      listen: false,
    ).token!;

    if (widget.vehicle == null) {

  await _vehicleService.saveVehicle(
    token: token,
    vehicleType: vehicleType,
    makeModel: makeModelController.text,
    licensePlate: licenseController.text,
    isElectric: isElectric,
    color: selectedColor,
    isDefault: isDefault,
  );

} else {

  await _vehicleService.updateVehicle(
    token: token,
    vehicleId: widget.vehicle!.id,
    vehicleType: vehicleType,
    makeModel: makeModelController.text,
    licensePlate: licenseController.text,
    isElectric: isElectric,
    color: selectedColor,
    isDefault: isDefault,
  );

}


    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: Text(
      widget.vehicle == null
          ? "Vehicle added successfully"
          : "Vehicle updated successfully",
    ),
  ),
);
    Navigator.pop(
      context,
      true,
    );

  } catch (e) {

    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: Text(
          e.toString(),
        ),
      ),
    );
  }

  if (mounted) {
  setState(() {
    isLoading = false;
  });
}
}
Future<void> deleteVehicle() async {
  if (widget.vehicle == null) return;

  try {
    final token = Provider.of<AuthProvider>(
  context,
  listen: false,
).token!;

await _vehicleService.deleteVehicle(
  token: token,
  vehicleId: widget.vehicle!.id,
);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Vehicle deleted successfully"),
      ),
    );

    Navigator.pop(context, true);
  } catch (e) {
  if (!mounted) return;

  final message = e.toString().replaceFirst("Exception: ", "");

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
    ),
  );
}
}
Widget _vehicleTypeCard({
  required String title,
  required IconData icon,
  required String value,
}) {

  final selected = vehicleType == value;

  return InkWell(

    borderRadius: BorderRadius.circular(18),

    onTap: () {
      setState(() {
        vehicleType = value;
      });
    },

    child: AnimatedContainer(

      duration: const Duration(milliseconds: 180),

      height: 120,

      decoration: BoxDecoration(

        color: selected
            ? Colors.green.shade50
            : Colors.white,

        borderRadius:
            BorderRadius.circular(18),

        border: Border.all(
          color: selected
              ? Colors.green
              : Colors.grey.shade300,
          width: selected ? 2 : 1,
        ),

      ),

      child: Column(

        mainAxisAlignment:
            MainAxisAlignment.center,

        children: [

          Icon(
            icon,
            size: 42,
            color: selected
                ? Colors.green
                : Colors.black54,
          ),

          const SizedBox(height: 12),

          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: selected
                  ? Colors.green
                  : Colors.black87,
            ),
          ),

        ],
      ),
    ),
  );
} 
@override
void dispose() {
  makeModelController.dispose();
  licenseController.dispose();
  super.dispose();
}
@override
Widget build(BuildContext context) {

  return Scaffold(
    backgroundColor: const Color(0xfff8f8f8),

    appBar: AppBar(
  backgroundColor: const Color(0xfff8f8f8),
  elevation: 0,
  surfaceTintColor: Colors.transparent,

  title: Text(
    widget.vehicle == null
        ? "Add Vehicle"
        : "Edit Vehicle",
    style: const TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.bold,
    ),
  ),
),

    body: SingleChildScrollView(

      padding: const EdgeInsets.fromLTRB(
  22,
  20,
  22,
  30,
),

      child: Column(

        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          const Text(
  "Vehicle Type",
  style: TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
  ),
),

          const SizedBox(height: 18),

Row(
  children: [

    Expanded(
      child: _vehicleTypeCard(
        title: "Car",
        icon: Icons.directions_car,
        value: "CAR",
      ),
    ),

    const SizedBox(width: 14),

    Expanded(
      child: _vehicleTypeCard(
        title: "Bike",
        icon: Icons.two_wheeler,
        value: "BIKE",
      ),
    ),

  ],
),

          const SizedBox(height: 28),
          const Text(
  "Vehicle Info",
  style: TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
  ),
),

const SizedBox(height: 18),

          TextField(
  controller: makeModelController,

  decoration: InputDecoration(

    labelText: "Make & Model",

    hintText: "e.g. Tesla Model 3",

    filled: true,

    fillColor: Colors.white,

    prefixIcon: const Icon(
      Icons.directions_car_outlined,
    ),

    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: BorderSide.none,
    ),

    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: BorderSide(
        color: Colors.grey.shade300,
      ),
    ),

    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: const BorderSide(
        color: Colors.green,
        width: 2,
      ),
    ),
  ),
),

          const SizedBox(height: 18),

          TextField(
  controller: licenseController,

  textCapitalization:
      TextCapitalization.characters,

  decoration: InputDecoration(

    labelText: "License Plate",

    hintText: "ABC-1234",

    filled: true,

    fillColor: Colors.white,

    prefixIcon: const Icon(
      Icons.pin_outlined,
    ),

    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: BorderSide.none,
    ),

    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: BorderSide(
        color: Colors.grey.shade300,
      ),
    ),

    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: const BorderSide(
        color: Colors.green,
        width: 2,
      ),
    ),
  ),
),

          const SizedBox(height: 34),
const Text(
  "Options",
  style: TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
  ),
),

const SizedBox(height: 18),
          Container(
  padding: const EdgeInsets.symmetric(
    horizontal: 18,
    vertical: 14,
  ),

  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(18),
    boxShadow: const [
      BoxShadow(
        color: Colors.black12,
        blurRadius: 8,
      ),
    ],
  ),

  child: Row(
    children: [

      CircleAvatar(
        radius: 22,
        backgroundColor: Colors.green.shade50,
        child: const Icon(
          Icons.electric_car,
          color: Colors.green,
        ),
      ),

      const SizedBox(width: 16),

      const Expanded(
        child: Text(
          "Electric Vehicle",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),

      Switch(
        value: isElectric,
        onChanged: (value) {
          setState(() {
            isElectric = value;
          });
        },
      ),
    ],
  ),
),

          const SizedBox(height: 26),

          const Text(
  "Vehicle Color",
  style: TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
  ),
),

          const SizedBox(height: 16),

          Wrap(
  spacing: 14,
  runSpacing: 14,
  children: colors.map((color) {

    Color circleColor;

    switch (color) {
      case "White":
        circleColor = Colors.white;
        break;

      case "Black":
        circleColor = Colors.black;
        break;

      case "Grey":
        circleColor = Colors.grey;
        break;

      case "Blue":
        circleColor = Colors.blue;
        break;

      case "Red":
        circleColor = Colors.red;
        break;

      default:
        circleColor = Colors.grey.shade400;
    }

    return GestureDetector(

      onTap: () {

        setState(() {
          selectedColor = color;
        });

      },

      child: AnimatedContainer(
  duration: const Duration(milliseconds: 180),
  child: selectedColor == color
    ? Icon(
        Icons.check,
        color: color == "White"
            ? Colors.black
            : Colors.white,
        size: 22,
      )
    : null,
       width: 46,
height: 46,

        decoration: BoxDecoration(
  color: circleColor,
  shape: BoxShape.circle,

  border: Border.all(
    color: selectedColor == color
        ? Colors.green
        : color == "White"
            ? Colors.grey.shade300
            : Colors.transparent,
    width: selectedColor == color ? 3 : 1.5,
  ),

  boxShadow: [
    BoxShadow(
      color: Colors.black.withOpacity(.06),
      blurRadius: 6,
    ),
  ],
),
      ),
    );

  }).toList(),
),

const SizedBox(height: 28),

Container(
  padding: const EdgeInsets.symmetric(
    horizontal: 18,
    vertical: 14,
  ),

  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(18),
    boxShadow: const [
      BoxShadow(
        color: Colors.black12,
        blurRadius: 8,
      ),
    ],
  ),

  child: Row(
    children: [

      CircleAvatar(
        radius: 22,
        backgroundColor: Colors.blue.shade50,
        child: const Icon(
          Icons.star,
          color: Colors.blue,
        ),
      ),

      const SizedBox(width: 16),

      const Expanded(
        child: Text(
          "Set as Default Vehicle",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),

      Switch(
        value: isDefault,
        onChanged: (value) {
          setState(() {
            isDefault = value;
          });
        },
      ),
    ],
  ),
),

const SizedBox(height: 38),

SizedBox(

  width: double.infinity,
  height: 56,

  child: ElevatedButton(

    style: ElevatedButton.styleFrom(

      backgroundColor: Colors.green,

      elevation: 0,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),

    ),

    onPressed:
        isLoading
            ? null
            : saveVehicle,

    child: isLoading
        ? const SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: Colors.white,
            ),
          )
        : Text(

            widget.vehicle == null
                ? "Add Vehicle"
                : "Update Vehicle",

            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
  ),
),
if (widget.vehicle != null) ...[
  const SizedBox(height: 16),

  SizedBox(
    width: double.infinity,
    child: OutlinedButton.icon(
      onPressed: () async {
  final shouldDelete = await showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(

  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(22),
  ),
        title: Row(
  children: const [

    Icon(
      Icons.delete_outline,
      color: Colors.red,
    ),

    SizedBox(width: 10),

    Text("Delete Vehicle"),

  ],
),
        content: const Text(
          "Are you sure you want to delete this vehicle?\n\n"
          "This action cannot be undone.",
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text("Delete"),
          ),
        ],
      );
    },
  );

  if (shouldDelete == true) {
    await deleteVehicle();
  }
},
      style: OutlinedButton.styleFrom(

  foregroundColor: Colors.red,

  minimumSize: const Size(
    double.infinity,
    54,
  ),

  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(18),
  ),

  side: BorderSide(
    color: Colors.red.shade200,
  ),
),
      icon: const Icon(
  Icons.delete_outline,
),

label: const Text(
  "Delete Vehicle",
),
    ),
  ),
]
          // We'll continue from here in the next step

        ],
      ),
    ),
  );
}
    }