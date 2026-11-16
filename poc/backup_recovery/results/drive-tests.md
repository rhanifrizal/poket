# Google Drive ciphertext probe status

Status: Not run; prerequisites are not configured.

No OAuth client, Google Cloud project, Drive test account, test domain, or upload was created or modified. The worktree contains no OAuth credentials or user data.

Blocking setup:
- development relying-party domain and matching web/iOS/Android app associations;
- dedicated development Google Cloud project with Drive API enabled;
- OAuth consent/test-user configuration and client IDs for the selected clients;
- a dedicated Google test account with available quota;
- replacement test clients on iOS, Android and web.

The planned probe uses the narrow drive.appdata scope, writes one synthetic encrypted envelope, verifies download and local restore, checks revocation/error/tamper handling, then deletes the object. No production backup claim is supported by the current evidence.

Official setup references are listed in poc/backup_recovery/drive/README.md.
