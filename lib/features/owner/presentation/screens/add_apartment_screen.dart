import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:residential_booking_app/core/entities/apartment.dart';
import 'package:residential_booking_app/core/enums/governorate_enum.dart';
import 'package:residential_booking_app/core/resources/app_colors.dart';
import 'package:residential_booking_app/core/utils/app_dialogs.dart';
import 'package:residential_booking_app/core/utils/app_snackbars.dart';
import 'package:residential_booking_app/core/utils/extentions.dart';
import 'package:residential_booking_app/core/utils/nav_helper.dart';
import 'package:residential_booking_app/core/widgets/app_text_field.dart';
import 'package:residential_booking_app/features/auth/presentation/widgets/primary_button.dart';
import 'package:residential_booking_app/features/owner/domain/usecases/add_apartment_usecase.dart';
import 'package:residential_booking_app/features/owner/domain/usecases/update_apartment_usecase.dart';
import 'package:residential_booking_app/features/owner/presentation/cubit/owner_cubit.dart';
import 'package:residential_booking_app/features/owner/presentation/cubit/owner_state.dart';

class AddApartmentScreen extends StatefulWidget {
  final Apartment?
      apartment; // If null, it's Add mode. If exists, it's Edit mode.
  const AddApartmentScreen({super.key, this.apartment});

  @override
  State<AddApartmentScreen> createState() => _AddApartmentScreenState();
}

class _AddApartmentScreenState extends State<AddApartmentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();

  late Governorate _selectedGov;
  int _rooms = 1;
  bool get _isEditing => widget.apartment != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      final apt = widget.apartment!;
      _titleCtrl.text = apt.title;
      _descCtrl.text = apt.description;
      _priceCtrl.text = apt.pricePerMonth.toString();
      _addressCtrl.text = apt.address;
      _selectedGov = apt.governorate;
      _rooms = apt.roomCount;
    } else {
      _selectedGov = Governorate.damascus;
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    if (_isEditing) {
      context.read<OwnerCubit>().updateApartment(UpdateApartmentParams(
            apartmentId: widget.apartment!.id,
            title: _titleCtrl.text,
            description: _descCtrl.text,
            price: double.parse(_priceCtrl.text),
            address: _addressCtrl.text,
            governorate: _selectedGov,
            roomCount: _rooms,
          ));
    } else {
      context.read<OwnerCubit>().addApartment(AddApartmentParams(
            title: _titleCtrl.text,
            description: _descCtrl.text,
            price: double.parse(_priceCtrl.text),
            address: _addressCtrl.text,
            governorate: _selectedGov,
            roomCount: _rooms,
            images: [], // Cubit handles images from state
          ));
    }
  }

  void _confirmDelete() {
    AppDialogs.showConfirm(
      context,
      message: context.tr.deleteConfirm,
      confirmText: context.tr.deleteProperty,
      onConfirm: () {
        context.read<OwnerCubit>().deleteApartment(widget.apartment!.id);
        Nav.back(); // Close dialog
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title:
            Text(_isEditing ? context.tr.editProperty : context.tr.addProperty),
        actions: _isEditing
            ? [
                IconButton(
                  onPressed: _confirmDelete,
                  icon:
                      const Icon(Icons.delete_outline, color: AppColors.error),
                )
              ]
            : null,
      ),
      body: BlocListener<OwnerCubit, OwnerState>(
        listener: (context, state) {
          if (state is OwnerSuccess) {
            AppSnackBars.showSuccess(context, message: state.message);
            Nav.back();
          } else if (state is OwnerError) {
            AppSnackBars.showError(context, message: state.message);
          }
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24.w),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image Picker
                GestureDetector(
                  onTap: () => context.read<OwnerCubit>().pickImages(),
                  child: Container(
                    height: 180.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(
                          color: theme.dividerColor, style: BorderStyle.solid),
                    ),
                    child: BlocBuilder<OwnerCubit, OwnerState>(
                      builder: (context, state) {
                        if (state is OwnerImagesChanged &&
                            state.images.isNotEmpty) {
                          return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: state.images.length,
                            padding: EdgeInsets.all(10.w),
                            itemBuilder: (context, index) => Padding(
                              padding: EdgeInsets.only(right: 10.w),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12.r),
                                child: Image.file(state.images[index],
                                    fit: BoxFit.cover, width: 140.w),
                              ),
                            ),
                          );
                        }
                        // If editing, show existing images (mock logic for now)
                        if (_isEditing && widget.apartment!.images.isNotEmpty) {
                          return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: widget.apartment!.images.length,
                            padding: EdgeInsets.all(10.w),
                            itemBuilder: (context, index) => Padding(
                              padding: EdgeInsets.only(right: 10.w),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12.r),
                                child: Image.network(
                                    widget.apartment!.images[index],
                                    fit: BoxFit.cover,
                                    width: 140.w),
                              ),
                            ),
                          );
                        }
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_photo_alternate_outlined,
                                size: 40.sp, color: AppColors.primary),
                            SizedBox(height: 8.h),
                            Text(context.tr.uploadImages,
                                style: theme.textTheme.bodyMedium),
                          ],
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(height: 30.h),

                AppTextField(
                  controller: _titleCtrl,
                  hint: "Sunny Apartment...",
                  label: context.tr.propertyTitle,
                  validator: (v) =>
                      v!.isEmpty ? context.tr.fieldRequired : null,
                ),
                SizedBox(height: 16.h),

                AppTextField(
                  controller: _descCtrl,
                  hint: "Describe your property...",
                  label: context.tr.propertyDesc,
                  maxLength: 500,
                ),
                SizedBox(height: 16.h),

                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Governorate",
                              style: theme.textTheme.titleMedium?.copyWith(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600)),
                          SizedBox(height: 8.h),
                          DropdownButtonFormField<Governorate>(
                            value: _selectedGov,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: theme.cardColor,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16.w, vertical: 14.h),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                  borderSide:
                                      BorderSide(color: theme.dividerColor)),
                            ),
                            items: Governorate.values
                                .map((e) => DropdownMenuItem(
                                    value: e, child: Text(e.displayName)))
                                .toList(),
                            onChanged: (v) => setState(() => _selectedGov = v!),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: AppTextField(
                        controller: _priceCtrl,
                        hint: "100",
                        label: context.tr.priceUsd,
                        keyboardType: TextInputType.number,
                        validator: (v) =>
                            v!.isEmpty ? context.tr.fieldRequired : null,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),

                AppTextField(
                  controller: _addressCtrl,
                  hint: "Street, Building No...",
                  label: context.tr.propertyAddress,
                  validator: (v) =>
                      v!.isEmpty ? context.tr.fieldRequired : null,
                ),
                SizedBox(height: 24.h),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(context.tr.rooms, style: theme.textTheme.titleLarge),
                    Container(
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(color: theme.dividerColor),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                              onPressed: () =>
                                  setState(() => _rooms > 1 ? _rooms-- : null),
                              icon: const Icon(Icons.remove)),
                          Text("$_rooms", style: theme.textTheme.titleLarge),
                          IconButton(
                              onPressed: () => setState(() => _rooms++),
                              icon: Icon(Icons.add, color: AppColors.primary)),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 40.h),

                BlocBuilder<OwnerCubit, OwnerState>(
                  builder: (context, state) {
                    return PrimaryButton(
                      label: _isEditing
                          ? context.tr.saveProperty
                          : context.tr.createProperty,
                      loading: state is OwnerLoading,
                      onPressed: _submit,
                    );
                  },
                ),
                SizedBox(height: 30.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
