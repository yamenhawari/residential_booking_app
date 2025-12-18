import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:residential_booking_app/core/enums/governorate_enum.dart';
import 'package:residential_booking_app/features/owner/domain/usecases/add_apartment_usecase.dart';
import 'package:residential_booking_app/features/owner/presentation/cubit/owner_cubit.dart';
import 'package:residential_booking_app/features/owner/presentation/cubit/owner_state.dart';

import '../../../../core/resources/app_colors.dart';
import '../../../../core/widgets/loading_widget.dart';

class AddApartmentScreen extends StatefulWidget {
  const AddApartmentScreen({super.key});

  @override
  State<AddApartmentScreen> createState() => _AddApartmentScreenState();
}

class _AddApartmentScreenState extends State<AddApartmentScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _areaCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();

  // State Variables
  Governorate _selectedCity = Governorate.damascus;
  int _roomCount = 1;
  int _floor = 0;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _areaCtrl.dispose();
    _priceCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Property")),
      body: BlocConsumer<OwnerCubit, OwnerState>(
        listener: (context, state) {
          if (state is OwnerSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Apartment Added Successfully!")),
            );
          } else if (state is OwnerError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(state.message),
                  backgroundColor: AppColors.error),
            );
          }
        },
        builder: (context, state) {
          if (state is OwnerLoading) return const LoadingWidget();

          return SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // --- 1. Images Section ---
                  _buildImageSection(context),

                  SizedBox(height: 24.h),

                  // --- 2. Basic Info ---
                  Text("Details",
                      style: Theme.of(context).textTheme.titleMedium),
                  SizedBox(height: 8.h),

                  TextFormField(
                    controller: _titleCtrl,
                    decoration: const InputDecoration(
                        labelText: "Title (e.g. Sunny Studio)"),
                    validator: (v) => v!.isEmpty ? "Required" : null,
                  ),
                  SizedBox(height: 12.h),

                  TextFormField(
                    controller: _descCtrl,
                    maxLines: 3,
                    decoration: const InputDecoration(labelText: "Description"),
                    validator: (v) => v!.isEmpty ? "Required" : null,
                  ),
                  SizedBox(height: 12.h),

                  // --- 3. Location & Price ---
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<Governorate>(
                          value: _selectedCity,
                          decoration: const InputDecoration(labelText: "City"),
                          items: Governorate.values.map((city) {
                            return DropdownMenuItem(
                                value: city, child: Text(city.displayName));
                          }).toList(),
                          onChanged: (val) =>
                              setState(() => _selectedCity = val!),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: TextFormField(
                          controller: _priceCtrl,
                          keyboardType: TextInputType.number,
                          decoration:
                              const InputDecoration(labelText: "Price (USD)"),
                          validator: (v) => v!.isEmpty ? "Required" : null,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),

                  TextFormField(
                    controller: _areaCtrl,
                    decoration:
                        const InputDecoration(labelText: "Area (e.g. Mazzeh)"),
                    validator: (v) => v!.isEmpty ? "Required" : null,
                  ),

                  Divider(height: 32.h),

                  // --- 4. Counters ---
                  _buildCounterRow("Rooms", _roomCount,
                      (val) => setState(() => _roomCount = val)),
                  SizedBox(height: 16.h),
                  _buildCounterRow(
                      "Floor", _floor, (val) => setState(() => _floor = val)),

                  SizedBox(height: 40.h),

                  // --- 5. Submit ---
                  SizedBox(
                    height: 50.h,
                    child: ElevatedButton(
                      onPressed: () => _submitForm(context),
                      child: const Text("POST APARTMENT"),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // --- Helper Widgets ---

  Widget _buildImageSection(BuildContext context) {
    // We access the list of images directly from the Cubit's state if needed,
    // or relying on the Cubit instance logic we added previously.
    // However, to make the UI reactive to image changes, we check the state.

    // Trick: To get current images without rebuilding the whole form on every keystroke,
    // we can use the Cubit getter directly if public, OR rely on BlocBuilder rebuilding this widget.
    // For cleaner code assuming Cubit handles state:
    final cubit = context.read<OwnerCubit>();
    // Note: You need to expose getter `List<File> get selectedImages => _selectedImages;` in OwnerCubit
    // OR cast the state if you emitted OwnerImagesChanged.

    // For now, let's assume we trigger rebuilds on OwnerImagesChanged
    List<File> images = [];
    final state = context.watch<OwnerCubit>().state;
    if (state is OwnerImagesChanged) {
      images = state.images;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Photos", style: Theme.of(context).textTheme.titleMedium),
        SizedBox(height: 8.h),
        SizedBox(
          height: 100.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: images.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return InkWell(
                  onTap: () => cubit.pickImages(),
                  child: Container(
                    width: 100.h,
                    margin: EdgeInsets.only(right: 8.w),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[400]!),
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.grey[100],
                    ),
                    child: const Icon(Icons.add_a_photo, color: Colors.grey),
                  ),
                );
              }
              final imageFile = images[index - 1];
              return Stack(
                children: [
                  Container(
                    width: 100.h,
                    margin: EdgeInsets.only(right: 8.w),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(imageFile, fit: BoxFit.cover),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 8.w,
                    child: InkWell(
                      onTap: () => cubit.removeImage(index - 1),
                      child: const CircleAvatar(
                        radius: 10,
                        backgroundColor: Colors.red,
                        child: Icon(Icons.close, size: 14, color: Colors.white),
                      ),
                    ),
                  )
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCounterRow(String label, int value, Function(int) onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove),
                onPressed: value > 0 ? () => onChanged(value - 1) : null,
              ),
              Text("$value",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16)),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () => onChanged(value + 1),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _submitForm(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      // Validate Images (Check if Cubit has images)
      // Since we don't have direct access to the list here without accessing state/getter,
      // we rely on the user adding at least one.
      // Ideally, add `bool hasImages` getter in Cubit.

      context.read<OwnerCubit>().addApartment(
            AddApartmentParams(
              title: _titleCtrl.text,
              description: _descCtrl.text,
              governorate: _selectedCity,
              address: _areaCtrl.text,
              price: double.parse(_priceCtrl.text),
              roomCount: _roomCount,
              images: [], // Pass empty, Cubit uses internal state
            ),
          );
    }
  }
}
