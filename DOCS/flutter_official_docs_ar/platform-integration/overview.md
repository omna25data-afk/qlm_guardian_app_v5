# تكامل المنصات (Platform Integration Overview)

رغم أن فلاتر تسمح لك بكتابة الكود مرة واحدة، إلا أنك ستحتاج أحياناً للتعامل مع خصائص فريدة لكل نظام (مثل الأندرويد أو الـ iOS) أو مواءمة تطبيقك ليناسب لغات وثقافات مختلفة.

---

## 🌍 التعريب والتدويل (Internationalization - i18n)

لجعل تطبيقك يدعم اللغة العربية والإنجليزية وغيرها:

* **اتجاه النص (RTL):** فلاتر تدعم الاتجاه من اليمين لليسار تلقائياً عند ضبط المحلية (Locale).
* **ملفات ARB:** استخدام ملفات `.arb` لتخزين الترجمات وتوليد الكود برمجياً.

---

## 📱 الوصول لميزات الجهاز (Native APIs)

عندما لا توفر فلاتر ودجت جاهزة لميزة معينة في النظام، نستخدم:

* **قنوات المنصة (Platform Channels):** وسيلة للتواصل بين كود دارت وكود النظام الأصلي (Java/Kotlin أو Swift).
* **MethodChannel:** لإرسال أوامر واستقبال نتائج.
* **EventChannel:** لاستقبال تدفق بيانات مستمر (مثل مستشعرات الحركة).

---

## 🍱 واجهات متجاوبة (Adaptive & Responsive UI)

* **Responsive:** الواجهة تتغير بناءً على حجم الشاشة (هاتف، تابلت، ويب). نستخدم `LayoutBuilder` أو `MediaQuery`.
* **Adaptive:** الواجهة تتغير لتبدو كأنها أصلية في النظام (مثلاً شكل شريط التنبيهات في آيفون يختلف عن أندرويد).

---

### 🔗 المراجع الأصلية (Original References)

للتواصل مع النظام أو دعم لغات متعددة:

* **[التعريب (Internationalization)](../flutter_official_docs/website_docs/src/content/ui/internationalization/index.md)**
* **[قنوات المنصة (Platform Channels)](../flutter_official_docs/website_docs/src/content/platform-integration/platform-channels.md)**
* **[واجهات متجاوبة (Adaptive Apps)](../flutter_official_docs/website_docs/src/content/ui/adaptive-responsive/index.md)**
