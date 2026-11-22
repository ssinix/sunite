import 'package:flutter/material.dart';
import 'package:sunite/utils/app_spacing.dart';



enum PostKind { group, person }

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  static const _categories = [
    'Course Groups',
    'Erasmus',
    'Startups & Projects',
    'Events',
  ];
  static const _terms = ['Fall 2026', 'Spring 2027', 'Fall 2027'];

  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _fieldController = TextEditingController();
  final _dateController = TextEditingController();

  PostKind _kind = PostKind.group;
  String _category = 'Course Groups';
  String _term = 'Spring 2027';
  int _capacity = 5;
  final List<String> _lookingFor = [];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _fieldController.dispose();
    _dateController.dispose();
    super.dispose();
  }




  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.w600)),
    );
  }


  InputDecoration _input(String hint) {
    return InputDecoration(
      hintText: hint,
      isDense: true,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
    );
  }


  Widget _categoryField() {
    switch (_category) {
      case 'Course Groups':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _label('Course code'),
            TextFormField(
              controller: _fieldController,
              decoration: _input('e.g. CS310'),
            ),
          ],
        );
      case 'Erasmus':
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _label('School'),
                  TextFormField(
                    controller: _fieldController,
                    decoration: _input('e.g. TU Delft'),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _label('Term'),
                  DropdownButtonFormField<String>(
                    value: _term,
                    decoration: _input(''),
                    items: [
                      for (final term in _terms)
                        DropdownMenuItem(value: term, child: Text(term)),
                    ],
                    onChanged: (value) =>
                        setState(() => _term = value ?? _term),
                  ),
                ],
              ),
            ),
          ],
        );
      case 'Events':
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _label('Event name'),
                  TextFormField(
                    controller: _fieldController,
                    decoration: _input('e.g. Career Fair'),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _label('Date'),
                  TextFormField(
                    controller: _dateController,
                    decoration: _input('e.g. 14 Dec'),
                  ),
                ],
              ),
            ),
          ],
        );
      default:

        return const SizedBox.shrink();
    }
  }


  Future<void> _addTag() async {
    final controller = TextEditingController();
    final tag = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Add a tag'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'e.g. Flutter'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () =>
                Navigator.pop(dialogContext, controller.text.trim()),
            child: const Text('Add'),
          ),
        ],
      ),
    );
    if (tag != null && tag.isNotEmpty && !_lookingFor.contains(tag)) {
      setState(() => _lookingFor.add(tag));
    }
  }


  void _publish() {
    if (!_formKey.currentState!.validate()) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Post published'),
        content: Text(
          'Your post is now live on the $_category board. '
              'You can edit it from My Posts.',
        ),
        actions: [
          FilledButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              Navigator.pop(context);
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('New Post'),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: AppSpacing.screenPadding,
          children: [
            _label('Post type'),
            SegmentedButton<PostKind>(
              showSelectedIcon: false,
              segments: const [
                ButtonSegment(
                  value: PostKind.group,
                  label: Text('Group seeking members',
                      style: TextStyle(fontSize: 12)),
                ),
                ButtonSegment(
                  value: PostKind.person,
                  label: Text('Person seeking group',
                      style: TextStyle(fontSize: 12)),
                ),
              ],
              selected: {_kind},
              onSelectionChanged: (selection) =>
                  setState(() => _kind = selection.first),
            ),
            const SizedBox(height: AppSpacing.md),


            _label('Category'),
            DropdownButtonFormField<String>(
              value: _category,
              decoration: _input(''),
              items: [
                for (final category in _categories)
                  DropdownMenuItem(value: category, child: Text(category)),
              ],
              onChanged: (value) => setState(() {
                _category = value ?? _category;
                _fieldController.clear();
              }),
            ),
            const SizedBox(height: AppSpacing.md),


            _categoryField(),
            if (_category != 'Startups & Projects')
              const SizedBox(height: AppSpacing.md),

            _label('Title'),
            TextFormField(
              controller: _titleController,
              decoration: _input('Give your post a short title'),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Title is required';
                }
                return null;
              },
            ),
            const SizedBox(height: AppSpacing.md),

            _label('Description'),
            TextFormField(
              controller: _descriptionController,
              decoration: _input('Describe the project, meeting times...'),
              maxLines: 3,
            ),
            const SizedBox(height: AppSpacing.md),

            if (_kind == PostKind.group)
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Capacity (max members)',
                            style: TextStyle(fontWeight: FontWeight.w600)),
                        Text(
                          'Group posts only',
                          style: text.bodySmall
                              ?.copyWith(color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ),
                  IconButton.outlined(
                    onPressed: _capacity > 2
                        ? () => setState(() => _capacity--)
                        : null,
                    icon: const Icon(Icons.remove),
                  ),
                  SizedBox(
                    width: 40,
                    child: Text(
                      '$_capacity',
                      textAlign: TextAlign.center,
                      style: text.titleMedium,
                    ),
                  ),
                  IconButton.outlined(
                    onPressed: _capacity < 20
                        ? () => setState(() => _capacity++)
                        : null,
                    icon: const Icon(Icons.add),
                  ),
                ],
              )
            else
              Text(
                'Capacity hidden: person post',
                style: text.bodySmall?.copyWith(color: Colors.grey.shade600),
              ),
            const SizedBox(height: AppSpacing.md),

            _label('Looking for'),
            Wrap(
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xs,
              children: [
                for (final tag in _lookingFor)
                  InputChip(
                    label: Text(tag),
                    onDeleted: () => setState(() => _lookingFor.remove(tag)),
                  ),
                ActionChip(
                  avatar: const Icon(Icons.add, size: 16),
                  label: const Text('Add'),
                  onPressed: _addTag,
                ),
              ],
            ),
          ],
        ),
      ),

      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: AppSpacing.screenPadding,
          child: SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: _publish,
              child: const Text('Publish'),
            ),
          ),
        ),
      ),
    );
  }
}