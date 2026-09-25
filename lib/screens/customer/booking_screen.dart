import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/constants/api_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/common/pf_network_image.dart';
import '../../models/listing_model.dart';
import '../../providers/auth_provider.dart';
import '../../services/booking_service.dart';
import 'package:intl/intl.dart';
import '../../models/vehicle_model.dart';
import 'vehicle_list_screen.dart';
import '../../services/vehicle_service.dart';
import '../../core/enums/vehicle_list_mode.dart';
class BookingScreen extends StatefulWidget {
  final ListingModel listing;

  const BookingScreen({
    super.key,
    required this.listing,
  });

  @override
  State<BookingScreen> createState() =>
      _BookingScreenState();
}

class _BookingScreenState
    extends State<BookingScreen> {

  DateTime? startTime;
  DateTime? endTime;

  bool isLoading = false;
  VehicleModel? selectedVehicle;
  @override
void initState() {
  super.initState();

  loadDefaultVehicle();
}
  Future<void> createBooking() async {

    if (selectedVehicle == null ||
    startTime == null ||
    endTime == null) {

  ScaffoldMessenger.of(context)
      .showSnackBar(
    const SnackBar(
      content: Text(
        "Please select a vehicle.",
      ),
    ),
  );

  return;
}

    try {
      setState(() {
        isLoading = true;
      });

      final token =
          Provider.of<AuthProvider>(
        context,
        listen: false,
      ).token!;
      print("TOKEN: $token");

      await BookingService()
    .createBooking(
  token: token,
  listingId: widget.listing.id,
  vehicleId: selectedVehicle!.id,
  startTime: startTime!,
  endTime: endTime!,
);

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            "Booking Created",
          ),
        ),
      );

      Navigator.pop(context);

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

    setState(() {
      isLoading = false;
    });
  }
  Future<void> loadDefaultVehicle() async {

  final token =
      Provider.of<AuthProvider>(
    context,
    listen: false,
  ).token!;

  final response =
      await VehicleService()
          .getMyVehicles(token);

  final data =
      response.data as List;

  final vehicles =
      data
          .map(
            (e) =>
                VehicleModel.fromJson(e),
          )
          .toList();

  if (vehicles.isEmpty) return;

  setState(() {

    selectedVehicle =
        vehicles.firstWhere(
      (v) => v.isDefault,
      orElse: () => vehicles.first,
    );

  });
}
  Future<void> openMaps() async {

  final url = Uri.parse(
    "https://www.google.com/maps/search/?api=1"
    "&query=${widget.listing.latitude},${widget.listing.longitude}",
  );

  if (await canLaunchUrl(url)) {
    await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    );
  }
}
  Future<void> pickStartTime() async {

  final date = await showDatePicker(
    context: context,
    firstDate: DateTime.now(),
    lastDate: DateTime(2030),
    initialDate: DateTime.now(),
  );

  if (date == null) return;

  final time = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.now(),
  );

  if (time == null) return;

  setState(() {

    startTime = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );

    // Reset exit if it becomes invalid
    if (endTime != null &&
        endTime!.isBefore(startTime!)) {
      endTime = null;
    }
  });
}

 Future<void> pickEndTime() async {

  if (startTime == null) {

    ScaffoldMessenger.of(context).showSnackBar(

      const SnackBar(
        content: Text(
          "Please select entry time first.",
        ),
      ),
    );

    return;
  }

  final date = await showDatePicker(
    context: context,
    firstDate: startTime!,
    lastDate: DateTime(2030),
    initialDate: startTime!,
  );

  if (date == null) return;

  final time = await showTimePicker(
    context: context,
    initialTime: TimeOfDay(
      hour: startTime!.hour + 1,
      minute: startTime!.minute,
    ),
  );

  if (time == null) return;

  final selected = DateTime(
    date.year,
    date.month,
    date.day,
    time.hour,
    time.minute,
  );

  if (!selected.isAfter(startTime!)) {

    ScaffoldMessenger.of(context).showSnackBar(

      const SnackBar(
        content: Text(
          "Exit time must be after entry time.",
        ),
      ),
    );

    return;
  }

  setState(() {

    endTime = selected;

  });
}
double get totalPrice {

  if (startTime == null || endTime == null) {
    return 0;
  }

  final minutes =
      endTime!.difference(startTime!).inMinutes;

  final hours = minutes / 60.0;

  return hours *
      widget.listing.hourlyRate;
}

