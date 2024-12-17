import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SP_Feedback extends StatefulWidget {
  const SP_Feedback({super.key});

  @override
  _SP_FeedbackState createState() => _SP_FeedbackState();
}

class _SP_FeedbackState extends State<SP_Feedback> {
  List<dynamic> feedbackList = [];
  double averageRating = 0.0;

  @override
  void initState() {
    super.initState();
    fetchFeedback();
  }

  Future<void> fetchFeedback() async {
    final response = await http.get(Uri.parse('http://localhost:3000/api/v1/feedback'));

    if (response.statusCode == 200) {
      final List<dynamic> feedbacks = jsonDecode(response.body);
      setState(() {
        feedbackList = feedbacks;
        averageRating = feedbacks.isNotEmpty
            ? feedbacks.map((f) => f['rating']).reduce((a, b) => a + b) / feedbacks.length
            : 0.0;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to load feedback")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Feedback'),
        backgroundColor: Colors.amber,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Overall rating
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  averageRating.toStringAsFixed(1),
                  style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StarDisplay(value: averageRating.round()), // Star rating display
                    Text('based on ${feedbackList.length} reviews'),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16),

            // Rating distribution
            _buildRatingDistribution(),

            SizedBox(height: 16),

            // Review list
            Expanded(
              child: ListView.builder(
                itemCount: feedbackList.length,
                itemBuilder: (context, index) {
                  final feedback = feedbackList[index];
                  return _buildReview(
                    feedback['name'],
                    feedback['comment'],
                    feedback['rating'],
                    feedback['createdAt'],
                  );
                },
              ),
            ),

           
          ],
        ),
      ),
    );
  }

  Widget _buildRatingDistribution() {
    final ratingCounts = List.generate(5, (index) => 0);
    for (var feedback in feedbackList) {
      ratingCounts[feedback['rating'] - 1]++;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(5, (index) {
        final label = ['Excellent', 'Good', 'Average', 'Below Average', 'Poor'][index];
        final color = [Colors.green, Colors.greenAccent, Colors.yellow, Colors.orange, Colors.red][index];
        final widthFactor = feedbackList.isNotEmpty ? ratingCounts[index] / feedbackList.length : 0.0;
        return _buildRatingRow(label, 5 - index, color, widthFactor);
      }),
    );
  }

  Widget _buildRatingRow(String label, int stars, Color color, double widthFactor) {
    return Row(
      children: [
        Text(label),
        SizedBox(width: 8),
        Expanded(
          child: LinearProgressIndicator(
            value: widthFactor,
            color: color,
            backgroundColor: Colors.grey[300],
          ),
        ),
        SizedBox(width: 8),
        StarDisplay(value: stars),
      ],
    );
  }

  Widget _buildReview(String name, String comment, int rating, String timeAgo) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(child: Icon(Icons.person)),
            SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
                StarDisplay(value: rating),
              ],
            ),
            Spacer(),
            Text(timeAgo),
          ],
        ),
        SizedBox(height: 8),
        Text(comment),
        Divider(),
      ],
    );
  }
}

// Custom widget for displaying stars
class StarDisplay extends StatelessWidget {
  final int value;

  const StarDisplay({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < value ? Icons.star : Icons.star_border,
        );
      }),
    );
  }
}
