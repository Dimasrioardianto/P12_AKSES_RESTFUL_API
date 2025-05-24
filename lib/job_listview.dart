import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'job.dart';

class JobsListView extends StatelessWidget {
  const JobsListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Job>>(
      future: _fetchJobs(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No jobs available"));
        }
        return _jobsListView(snapshot.data!);
      },
    );
  }

  Future<List<Job>> _fetchJobs() async {
    try {
      var uri = Uri.parse('https://mock-json-service.glitch.me');
      final response = await http.get(uri).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        return jsonResponse.map((job) => Job.fromJson(job)).toList();
      } else {
        // If API fails, return local mock data
        return _getLocalJobs();
      }
    } catch (e) {
      // If any error occurs (timeout, etc.), return local mock data
      return _getLocalJobs();
    }
  }

  // Local fallback data that matches your Job class structure
  List<Job> _getLocalJobs() {
    return [
      Job(
        id: 1,
        position: 'Flutter Developer',
        company: 'Tech Corp',
        description: 'Develop cross-platform mobile applications using Flutter',
      ),
      Job(
        id: 2,
        position: 'Backend Engineer',
        company: 'Data Systems',
        description: 'Build and maintain server-side applications and APIs',
      ),
      Job(
        id: 3,
        position: 'UI/UX Designer',
        company: 'Creative Studio',
        description: 'Design user interfaces and experiences for mobile and web',
      ),
    ];
  }

  ListView _jobsListView(List<Job> data) {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        return _jobTile(context, data[index]);
      },
    );
  }

  Widget _jobTile(BuildContext context, Job job) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: ListTile(
        title: Text(
          job.position,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 20,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(job.company),
            const SizedBox(height: 4),
            Text(
              job.description,
              style: const TextStyle(fontSize: 14),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        leading: const Icon(
          Icons.work,
          color: Colors.blue,
          size: 40,
        ),
        onTap: () {
          _showJobDetails(context, job);
        },
      ),
    );
  }

  void _showJobDetails(BuildContext context, Job job) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(job.position),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Company: ${job.company}'),
              const SizedBox(height: 8),
              Text('Description: ${job.description}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}