# البيانات والواجهة الخلفية (Data & Backend Overview)

التعامل مع البيانات هو جزء أساسي من أي تطبيق احترافي. في فلاتر، تشمل هذه العمليات جلب البيانات من الإنترنت، تحويلها من صيغ مثل JSON إلى كائنات، وتخزينها محلياً.

---

## 🌐 الاتصال بالإنترنت (Networking)

لجلب البيانات من RESTful APIs، نستخدم حزمة `http` الرسمية أو حزم متقدمة مثل `dio`. العملية تتم بشكل غير متزامن (Asynchronous) باستخدام `Future`.

### المبادئ الأساسية

* **استخدام `async` و `await`:** لضمان عدم توقف واجهة المستخدم أثناء جلب البيانات.
* **التعامل مع الأخطاء:** ضرورة استخدام `try-catch` للتعامل مع انقطاع الإنترنت أو أخطاء السيرفر.

---

## 📦 معالجة البيانات (Serialization / JSON)

بما أن البيانات تأتي عادة بصيغة JSON، نحتاج لتحويلها إلى كائنات دارت (Dart Objects) لتسهيل التعامل معها وتجنب الأخطاء الإملائية في أسماء الحقول.

* **اليدوية:** للنماذج الصغيرة.
* **الآلية (Code Generation):** باستخدام حزم مثل `json_serializable` للتطبيقات الكبيرة.

---

## 💾 التخزين المحلي (Local Persistence)

إذا كنت ترغب في عمل تطبيق يعمل بدون إنترنت (Offline-first)، يمكنك تخزين البيانات بعدة طرق:

1. **Shared Preferences:** للبيانات البسيطة (مثل تفضيلات المستخدم أو الإعدادات).
2. **SQLite (sqflite):** لقواعد البيانات الكبيرة والمعقدة التي تتطلب استعلامات (Queries).
3. **Hive / Isar:** خيارات حديثة وسريعة جداً تعتمد على تخزين الكائنات (NoSQL).

---

## 🔥 خدمات الواجهة الخلفية (Backend Services)

* **Firebase:** توفر جوجل تكاملاً ممتازاً مع فايربيز (Realtime Database, Firestore, Auth, Storage).
* **Supabase:** بديل مفتوح المصدر لفايربيز يعتمد على PostgreSQL.
* **Appwrite:** خيار آخر مفتوح المصدر وسهل الاستخدام.

---

## 🚦 الخطوة التالية

تعرف على كيفية ضمان جودة كودك في قسم **[الاختبار](../testing/overview.md)** أو اطلع على موارد إضافية في **[أفضل الممارسات](../best-practices/overview.md)**.

---

### 🔗 المراجع الأصلية (Original References)

التعامل مع البيانات يتطلب دقة عالية، يمكنك مراجعة التفاصيل هنا:

* **[الشبكات (Networking)](../flutter_official_docs/website_docs/src/content/data-and-backend/networking.md)**
* **[معالجة JSON (JSON and Serialization)](../flutter_official_docs/website_docs/src/content/data-and-backend/serialization/index.md)**
* **[التخزين المحلي (Persistence)](../flutter_official_docs/website_docs/src/content/data-and-backend/persistence/index.md)**
* **[إدارة الحالة (State Management)](../flutter_official_docs/website_docs/src/content/data-and-backend/state-mgmt/index.md)**
