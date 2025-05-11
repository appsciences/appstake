import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import '../models/project.dart';
import '../services/project_service.dart';
import 'edit_project_page.dart';

class CreateProjectPage extends StatefulWidget {
  const CreateProjectPage({super.key});

  @override
  State<CreateProjectPage> createState() => _CreateProjectPageState();
}

class _CreateProjectPageState extends State<CreateProjectPage> {
  final ProjectService _projectService = ProjectService();
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();
  Uint8List? _selectedImageBytes;
  bool _isUploading = false;
  double _uploadProgress = 0.0;
  DateTime _deadline = DateTime.now().add(const Duration(days: 30));

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );
      if (image != null) {
        final bytes = await image.readAsBytes();
        setState(() {
          _selectedImageBytes = bytes;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  Future<String?> _uploadImage(String projectId) async {
    if (_selectedImageBytes == null) return null;
    setState(() {
      _isUploading = true;
      _uploadProgress = 0.0;
    });
    try {
      final String fileName = 'projects/$projectId/${DateTime.now().millisecondsSinceEpoch}.jpg';
      final Reference ref = _storage.ref().child(fileName);
      final UploadTask uploadTask = ref.putData(
        _selectedImageBytes!,
        SettableMetadata(contentType: 'image/jpeg'),
      );
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        setState(() {
          _uploadProgress = snapshot.bytesTransferred / snapshot.totalBytes;
        });
      });
      final TaskSnapshot snapshot = await uploadTask;
      final String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading image: $e')),
      );
      return null;
    } finally {
      setState(() {
        _isUploading = false;
        _uploadProgress = 0.0;
      });
    }
  }

  Future<void> _createProject(Project project) async {
    try {
      String imageUrl = project.imageUrl;
      final newProjectId = DateTime.now().millisecondsSinceEpoch.toString();
      if (_selectedImageBytes != null) {
        final uploadedUrl = await _uploadImage(newProjectId);
        if (uploadedUrl != null) {
          imageUrl = uploadedUrl;
        }
      }
      final newProject = Project(
        id: newProjectId,
        name: project.name,
        description: project.description,
        targetAmount: project.targetAmount,
        raisedAmount: 0,
        imageUrl: imageUrl,
        deadline: _deadline,
        status: 'open',
        investorCount: 0,
        createdAt: DateTime.now(),
        minInvestment: project.minInvestment,
        projectedRevenue: project.projectedRevenue,
        projectionYears: project.projectionYears,
      );
      await _projectService.createProject(newProject);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Project created successfully')),
        );
        Navigator.pop(context, newProject);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error creating project: $e')),
        );
      }
    }
  }

  void _onDeadlineChanged(DateTime newDeadline) {
    setState(() {
      _deadline = newDeadline;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Project')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: ProjectForm(
          project: null,
          onSave: _createProject,
          isUploading: _isUploading,
          uploadProgress: _uploadProgress,
          selectedImageBytes: _selectedImageBytes,
          onPickImage: _pickImage,
          deadline: _deadline,
          onDeadlineChanged: _onDeadlineChanged,
        ),
      ),
    );
  }
} 