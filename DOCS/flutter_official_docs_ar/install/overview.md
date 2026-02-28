# تثبيت البيئة (Install and Setup Overview)

لبدء تطوير تطبيقات فلاتر، تحتاج لإعداد بيئة العمل على جهازك. توفر فلاتر دعماً ممتازاً لأنظمة التشغيل الرئيسية الثلاث: Windows، macOS، و Linux.

---

## 🖥️ الخطوات العامة للتثبيت

1. **تحميل SDK:** قم بتحميل أحدث إصدار من فلاتر من الموقع الرسمي.
2. **فك الضغط:** ضع المجلد في مسار لا يحتاج لصلاحيات "مدير النظام" (مثلاً: `C:\dev\flutter`).
3. **تحديث Path:** أضف مسار الـ `bin` داخل مجلد فلاتر إلى متغيرات النظام لتتمكن من تشغيل الأوامر من أي مكان.
4. **أمر التحقق:** شغّل `flutter doctor` للتأكد من اكتمال التثبيت ومعرفة ما ينقصك (مثل Android Studio أو Xcode).

---

## 🛠️ تفاصيل حسب النظام

### ويندوز (Windows)

* يتطلب **Git for Windows**.
* تحتاج لتثبيت **Visual Studio** إذا كنت تخطط لبناء تطبيقات لسطح المكتب (Desktop apps).

### ماك (macOS)

* تحتاج لتثبيت **Xcode** لبناء تطبيقات iOS و macOS.
* يدعم فلاتر معالجات Intel و Apple Silicon (M1/M2/M3).

---

## ⌨️ إعداد المحرر (IDE)

* **VS Code:** ثبّت إضافة "Flutter" و "Dart".
* **Android Studio:** اذهب إلى Plugins وابحث عن "Flutter".

---

### 🔗 المراجع الأصلية (Original References)

للحصول على روابط التحميل وأحدث المتطلبات لكل نظام:

* **[تثبيت فلاتر (Install Flutter)](../flutter_official_docs/website_docs/src/content/install/index.md)**
* **[التثبيت على ويندوز (Windows Setup)](../flutter_official_docs/website_docs/src/content/install/windows/index.md)**
* **[التثبيت على ماك (macOS Setup)](../flutter_official_docs/website_docs/src/content/install/macos/index.md)**
