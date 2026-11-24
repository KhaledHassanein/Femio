// The Tools hub: the calculators that need nothing from her record (R11.5).
//
// Why it exists: the due-date, pregnancy-calendar and weight-gain tools answer a
// question in one sitting and save nothing, so any woman can open them from Learn,
// pregnant or not (rule 2: personalise, never restrict). The trackers that keep her
// readings (movements, contractions, appointments, weight) stay in Today's pregnancy
// tools, because they write to her record.

import 'package:flutter/material.dart';

import '../../data/library.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/femio_theme.dart';
import '../../theme/radii.dart';
import '../../theme/spacing.dart';
import 'due_date_tool_screen.dart';
import 'pregnancy_calendar_screen.dart';
import 'weight_gain_screen.dart';

/// The list of tools. [library] lets the pregnancy calendar open each week's guide.
class ToolsScreen extends StatelessWidget {
  const ToolsScreen({super.key, required this.library});
  final Library library;

  @override
  Widget build(BuildContext context) {
    final l = L10n.of(context);
    final p = context.palette;
    final t = Theme.of(context).textTheme;
    void open(Widget screen) => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => screen));
    return Scaffold(
      appBar: AppBar(title: Text(l.toolsTitle)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(space5, space2, space5, space8),
        children: [
          Text(l.toolsSub, style: t.bodyMedium?.copyWith(color: p.textMuted)),
          const SizedBox(height: space4),
          _ToolTile(
            icon: Icons.event_available_outlined,
            title: l.toolDueTitle,
            description: l.toolDueDesc,
            onTap: () => open(const DueDateToolScreen()),
          ),
          _ToolTile(
            icon: Icons.calendar_view_week_outlined,
            title: l.toolCalTitle,
            description: l.toolCalDesc,
            onTap: () => open(PregnancyCalendarScreen(library: library)),
          ),
          _ToolTile(
            icon: Icons.monitor_weight_outlined,
            title: l.toolGainTitle,
            description: l.toolGainDesc,
            onTap: () => open(const WeightGainScreen()),
          ),
        ],
      ),
    );
  }
}

class _ToolTile extends StatelessWidget {
  const _ToolTile({required this.icon, required this.title, required this.description, required this.onTap});
  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final t = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: space3),
      child: Material(
        color: p.surface,
        borderRadius: BorderRadius.circular(radiusLg),
        child: InkWell(
          borderRadius: BorderRadius.circular(radiusLg),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(space4),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: p.primarySoft,
                  foregroundColor: p.primarySoftText,
                  child: Icon(icon),
                ),
                const SizedBox(width: space3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: t.titleMedium),
                      const SizedBox(height: spaceHalf),
                      Text(description, style: t.bodySmall?.copyWith(color: p.textMuted)),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right_rounded, color: p.textSubtle, textDirection: Directionality.of(context)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
