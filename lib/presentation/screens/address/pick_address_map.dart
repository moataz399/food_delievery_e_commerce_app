import 'package:flutter/material.dart';
import 'package:food_delievery_app/base/custom_button.dart';
import 'package:food_delievery_app/controllers/location_controller.dart';
import 'package:food_delievery_app/utils/dimensions.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../app_router.dart';
import '../../../utils/colors.dart';

class PickAddressMap extends StatefulWidget {
  final bool fromAddress;
  final bool fromSignUp;
  final GoogleMapController? googleMapController;

  const PickAddressMap(
      {Key? key,
      required this.fromAddress,
      required this.fromSignUp,
      this.googleMapController});

  @override
  State<PickAddressMap> createState() => _PickAddressMapState();
}

class _PickAddressMapState extends State<PickAddressMap> {
  late LatLng _initialPosition;
  late GoogleMapController _mapController;
  late CameraPosition _cameraPosition;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (Get.find<LocationController>().addressList.isEmpty) {
      _initialPosition = LatLng(31.417540, 31.814444);

      _cameraPosition = CameraPosition(target: _initialPosition, zoom: 12);
    } else {
      if (Get.find<LocationController>().addressList.isNotEmpty) {
        _initialPosition = LatLng(
            double.parse(Get.find<LocationController>().getAddress['latitude']),
            double.parse(
                Get.find<LocationController>().getAddress['longitude']));
        _cameraPosition = CameraPosition(target: _initialPosition, zoom: 12);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LocationController>(
      builder: (locationController) {
        return Scaffold(
          body: SafeArea(
            child: Center(
              child: SizedBox(
                  width: double.maxFinite,
                  child: Stack(
                    children: [
                      GoogleMap(
                        initialCameraPosition:
                            CameraPosition(target: _initialPosition, zoom: 12),
                        zoomControlsEnabled: false,
                        compassEnabled: false,
                        indoorViewEnabled: true,
                        mapToolbarEnabled: false,
                        myLocationEnabled: true,
                        onCameraMove: (CameraPosition position) {
                          _cameraPosition = position;
                        },
                        onCameraIdle: () {
                          Get.find<LocationController>()
                              .updatePosition(_cameraPosition, false);
                        },
                      ),
                      Center(
                          child: !locationController.isLoading
                              ? Image.asset('assets/images/marker.png')
                              : CircularProgressIndicator()),
                      Positioned(
                        top: Dimensions.height45,
                        left: Dimensions.width20,
                        right: Dimensions.width20,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: Dimensions.width10),
                          height: 50,
                          decoration: BoxDecoration(
                            color: AppColors.mainColor,
                            borderRadius:
                                BorderRadius.circular(Dimensions.radius20 / 2),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                size: 25,
                                color: AppColors.yellowColor,
                              ),
                              Expanded(
                                child: Text(
                                    "${locationController.pickPlaceMark.name ?? ""}",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: Dimensions.iconsSize16),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis),
                              )
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 80,
                        left: Dimensions.width20,
                        right: Dimensions.width20,
                        child: CustomButton(
                          buttonText: 'pick address',
                          onPressed: locationController.isLoading
                              ? null
                              : () {
                                  if (locationController
                                              .pickposition.latitude !=
                                          0 &&
                                      locationController.pickPlaceMark.name !=
                                          null) {
                                    if (widget.fromAddress) {
                                      if (widget.googleMapController != null) {
                                        print('now u can click this');

                                        widget.googleMapController!.moveCamera(
                                            CameraUpdate.newCameraPosition(
                                                CameraPosition(
                                                    target: LatLng(
                                                        locationController
                                                            .pickposition
                                                            .latitude,
                                                        locationController
                                                            .pickposition
                                                            .longitude))));
                                        locationController.setAddAddressData();
                                      }
                                      Get.toNamed(AppRouter.getAddressPage());
                                    }
                                  }
                                },
                        ),
                      )
                    ],
                  )),
            ),
          ),
        );
      },
    );
  }
}