# قائمة المهام للتنفيذ (Tasks List)

هذه القائمة مبنية تفصيلياً على وثيقة التصميم `design.md`، ومقسمة لمراحل تُنفذ بالترتيب المنطقي.

## المرحلة الأولى: الطبقة التحتية وقاعدة البيانات (Infrastructure & Models)

- [x] 1. فحص تواجد الحقول المالية وحقل تاريخ القيد في قاعدة البيانات وموديل `RegistryEntry` (منجز خلال التصميم).
- [ ] 2. لا توجد حاجة إلى أي Migration جديد.

## المرحلة الثانية: منطق الأعمال والخدمات (Business Logic)

- [x] 3. تعديل `RegistryEntryResource.php` في Laravel:
  - [x] إضافة `support_amount`, `sustainability_amount`, `authentication_fee_amount`, `transfer_fee_amount`, `other_fee_amount` داخل قسم `fees`.
  - [x] تحديث معادلة الجمع في `total` لتشمل جميع الرسوم الإضافية.
  - [x] إضافة `guardian_hijri_date` داخل قسم `record_book`.
  - [x] إضافة `exemption_type` و `exemption_reason` في الجذر.
- [x] 4. التأكد من حفظ الملف واختباره برمجياً لضمان عدم وجود Syntax Error.

## المرحلة الثالثة: واجهات المستخدم (UI/Views)

- [ ] 5. فتح الواجهة الأمامية (Flutter) والتأكد من توافقية التسميات الجديدة مع `RegistryEntrySections.fromJson`.
- [ ] 6. التحقق من عرض البيانات بشكل صحيح في شاشة `EntryDetailsScreen.dart`.

## المرحلة الرابعة: الاختبار والمراجعة (Validation)

- [ ] 7. إجراء تحليل للكود (Flutter Analyzer / Dart Format) وتصحيح أي تحذيرات.
- [ ] 8. كتابة وتنفيذ اختبار مسار المستخدم باستخدام `flutter_driver` (User Journey Test) لتسجيل الدخول، فتح قيد، والتأكد من توفر البيانات المالية وتاريخ القيد.
- [ ] 9. بناء التحديث وتسليمه للمستخدم.
