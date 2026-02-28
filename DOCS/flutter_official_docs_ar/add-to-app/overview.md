# إضافة فلاتر لتطبيق موجود (Add-to-App Overview)

لا تقتصر فلاتر على بناء تطبيقات من الصفر. يمكنك دمج شاشات أو ميزات فلاتر داخل تطبيق أندرويد أو iOS موجود مُسبقاً، مما يسمح لك ببدء الاستخدام تدريجياً أو استغلال قوة فلاتر في أجزاء معينة فقط.

---

## 🏗️ كيف يعمل الدمج؟

عند استخدام **Add-to-App**، تقوم بإنشاء **Flutter Module** بدلاً من **Flutter App**. هذا المديول يتم استهلاكه كاعتماد (Dependency) داخل مشروعك الأصلي.

### الخيارات المتاحة

* **دمج شاشة كاملة:** فتح صفحة فلاتر كاملة بضغطة زر من التطبيق الأصلي.
* **دمج جزء من الشاشة:** استخدام فلاتر داخل `Fragment` في أندرويد أو `Child View Controller` في iOS.
* **استخدام منطق الكود:** تشغيل كود دارت في الخلفية دون واجهة مرئية.

---

## 🛠️ الخطوات الأساسية

1. **إنشاء المديول:**

    ```bash
    flutter create -t module my_flutter_module
    ```

2. **إعداد المشروع الأصلي:** إضافة المديول كاعتماد في `settings.gradle` (للأندرويد) أو `Podfile` (للـ iOS).
3. **تشغيل محرك فلاتر (FlutterEngine):** يفضل البدء بتشغيل المحرك مبكراً لضمان سرعة عرض الواجهة عند طلبها.

---

## ⚠️ اعتبارات هامة

* **حجم التطبيق:** دمج فلاتر سيضيف بضعة ميجابايتات لحجم التطبيق النهائي.
* **إدارة الذاكرة:** يجب الانتباه لإدارة محركات فلاتر (Engines) لضمان عدم استهلاك الذاكرة بشكل مفرط.

---

### 🔗 المراجع الأصلية (Original References)

عملية الدمج قد تكون معقدة، اتبع الدليل التفصيلي لكل منصة:

* **[إضافة فلاتر للأندرويد (Add to Android)](../flutter_official_docs/website_docs/src/content/add-to-app/android/index.md)**
* **[إضافة فلاتر للـ iOS (Add to iOS)](../flutter_official_docs/website_docs/src/content/add-to-app/ios/index.md)**
* **[تصحيح الأخطاء (Debugging)](../flutter_official_docs/website_docs/src/content/add-to-app/debugging.md)**
* **[إدارة المحركات المتعددة (Multiple Flutters)](../flutter_official_docs/website_docs/src/content/add-to-app/multiple-flutters.md)**