@override
Widget build(BuildContext context) {

  return Scaffold(

    backgroundColor: const Color(0xfff8f8f8),

    body: Stack(

      children: [

        SingleChildScrollView(

          padding: const EdgeInsets.only(
            bottom: 110,
          ),

          child: Column(

            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [

              //---------------- HERO IMAGE ----------------//

              Stack(

                children: [

                  ClipRRect(

                    borderRadius:
                        const BorderRadius.only(
                      bottomLeft:
                          Radius.circular(28),
                      bottomRight:
                          Radius.circular(28),
                    ),

                    child: PFNetworkImage(

                      imageUrl:
                          widget.listing.imageUrl == null
                              ? null
                              : ApiConstants.baseUrl +
                                  widget.listing.imageUrl!,

                      width: double.infinity,

                      height: 290,
                    ),
                  ),

                  Positioned(

                    top: 48,
                    left: 20,

                    child: CircleAvatar(

                      backgroundColor: Colors.white,

                      child: IconButton(

                        icon:
                            const Icon(Icons.arrow_back),

                        onPressed: () {

                          Navigator.pop(context);

                        },
                      ),
                    ),
                  ),

                  Positioned(

                    top: 48,
                    right: 20,

                    child: CircleAvatar(

                      backgroundColor: Colors.white,

                      child: IconButton(

                        icon: const Icon(
                          Icons.favorite_border,
                          color: Colors.red,
                        ),

                        onPressed: () {},
                      ),
                    ),
                  ),
                ],
              ),

              //---------------- INFO ----------------//

              Padding(

                padding:
                    const EdgeInsets.all(22),

                child: Column(

                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [

                    Text(

                      widget.listing.title,

                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Row(

                      children: [

                        const Icon(
                          Icons.location_on_outlined,
                          color: Colors.grey,
                          size: 18,
                        ),

                        const SizedBox(width: 5),

                        Expanded(

                          child: Text(

                            widget.listing.address,

                            style:
                                const TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 25),

                    Row(

                      children: [

                        Container(

                          padding:
                              const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),

                          decoration: BoxDecoration(

                            color:
                                Colors.green.shade50,

                            borderRadius:
                                BorderRadius.circular(
                              30,
                            ),
                          ),

                          child: Text(

                            "${widget.listing.availableSpaces} Spots Left",

                            style:
                                const TextStyle(
                              color: Colors.green,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                        ),

                        const Spacer(),

                        Text(

                          "₹${widget.listing.hourlyRate.toInt()}",

                          style:
                              const TextStyle(

                            fontSize: 32,

                            color:
                                AppColors.primary,

                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),

                        const Text(

                          "/hr",

                          style: TextStyle(

                            color: Colors.grey,

                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 36),

const Text(
  "Schedule",
  style: TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
  ),
),

const SizedBox(height: 18),

Row(
  children: [

    Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: pickStartTime,

        child: Container(
          padding: const EdgeInsets.all(18),

          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
                BorderRadius.circular(18),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
              ),
            ],
          ),

          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [

              Row(
                children: const [

                  Icon(
                    Icons.login,
                    color: Colors.green,
                    size: 18,
                  ),

                  SizedBox(width: 8),

                  Text(
                    "Entry",
                    style: TextStyle(
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              Text(
                startTime == null
                    ? "--:--"
                    : TimeOfDay.fromDateTime(
                            startTime!)
                        .format(context),

                style: const TextStyle(
                  fontSize: 22,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                startTime == null
                    ? "Select Date"
                    : "${startTime!.day}/${startTime!.month}/${startTime!.year}",

                style: const TextStyle(
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 14),

const Row(
  children: [

    Icon(
      Icons.edit_calendar,
      size: 16,
      color: AppColors.primary,
    ),

    SizedBox(width: 6),

    Text(
      "Tap to change",
      style: TextStyle(
        color: AppColors.primary,
        fontSize: 13,
      ),
    ),
  ],
),
            ],
          ),
        ),
      ),
    ),

    const SizedBox(width: 14),

    Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: pickEndTime,

        child: Container(
          padding: const EdgeInsets.all(18),

          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
                BorderRadius.circular(18),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
              ),
            ],
          ),

          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [

              Row(
                children: const [

                  Icon(
                    Icons.logout,
                    color: Colors.red,
                    size: 18,
                  ),

                  SizedBox(width: 8),

                  Text(
                    "Exit",
                    style: TextStyle(
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              Text(
                endTime == null
                    ? "--:--"
                    : TimeOfDay.fromDateTime(
                            endTime!)
                        .format(context),

                style: const TextStyle(
                  fontSize: 22,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                endTime == null
                    ? "Select Date"
                    : "${endTime!.day}/${endTime!.month}/${endTime!.year}",

                style: const TextStyle(
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 14),

const Row(
  children: [

    Icon(
      Icons.edit_calendar,
      size: 16,
      color: AppColors.primary,
    ),

    SizedBox(width: 6),

    Text(
      "Tap to change",
      style: TextStyle(
        color: AppColors.primary,
        fontSize: 13,
      ),
    ),
  ],
),
            ],
          ),
        ),
      ),
    ),
  ],
),

const SizedBox(height: 16),

Container(
  padding: const EdgeInsets.all(16),

  decoration: BoxDecoration(
    color: Colors.blue.shade50,
    borderRadius:
        BorderRadius.circular(18),
  ),

  child: const Row(
    crossAxisAlignment:
        CrossAxisAlignment.start,

    children: [

      Icon(
        Icons.info_outline,
        color: Colors.blue,
      ),

      SizedBox(width: 12),

      Expanded(
        child: Text(
          "Includes a 15-minute grace period for arrival.",
          style: TextStyle(
            height: 1.4,
          ),
        ),
      ),
    ],
  ),
),
const SizedBox(height: 28),
const Text(
  "Vehicle",
  style: TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
  ),
),

const SizedBox(height: 14),
InkWell(

  borderRadius:
      BorderRadius.circular(20),

  onTap: () async {

    final vehicle =
        await Navigator.push<VehicleModel>(
      context,
      MaterialPageRoute(
        builder: (_) =>
            VehicleListScreen(
  mode: VehicleListMode.selection,
  selectedVehicleId: selectedVehicle?.id,
)
      ),
    );

    if (vehicle != null) {

      setState(() {
        selectedVehicle = vehicle;
      });

    }

  },

  child: Container(
  padding: const EdgeInsets.all(18),

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

    Icon(
      selectedVehicle?.vehicleType == "CAR"
          ? Icons.directions_car
          : Icons.two_wheeler,
      size: 34,
      color: AppColors.primary,
    ),

    const SizedBox(width: 16),

    Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [

        Text(
          selectedVehicle?.makeModel ??
              "No Vehicle",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),

        const SizedBox(height: 4),

        Text(
          selectedVehicle?.licensePlate ??
              "",
          style: const TextStyle(
            color: Colors.grey,
          ),
        ),
      ],
    ),
    const Spacer(),

const Icon(
  Icons.chevron_right,
  color: Colors.grey,
),
  ],
),
),
),
const SizedBox(height: 28),

const Text(
  "Entry Instructions",
  style: TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
  ),
),

const SizedBox(height: 14),

Container(
  padding: const EdgeInsets.all(18),

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

  child: const Column(
    crossAxisAlignment:
        CrossAxisAlignment.start,

    children: [

      Row(
        children: [

          Icon(
            Icons.qr_code_scanner,
            color: AppColors.primary,
          ),

          SizedBox(width: 12),

          Expanded(
            child: Text(
              "Scan the QR code when you arrive.",
            ),
          ),
        ],
      ),

      SizedBox(height: 16),

      Row(
        children: [

          Icon(
            Icons.exit_to_app,
            color: AppColors.primary,
          ),

          SizedBox(width: 12),

          Expanded(
            child: Text(
              "Scan again while exiting to complete your booking.",
            ),
          ),
        ],
      ),
    ],
  ),
),
                  ],
                ),
              ),
            ],
          ),
        ),

        //---------------- BOTTOM BAR ----------------//

        Align(

          alignment: Alignment.bottomCenter,

          child: SafeArea(

            child: Container(

              padding:
                  const EdgeInsets.all(18),

              decoration:
                  const BoxDecoration(
                color: Colors.white,
              ),

              child:Row(

  children: [

    Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  mainAxisSize: MainAxisSize.min,
  children: [

    Text(
      "₹${totalPrice.toStringAsFixed(0)}",
      style: const TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
      ),
    ),

    if (startTime != null && endTime != null)
      Text(
        "${endTime!.difference(startTime!).inHours} hr × ₹${widget.listing.hourlyRate.toInt()}",
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 13,
        ),
      )
    else
      const Text(
        "Select schedule",
        style: TextStyle(
          color: Colors.grey,
          fontSize: 13,
        ),
      ),
  ],
),
    const SizedBox(width: 18),

    Expanded(

      child: SizedBox(

        height: 56,

        child: ElevatedButton(

          style:
              ElevatedButton.styleFrom(

            backgroundColor:
                AppColors.primary,

            shape:
                RoundedRectangleBorder(

              borderRadius:
                  BorderRadius.circular(
                16,
              ),
            ),
          ),

          onPressed:
    isLoading ||
            startTime == null ||
            endTime == null
        ? null
        : createBooking,

          child:
              isLoading
                  ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                  : const Text(

                      "Confirm Booking",

                      style: TextStyle(

                        fontSize: 18,

                        color: Colors.white,

                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
        ),
      ),
    ),
  ],
),
            ),
          ),
        ),
      ],
    ),
  );
}
}