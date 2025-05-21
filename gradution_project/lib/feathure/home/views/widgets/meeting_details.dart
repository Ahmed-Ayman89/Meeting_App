import 'package:flutter/material.dart';
import 'package:gradution_project/feathure/home/data/models/meeting_response_model.dart';

class MeetingDetailsPage extends StatelessWidget {
  final GetMeetingResponseModel meetingModel;

  const MeetingDetailsPage({super.key, required this.meetingModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          meetingModel.meetingname ?? 'Meeting Details',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'Concert One',
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailItem(
                  icon: Icons.meeting_room,
                  label: 'Meeting Name',
                  value: meetingModel.meetingname ?? 'N/A',
                  isImportant: true,
                ),
                _buildDetailItem(
                  icon: Icons.calendar_today,
                  label: 'Date',
                  value: meetingModel.date ?? 'N/A',
                ),
                _buildDetailItem(
                  icon: Icons.access_time,
                  label: 'Time',
                  value: meetingModel.time ?? 'N/A',
                ),
                _buildDetailItem(
                  icon: Icons.phone,
                  label: 'Phone Numbers',
                  value: meetingModel.phoneNumbers?.join(', ') ?? 'N/A',
                ),
                _buildDetailItem(
                  icon: Icons.create,
                  label: 'Created At',
                  value: meetingModel.createdAt ?? 'N/A',
                ),
                _buildDetailItem(
                  icon: Icons.update,
                  label: 'Updated At',
                  value: meetingModel.updatedAt ?? 'N/A',
                ),
                _buildDetailItem(
                  icon: Icons.public,
                  label: 'Visibility',
                  value: meetingModel.isPublic == true ? 'Public' : 'Private',
                ),
                if (meetingModel.sId != null)
                  _buildDetailItem(
                    icon: Icons.info,
                    label: 'Meeting ID',
                    value: meetingModel.sId!,
                  ),
                if (meetingModel.iV != null)
                  _buildDetailItem(
                    icon: Icons.numbers,
                    label: 'Version',
                    value: meetingModel.iV.toString(),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem({
    required IconData icon,
    required String label,
    required String value,
    bool isImportant = false,
    bool isMonospace = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 24,
            color: isImportant ? Colors.blue : Colors.grey[600],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontFamily: 'Concert One',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight:
                        isImportant ? FontWeight.bold : FontWeight.normal,
                    fontFamily: isMonospace ? 'RobotoMono' : 'Concert One',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
