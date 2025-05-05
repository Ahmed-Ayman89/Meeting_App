import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gradution_project/feathure/create_meeting/manager/metting_state.dart';
import 'package:intl/intl.dart';
import '../../data/model/meeting_model.dart';
import '../../manager/meeting_cubit.dart';

class MeetingFormSheet extends StatefulWidget {
  final LatLng selectedLatLng;
  final TextEditingController locationController; // إضافة الـ controller

  const MeetingFormSheet({
    required this.selectedLatLng,
    super.key,
    required this.locationController, // استلام الـ controller من الـ MapScreen
  });

  @override
  State<MeetingFormSheet> createState() => _MeetingFormSheetState();
}

class _MeetingFormSheetState extends State<MeetingFormSheet> {
  final _formKey = GlobalKey<FormState>();
  final phoneController = TextEditingController();
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

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

  void _submitForm() {
    if (!_formKey.currentState!.validate()) return;

    if (selectedDate == null || selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select date and time')),
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

    final meeting = MeetingModel(
      locationName:
          widget.locationController.text, // استخدام الـ controller هنا
      lat: widget.selectedLatLng.latitude,
      lng: widget.selectedLatLng.longitude,
      date: meetingDateTime,
      phoneNumber: phoneController.text,
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
          Navigator.pop(context); // Close loading dialog
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
                _buildTextField(
                  "Phone Number",
                  phoneController,
                  keyboardType: TextInputType.phone,
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
