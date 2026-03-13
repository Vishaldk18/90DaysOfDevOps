🔑 Owner vs Group — What’s the Difference?
👤 1. Owner (User Owner)

The owner is usually the user who created the file or directory.
This person has specific permissions on the file (read, write, execute).
Only the owner (or root) can change the file’s permissions using chmod.

Example:
If vishal creates a file:

Owner = vishal


👥 2. Group (Group Owner)

Every file also belongs to a group.
Anyone who is a member of that group can access the file according to group permissions (read, write, execute).
A group may contain multiple users.

Example:
If the file belongs to group devteam:

All users in devteam share the group permissions for this file.


📂 How Permissions Are Structured
File permissions have 3 categories:

























CategoryApplies ToExample PermissionsOwnerSingle user (file creator)rw-GroupUsers in the file’s groupr--OthersEveryone else on the systemr--
