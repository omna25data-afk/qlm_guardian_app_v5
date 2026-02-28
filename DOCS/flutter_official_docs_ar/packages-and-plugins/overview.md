# الحزم والإضافات (Packages and Plugins Overview)

يعتمد مجتمع فلاتر بشكل كبير على المشاركة. بدلاً من بناء كل شيء من الصفر، يمكنك استخدام آلاف الحزم (Packages) التي أنشأها مطورون آخرون وجوجل لتسريع عملية التطوير.

---

## 📦 موقع Pub.dev

هو المستودع الرسمي للحزم الخاصة بدارت وفلاتر. يمكنك البحث فيه عن أي ميزة تحتاجها (مثل: الكاميرا، الخرائط، تسجيل الدخول).

### أنواع الحزم

1. **حزم دارت (Dart Packages):** مكتوبة بلغة دارت فقط (مثل حزم معالجة النصوص أو الوقت).
2. **إضافات فلاتر (Plugin Packages):** تحتوي على كود دارت بالإضافة إلى كود خاص بالمنصة (Kotlin/Java للاندرويد، Swift/Obj-C للـ iOS) للوصول لميزات الجهاز.

---

## 🛠️ إدارة الحزم (Managing Dependencies)

يتم إدارة الحزم في ملف `pubspec.yaml`.

### إضافة حزمة جديدة

يمكنك إضافة الحزمة يدوياً في قسم `dependencies` أو استخدام سطر الأوامر:

```bash
flutter pub add name_of_package
```

### تحديث الحزم

```bash
flutter pub upgrade
```

---

## 📝 أفضل الممارسات عند اختيار حزمة

* **عدد النقاط (Pub Points):** يشير إلى مدى جودة الكود واتباعه للمعايير.
* **الشعبية (Popularity):** كم عدد المطورين الذين يستخدمونها.
* **التحديث المستمر:** تأكد من أن الحزمة تدعم أحدث إصدار من فلاتر.

---

### 🔗 المراجع الأصلية (Original References)

لمعرفة المزيد عن كيفية نشر حزمك الخاصة أو التعامل المتقدم مع الاعتمادات:

* **[استخدام الحزم (Using Packages)](../flutter_official_docs/website_docs/src/content/packages-and-plugins/using-packages.md)**
* **[تطوير الإضافات (Developing Plugins)](../flutter_official_docs/website_docs/src/content/packages-and-plugins/developing-packages.md)**
* **[موقع Pub.dev](https://pub.dev)**
