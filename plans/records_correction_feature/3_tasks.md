## قائمة المهام التفصيلية (Task Breakdown)

### 1. طبقة البيانات والخلفية (Backend & Data Layer)

- [x] **المهمة 1:** مراجعة الـ API على طرف الخادم (Laravel) للتأكد من وجود (أو إنشاء) طرق PUT/PATCH لتحديث `RecordBook` و `RegistryEntry`، وإضافة/تحديث Validation Rules.
- [x] **المهمة 2:** في Flutter، تحديث `RecordBookRepository` و `AllEntriesRepository` (أو من يمثلهم) وإضافة دوال الاتصال بأمر التحديث للـ API.

### 2. واجهة المستخدم (User Interface)

- [x] **المهمة 3:** إنشاء UI المكون الجديد `RecordBookCorrectionDialog` وإضافة الـ Controllers للتعديل.
- [x] **المهمة 4:** إنشاء UI المكون الجديد `RegistryEntryCorrectionDialog` وإضافة الـ Controllers للتعديل.
- [x] **المهمة 5:** ربط الـ ListTiles أو Cards في `RecordBooksTab` و `AllEntriesTab` لتفتح الـ Dialogs.
- [x] **المهمة 6:** ربط الـ Save Button بمدير الحالة (Riverpod) ليقوم بتشغيل دوال التحميل والتحديث ومعالجة رسائل الغلط ثم إغلاق النافذة بنجاح.
- [ ] **المهمة 7:** اختبار العملية للتأكد من تعديل البيانات وإعادة تصفح الصفحة وتأكيد التحديث.
