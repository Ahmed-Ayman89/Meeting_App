import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gradution_project/feathure/home/manager/get_meetings_cubit/get_meetings_cubit.dart';
import 'package:intl/intl.dart';

import '../../data/model/meeting_model.dart';
import '../../manager/meeting_cubit.dart';
import '../../manager/metting_state.dart';

class MeetingFormSheet extends StatefulWidget {
  final LatLng selectedLatLng;
  final TextEditingController locationController;

  const MeetingFormSheet({
    required this.selectedLatLng,
    super.key,
    required this.locationController,
  });

  @override
  State<MeetingFormSheet> createState() => _MeetingFormSheetState();
}

class _MeetingFormSheetState extends State<MeetingFormSheet> {
  final _formKey = GlobalKey<FormState>();
  final meetingNameController = TextEditingController();
  final List<TextEditingController> _phoneControllers = [];
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  @override
  void initState() {
    super.initState();
    _phoneControllers.add(TextEditingController());
  }

  @override
  void dispose() {
    meetingNameController.dispose();
    for (var controller in _phoneControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (date != null) setState(() => selectedDate = date);
  }

  void _pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time != null) setState(() => selectedTime = time);
  }

  void _addPhoneField() {
    setState(() {
      _phoneControllers.add(TextEditingController());
    });
  }

  void _removePhoneField(int index) {
    if (_phoneControllers.length > 1) {
      setState(() {
        _phoneControllers[index].dispose();
        _phoneControllers.removeAt(index);
      });
    }
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) return;

    if (selectedDate == null || selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select date and time')),
      );
      return;
    }

    if (_phoneControllers.every((controller) => controller.text.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter at least one phone number')),
      );
      return;
    }

    final formattedTime =
        '${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}';

    final meeting = MeetingModel(
      meetingname: meetingNameController.text.trim(),
      time: formattedTime,
      lat: widget.selectedLatLng.latitude,
      lng: widget.selectedLatLng.longitude,
      date: selectedDate!,
      phoneNumbers: _phoneControllers
          .map((controller) => controller.text.trim())
          .where((phone) => phone.isNotEmpty)
          .toList(),
    );

    context.read<MeetingCubit>().saveMeeting(meeting);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MeetingCubit, CreateMeetLocationState>(
      listener: (context, state) {
        if (state is CreateMeetLocationLoading) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => const Center(child: CircularProgressIndicator()),
          );
        } else if (state is CreateMeetLocationSuccess) {
          GetMeetingsCubit.get(context).getMeetings();
          Navigator.pop(context);
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Meeting saved successfully')),
          );
        } else if (state is CreateMeetLocationFailure) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }
      },
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 5,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const Text(
                  "Create Meeting",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                const SizedBox(height: 16),
                _buildTextField("Meeting Name", meetingNameController,
                    validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Required field';
                  }
                  return null;
                }),
                const SizedBox(height: 12),
                _buildTextField("Meeting Location", widget.locationController),
                const SizedBox(height: 12),
                _buildPickerRow(
                    "Date",
                    selectedDate != null
                        ? DateFormat.yMMMMd().format(selectedDate!)
                        : "Select a date",
                    _pickDate),
                const SizedBox(height: 12),
                _buildPickerRow(
                    "Time",
                    selectedTime != null
                        ? selectedTime!.format(context)
                        : "Select a time",
                    _pickTime),
                const SizedBox(height: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Phone Numbers",
                        style: TextStyle(color: Colors.black)),
                    const SizedBox(height: 8),
                    ..._phoneControllers.asMap().entries.map((entry) {
                      final index = entry.key;
                      final controller = entry.value;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: _buildTextField(
                                "Phone ${index + 1}",
                                controller,
                                keyboardType: TextInputType.phone,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    if (_phoneControllers.length > 1) {
                                      return null;
                                    }
                                    return 'Required field';
                                  }
                                  if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                                    return 'Enter valid phone number';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.remove_circle,
                                  color: Colors.red),
                              onPressed: () => _removePhoneField(index),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton.icon(
                        icon: const Icon(Icons.add, color: Colors.blue),
                        label: const Text("Add another phone",
                            style: TextStyle(color: Colors.blue)),
                        onPressed: _addPhoneField,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: _submitForm,
                    child: const Text("Save Meeting",
                        style: TextStyle(fontSize: 16, color: Colors.white)),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator:
          validator ?? (value) => value!.isEmpty ? 'Required field' : null,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black),
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      style: const TextStyle(color: Colors.black),
    );
  }

  Widget _buildPickerRow(String label, String value, VoidCallback onPressed) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
              child: Text(label, style: const TextStyle(color: Colors.black))),
          Text(value,
              style: const TextStyle(
                  fontWeight: FontWeight.w500, color: Colors.black)),
          IconButton(
            icon:
                const Icon(Icons.calendar_today, size: 20, color: Colors.black),
            onPressed: onPressed,
          ),
        ],
      ),
    );
  }
}
