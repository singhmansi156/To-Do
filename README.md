## Thought Process & Design Decisions

### Objective:
Build a ToDo list app with task reminders, prioritization, and a user-friendly interface.

### Tech Stack:
- Flutter (UI)
- GetX (State Management & Navigation)
- Local Notification Plugin (flutter_local_notifications)
- Shared Preferences (or StorageService for persistence)

### Features:
- Add, update, delete tasks
- Set due date with time and priority
- Schedule notifications
- Sort & search tasks

### UI Decisions:
- Clean Material Design
- Used `PopupMenuButton` for task actions
- Used `Snackbar` for validation feedback

### Notification Logic:
- If user sets a time too close to now, it schedules for 1 minute later
- Timezone is set to `Asia/Kolkata` to ensure accuracy

### Challenges:
- Device-specific notification permission
- MIUI/Vivo background app restrictions

