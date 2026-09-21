# Orderly Worker Web

واجهة ويب مستقلة للعامل فقط، متوافقة مع تطبيق Orderly APK.

## المزايا

- دخول معزول باستخدام `Restaurant ID` واسم المستخدم وكلمة المرور أو PIN.
- عرض الطلبات الخاصة بالعامل فقط.
- إنشاء طلبات وتحديث حالتها مع مزامنة Firebase.
- التقاط صورة إثبات من كاميرا iPhone.
- لا تحتوي على لوحة المدير أو إعداداته.

## التشغيل المحلي

```bash
flutter pub get
flutter run -d chrome --dart-define=FIREBASE_DATABASE_URL=https://YOUR_DATABASE.firebaseio.com
```

## البناء والنشر

```bash
flutter build web --release --base-href /orderly-worker-web/ --dart-define=FIREBASE_DATABASE_URL=https://YOUR_DATABASE.firebaseio.com
```

يوجد Workflow جاهز لـ GitHub Pages في `.github/workflows/deploy-pages.yml`.
أضف Secret باسم `FIREBASE_DATABASE_URL` ثم اختر GitHub Actions كمصدر Pages.
# orderly_worker_web

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

- Refresh deployment: 2026-09-21 19:41
