# النشر (Deployment Overview)

عملية النشر هي اللحظة الحاسمة التي تصل فيها جهودك إلى المستخدمين النهائيين. كل منصة (Android, iOS, Web) لها متطلباتها الخاصة لإنتاج نسخة تعمل بكفاءة وأمان.

---

## 🤖 منصة الأندرويد (Android)

لإنشاء نسخة APK أو App Bundle (AAB):

```bash
flutter build appbundle
```

**متطلبات هامة:**

* **التوقيع (Signing):** يجب إنشاء مفتاح خاص (Upload Key) وتوقيع التطبيق قبل رفعه لمتجر Google Play.
* **حجم التطبيق:** يفضل استخدام AAB لتقليل حجم التحميل للمستخدمين.

---

## 🍏 منصة iOS

يتطلب النشر جهاز Mac وحساب مطور لدى آبل:

```bash
flutter build ios --release
```

**متطلبات هامة:**

* **Xcode:** يتم إجراء التجهيزات النهائية (Icons, Launch Screen) داخل Xcode.
* **TestFlight:** يمكنك استخدام خدمة TestFlight لاختبار التطبيق قبل رفعه لمتجر App Store.

---

## 🌐 الويب (Web)

```bash
flutter build web
```

يتم إنتاج مجلد `build/web` الذي يمكنك رفعه على أي خادم (مثل Firebase Hosting أو GitHub Pages).

---

### 🔗 المراجع الأصلية (Original References)

النشر عملية دقيقة، يرجى قراءة الخطوات بالتفصيل:

* **[دليل النشر للأندرويد (Build for Android)](../flutter_official_docs/website_docs/src/content/deployment/android.md)**
* **[دليل النشر للـ iOS (Build for iOS)](../flutter_official_docs/website_docs/src/content/deployment/ios.md)**
* **[النشر على الويب (Web Deployment)](../flutter_official_docs/website_docs/src/content/deployment/web.md)**
* **[إصدارات فلاتر (Releasing Updates)](../flutter_official_docs/website_docs/src/content/release/index.md)**
