import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gradution_project/feathure/create_meeting/manager/metting_state.dart';
import 'package:intl/intl.dart';
import '../../data/model/meeting_model.dart';
import '../../manager/meeting_cubit.dart';

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
  final phoneController = TextEditingController();
  final List<TextEditingController> _phoneControllers = [];
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  @override
  void initState() {
    super.initState();
    // Start with one phone number field
    _phoneControllers.add(TextEditingController());
  }

  @override
  void dispose() {
    for (var controller in _phoneControllers) {
      controller.dispose();
    }
    phoneController.dispose();
    super.dispose();
  }

  void _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(Duration(days: 1)),
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
        SnackBar(content: Text('Please select date and time')),
      );
      return;
    }

    // Validate at least one phone number is entered
    if (_phoneControllers.every((controller) => controller.text.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter at least one phone number')),
      );
      return;
    }

    final meetingDateTime = DateTime(
      selectedDate!.year,
      selectedDate!.month,
      selectedDate!.day,
      selectedTime!.hour,
      selectedTime!.minute,
    );

    // Get all non-empty phone numbers
    final phoneNumbers = _phoneControllers
        .map((controller) => controller.text.trim())
        .where((phone) => phone.isNotEmpty)
        .toList();

    final meeting = MeetingModel(
      locationName: widget.locationController.text,
      lat: widget.selectedLatLng.latitude,
      lng: widget.selectedLatLng.longitude,
      date: meetingDateTime,
      phoneNumbers: phoneNumbers, // Now passing a list of phone numbers
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
            builder: (_) => Center(child: CircularProgressIndicator()),
          );
        } else if (state is CreateMeetLocationSuccess) {
          Navigator.of(context).popUntil((route) => route.isFirst);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Meeting saved successfully')),
          );
        } else if (state is CreateMeetLocationFailure) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 5,
                  margin: EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                Text(
                  "Meeting Location",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                SizedBox(height: 16),
                _buildTextField("Meeting Location", widget.locationController),
                SizedBox(height: 12),
                _buildPickerRow(
                    "Date",
                    selectedDate != null
                        ? DateFormat.yMMMMd().format(selectedDate!)
                        : "Select a date",
                    _pickDate),
                SizedBox(height: 12),
                _buildPickerRow(
                    "Time",
                    selectedTime != null
                        ? selectedTime!.format(context)
                        : "Select a time",
                    _pickTime),
                SizedBox(height: 12),
                // Phone numbers section
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Phone Numbers",
                        style: TextStyle(color: Colors.black)),
                    SizedBox(height: 8),
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
                              ),
                            ),
                            IconButton(
                              icon:
                                  Icon(Icons.remove_circle, color: Colors.red),
                              onPressed: () => _removePhoneField(index),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton.icon(
                        icon: Icon(Icons.add, color: Colors.blue),
                        label: Text("Add another phone",
                            style: TextStyle(color: Colors.blue)),
                        onPressed: _addPhoneField,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
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
                    child: Text("Save Meeting",
                        style: TextStyle(fontSize: 16, color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: (value) => value!.isEmpty ? 'Required field' : null,
      decoration: InputDecoration(
        hintStyle: TextStyle(color: Colors.black),
        labelText: label,
        labelStyle: TextStyle(color: Colors.black),
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none),
      ),
      style: TextStyle(color: Colors.black),
    );
  }

  Widget _buildPickerRow(String label, String value, VoidCallback onPressed) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(child: Text(label, style: TextStyle(color: Colors.black))),
          Text(value,
              style:
                  TextStyle(fontWeight: FontWeight.w500, color: Colors.black)),
          IconButton(
            icon: Icon(
              Icons.calendar_today,
              size: 20,
              color: Colors.black,
            ),
            onPressed: onPressed,
          ),
        ],
      ),
    );
  }
}
