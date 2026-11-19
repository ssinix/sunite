import 'package:flutter/material.dart';
import 'package:sunite/models/user_profile.dart';
import 'package:sunite/utils/app_spacing.dart';

// 13. Edit Profile: edits year, majors, minors and skills.
//
// Normal use: opened from My Profile; Save returns the updated profile
// with Navigator.pop.
// First-time setup (isFirstTimeSetup: true): opened after e-mail
// verification; the title is "Set up your profile", there is no back
// arrow, and Save goes to Home.
class EditProfileScreen extends StatefulWidget {
  final UserProfile profile;
  final bool isFirstTimeSetup;

  const EditProfileScreen({
    super.key,
    required this.profile,
    this.isFirstTimeSetup = false,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _skillController = TextEditingController();

  String? _year;
  late List<String> _majors;
  late List<String> _minors;
  late List<String> _skills;

  // Shown under Majors after the user taps Save with no major added
  bool _showMajorError = false;

  @override
  void initState() {
    super.initState();
    // Copy the lists so changes are not saved until the user taps Save
    final year = widget.profile.year;
    _year = yearOptions.contains(year) ? year : null;
    _majors = List.of(widget.profile.majors);
    _minors = List.of(widget.profile.minors);
    _skills = List.of(widget.profile.skills);
  }

  @override
  void dispose() {
    _skillController.dispose();
    super.dispose();
  }

  // Adds an item if it's not empty and not already in the list
  void _addTo(List<String> list, String value) {
    final item = value.trim();
    if (item.isEmpty) return;
    final exists = list.any((e) => e.toLowerCase() == item.toLowerCase());
    if (exists) return;
    setState(() {
      list.add(item);
      _showMajorError = false;
    });
  }

  // Small dialog with one text field, used for "+ Add major / minor"
  Future<void> _showAddDialog(String title, List<String> list) async {
    final controller = TextEditingController();
    final value = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          autofocus: true,
          textCapitalization: TextCapitalization.words,
          onSubmitted: (text) => Navigator.pop(context, text),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text('Add'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (value != null) _addTo(list, value);
  }

  void _save() {
    final formValid = _formKey.currentState!.validate();
    setState(() {
      _showMajorError = _majors.isEmpty;
    });
    if (!formValid || _majors.isEmpty) return;

    final updated = widget.profile.copyWith(
      year: _year,
      majors: _majors,
      minors: _minors,
      skills: _skills,
    );

    if (widget.isFirstTimeSetup) {
      // TODO: save the profile to the backend once it exists
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    } else {
      Navigator.pop(context, updated);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final labelStyle =
        textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isFirstTimeSetup ? 'Set up your profile' : 'Edit Profile',
        ),
        // No back arrow during first-time setup
        automaticallyImplyLeading: !widget.isFirstTimeSetup,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: AppSpacing.screenPadding,
          children: [
            // Avatar with name and e-mail (these can't be edited)
            Center(
              child: CircleAvatar(
                radius: 36,
                backgroundColor: colors.surfaceContainerHighest,
                child: Icon(Icons.person, size: 40, color: colors.outline),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              '${widget.profile.fullName} · ${widget.profile.email}',
              textAlign: TextAlign.center,
              style: textTheme.bodySmall
                  ?.copyWith(color: colors.onSurfaceVariant),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Year of study
            Text('Year of study', style: labelStyle),
            const SizedBox(height: AppSpacing.sm),
            DropdownButtonFormField<String>(
              initialValue: _year,
              hint: const Text('Select your year'),
              decoration: const InputDecoration(border: OutlineInputBorder()),
              items: [
                for (final year in yearOptions)
                  DropdownMenuItem(value: year, child: Text(year)),
              ],
              onChanged: (value) => setState(() => _year = value),
              validator: (value) =>
                  value == null ? 'Please select your year' : null,
            ),
            const SizedBox(height: AppSpacing.md),

            // Majors
            Text('Majors', style: labelStyle),
            const SizedBox(height: AppSpacing.sm),
            _ChipList(
              items: _majors,
              addLabel: 'Add major',
              onRemove: (item) => setState(() => _majors.remove(item)),
              onAdd: () => _showAddDialog('Add major', _majors),
            ),
            if (_showMajorError)
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.xs),
                child: Text(
                  'Add at least one major',
                  style: textTheme.bodySmall?.copyWith(color: colors.error),
                ),
              ),
            const SizedBox(height: AppSpacing.md),

            // Minors
            Text('Minors', style: labelStyle),
            const SizedBox(height: AppSpacing.sm),
            _ChipList(
              items: _minors,
              addLabel: 'Add minor',
              onRemove: (item) => setState(() => _minors.remove(item)),
              onAdd: () => _showAddDialog('Add minor', _minors),
            ),
            const SizedBox(height: AppSpacing.md),

            // Skills: typed into the field and added with Enter or +
            Text('Skills', style: labelStyle),
            const SizedBox(height: AppSpacing.sm),
            _ChipList(
              items: _skills,
              onRemove: (item) => setState(() => _skills.remove(item)),
            ),
            const SizedBox(height: AppSpacing.sm),
            TextField(
              controller: _skillController,
              decoration: InputDecoration(
                hintText: 'Add a skill…',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  tooltip: 'Add skill',
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    _addTo(_skills, _skillController.text);
                    _skillController.clear();
                  },
                ),
              ),
              onSubmitted: (text) {
                _addTo(_skills, text);
                _skillController.clear();
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: AppSpacing.screenPadding,
          child: FilledButton(
            onPressed: _save,
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(48),
            ),
            child: const Text('Save'),
          ),
        ),
      ),
    );
  }
}

// Removable chips, plus an optional "+ Add" chip at the end
class _ChipList extends StatelessWidget {
  final List<String> items;
  final void Function(String item) onRemove;
  final String? addLabel;
  final VoidCallback? onAdd;

  const _ChipList({
    required this.items,
    required this.onRemove,
    this.addLabel,
    this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: [
        for (final item in items)
          InputChip(
            label: Text(item),
            onDeleted: () => onRemove(item),
          ),
        if (onAdd != null)
          ActionChip(
            avatar: const Icon(Icons.add, size: 18),
            label: Text(addLabel ?? 'Add'),
            onPressed: onAdd,
          ),
      ],
    );
  }
}
