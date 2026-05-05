import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/project_model.dart';
import '../models/task_model.dart';
import '../services/database_service.dart';
import 'project_detail_screen.dart';
import 'task_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Search projects or tasks...',
            border: InputBorder.none,
            hintStyle: GoogleFonts.inter(color: Colors.grey),
          ),
          style: GoogleFonts.inter(),
          onChanged: (val) {
            setState(() {
              _searchQuery = val.toLowerCase();
            });
          },
        ),
        elevation: 1,
        actions: [
          if (_searchQuery.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _searchController.clear();
                setState(() => _searchQuery = '');
              },
            )
        ],
      ),
      body: user == null
          ? const Center(child: Text("Please sign in"))
          : _searchQuery.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search, size: 80, color: Colors.grey.shade300),
                      const SizedBox(height: 16),
                      Text(
                        'Type to start searching',
                        style: GoogleFonts.inter(fontSize: 18, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                )
              : _buildSearchResults(user.uid),
    );
  }

  Widget _buildSearchResults(String userId) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Projects', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          StreamBuilder<List<ProjectModel>>(
            stream: DatabaseService().getUserProjects(userId),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const SizedBox();
              
              final results = snapshot.data!.where((p) => p.name.toLowerCase().contains(_searchQuery) || p.description.toLowerCase().contains(_searchQuery)).toList();
              
              if (results.isEmpty) return const Text('No matching projects.');
              
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: results.length,
                itemBuilder: (context, index) {
                  final project = results[index];
                  return Card(
                    color: Theme.of(context).cardColor,
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: const Icon(Icons.folder, color: Color(0xFF0B95FF)),
                      title: Text(project.name, style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProjectDetailScreen(project: project))),
                    ),
                  );
                },
              );
            },
          ),
          const SizedBox(height: 32),
          Text('Tasks', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          StreamBuilder<List<TaskModel>>(
            stream: DatabaseService().getUserTasks(userId),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const SizedBox();
              
              final results = snapshot.data!.where((t) => t.title.toLowerCase().contains(_searchQuery) || t.description.toLowerCase().contains(_searchQuery)).toList();
              
              if (results.isEmpty) return const Text('No matching tasks.');
              
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: results.length,
                itemBuilder: (context, index) {
                  final task = results[index];
                  return Card(
                    color: Theme.of(context).cardColor,
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: const Icon(Icons.check_box_outlined, color: Color(0xFF34C759)),
                      title: Text(task.title, style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => TaskDetailScreen(task: task))),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
