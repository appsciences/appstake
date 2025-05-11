import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:html' as html;
import 'dart:typed_data';
import '../models/project.dart';
import '../services/project_service.dart';

class EditProjectPage extends StatefulWidget {
  final Project project;

  const EditProjectPage({super.key, required this.project});

  @override
  State<EditProjectPage> createState() => _EditProjectPageState();
}

class _EditProjectPageState extends State<EditProjectPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _targetAmountController;
  late TextEditingController _imageUrlController;
  late DateTime _deadline;
  final ProjectService _projectService = ProjectService();
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();
  Uint8List? _selectedImageBytes;
  bool _isUploading = false;
  double _uploadProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.project.name);
    _descriptionController = TextEditingController(text: widget.project.description);
    _targetAmountController = TextEditingController(
      text: widget.project.targetAmount.toString(),
    );
    _imageUrlController = TextEditingController(text: widget.project.imageUrl);
    _deadline = widget.project.deadline;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _targetAmountController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _deadline,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _deadline) {
      setState(() {
        _deadline = picked;
      });
    }
  }

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

  Future<String?> _uploadImage() async {
    if (_selectedImageBytes == null) return null;

    setState(() {
      _isUploading = true;
      _uploadProgress = 0.0;
    });

    try {
      final String fileName = 'projects/${widget.project.id}/${DateTime.now().millisecondsSinceEpoch}.jpg';
      final Reference ref = _storage.ref().child(fileName);
      
      final UploadTask uploadTask = ref.putData(
        _selectedImageBytes!,
        SettableMetadata(contentType: 'image/jpeg'),
      );
      
      // Listen to upload progress
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

  Future<void> _saveProject() async {
    if (_formKey.currentState!.validate()) {
      try {
        String? imageUrl = _imageUrlController.text;
        
        if (_selectedImageBytes != null) {
          imageUrl = await _uploadImage();
          if (imageUrl == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Failed to upload image')),
            );
            return;
          }
        }

        final updatedProject = Project(
          id: widget.project.id,
          name: _nameController.text,
          description: _descriptionController.text,
          targetAmount: double.parse(_targetAmountController.text),
          raisedAmount: widget.project.raisedAmount,
          imageUrl: imageUrl!,
          deadline: _deadline,
          status: widget.project.status,
          investorCount: widget.project.investorCount,
          createdAt: widget.project.createdAt,
          minInvestment: widget.project.minInvestment,
          projectedRevenue: widget.project.projectedRevenue,
          projectionYears: widget.project.projectionYears,
        );

        await _projectService.updateProject(updatedProject);
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Project updated successfully')),
          );
          Navigator.pop(context, updatedProject);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error updating project: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Edit Project'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _isUploading ? null : _saveProject,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image upload area
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.grey[400]!,
                      width: 2,
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: Stack(
                    children: [
                      if (_selectedImageBytes != null)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.memory(
                            _selectedImageBytes!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                        )
                      else if (widget.project.imageUrl.isNotEmpty)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            widget.project.imageUrl,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                        )
                      else
                        const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_photo_alternate, size: 50),
                              SizedBox(height: 8),
                              Text('Click to select an image'),
                            ],
                          ),
                        ),
                      if (_isUploading)
                        Container(
                          color: Colors.black54,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(
                                  value: _uploadProgress,
                                  backgroundColor: Colors.white,
                                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '${(_uploadProgress * 100).toStringAsFixed(1)}%',
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Rest of the form fields
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Project Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a project name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _targetAmountController,
                decoration: const InputDecoration(
                  labelText: 'Target Amount',
                  border: OutlineInputBorder(),
                  prefixText: '\$',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a target amount';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ListTile(
                title: const Text('Deadline'),
                subtitle: Text(
                  DateFormat('MMM dd, yyyy').format(_deadline),
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _selectDate(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProjectForm extends StatefulWidget {
  final Project? project;
  final Future<void> Function(Project project) onSave;
  final bool isUploading;
  final double uploadProgress;
  final Uint8List? selectedImageBytes;
  final void Function() onPickImage;
  final DateTime deadline;
  final void Function(DateTime) onDeadlineChanged;

  const ProjectForm({
    super.key,
    this.project,
    required this.onSave,
    required this.isUploading,
    required this.uploadProgress,
    required this.selectedImageBytes,
    required this.onPickImage,
    required this.deadline,
    required this.onDeadlineChanged,
  });

  @override
  State<ProjectForm> createState() => _ProjectFormState();
}

class _ProjectFormState extends State<ProjectForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _targetAmountController;
  late DateTime _deadline;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.project?.name ?? '');
    _descriptionController = TextEditingController(text: widget.project?.description ?? '');
    _targetAmountController = TextEditingController(
      text: widget.project?.targetAmount.toString() ?? '',
    );
    _deadline = widget.deadline;
  }

  @override
  void didUpdateWidget(ProjectForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.deadline != _deadline) {
      setState(() {
        _deadline = widget.deadline;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _targetAmountController.dispose();
    super.dispose();
  }

  void _onSave() {
    if (_formKey.currentState!.validate()) {
      final project = Project(
        id: widget.project?.id ?? '',
        name: _nameController.text,
        description: _descriptionController.text,
        targetAmount: double.parse(_targetAmountController.text),
        raisedAmount: widget.project?.raisedAmount ?? 0,
        imageUrl: widget.project?.imageUrl ?? '',
        deadline: _deadline,
        status: widget.project?.status ?? 'open',
        investorCount: widget.project?.investorCount ?? 0,
        createdAt: widget.project?.createdAt ?? DateTime.now(),
        minInvestment: widget.project?.minInvestment ?? 0,
        projectedRevenue: widget.project?.projectedRevenue ?? 0,
        projectionYears: widget.project?.projectionYears ?? 0,
      );
      widget.onSave(project);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image upload area
          GestureDetector(
            onTap: widget.onPickImage,
            child: Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.grey[400]!,
                  width: 2,
                  style: BorderStyle.solid,
                ),
              ),
              child: Stack(
                children: [
                  if (widget.selectedImageBytes != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.memory(
                        widget.selectedImageBytes!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    )
                  else if (widget.project?.imageUrl != null && widget.project!.imageUrl.isNotEmpty)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        widget.project!.imageUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    )
                  else
                    const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_photo_alternate, size: 50),
                          SizedBox(height: 8),
                          Text('Click to select an image'),
                        ],
                      ),
                    ),
                  if (widget.isUploading)
                    Container(
                      color: Colors.black54,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(
                              value: widget.uploadProgress,
                              backgroundColor: Colors.white,
                              valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${(widget.uploadProgress * 100).toStringAsFixed(1)}%',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Rest of the form fields
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Project Name',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a project name';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              labelText: 'Description',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a description';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _targetAmountController,
            decoration: const InputDecoration(
              labelText: 'Target Amount',
              border: OutlineInputBorder(),
              prefixText: '\$',
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a target amount';
              }
              if (double.tryParse(value) == null) {
                return 'Please enter a valid number';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          ListTile(
            title: const Text('Deadline'),
            subtitle: Text(
              DateFormat('MMM dd, yyyy').format(_deadline),
            ),
            trailing: const Icon(Icons.calendar_today),
            onTap: () async {
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: _deadline,
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 365)),
              );
              if (picked != null && picked != _deadline) {
                setState(() {
                  _deadline = picked;
                });
                widget.onDeadlineChanged(picked);
              }
            },
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: widget.isUploading ? null : _onSave,
            child: Text(widget.project == null ? 'Create Project' : 'Save Changes'),
          ),
        ],
      ),
    );
  }
} 