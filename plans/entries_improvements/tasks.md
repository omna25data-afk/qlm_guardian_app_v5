# تقسيم مهام تحسين تبويب القيود (النموذج المقسم)

## المرحلة 1: النماذج والباكند الأساسي (Core Models & Backend)

- [ ] تحديث `RegistryEntrySections.dart`:
  - في دالة `fromJson`، وتعيين حقل `formData` ليقرأ من `json['contract_details']`.
- [ ] تحديث `RegistryEntryController.php` (الباكند):
  - التحقق من تمرير `form_data` واستدعاء `updateEntry` في الدالة.
- [ ] تحديث `RegistryEntryService.php` (الباكند):
  - إنشاء وتضمين دالة `updateEntry` التي تقرأ `form_data` وتحدّث الجدول الفرعي لبيانات العقد (مثل `SaleContract`, `MarriageContract` وما إلى ذلك).

## المرحلة 2: إدارة الحالة والمزودين (State & Providers)

- [ ] تحديث `system_repository.dart` و `admin_repository.dart`:
  - إضافة `putRegistryEntriesId` لدعم إرسال بيانات التعديل `PUT /api/registry-entries/{id}`.
- [ ] تحديث `AddEntryNotifier` (في `add_entry_provider.dart`):
  - إضافة دالة `updateEntry` مشابهة لـ `submitEntry` لدعم تعديل القيد.
- [ ] تحديث `AllEntriesNotifier` (في `all_entries_tab.dart`):
  - دعم التمرير اللانهائي (Pagination) واستبدال الكود الحالي ليدعم حالة `page`, `hasMore`, `isFetchingMore`.
  - تحديث الدالة `fetchEntries()` لتجلب الصفحة التالية دون محو الصفحات القديمة.

## المرحلة 3: واجهة نموذج الإضافة والتعديل (Editor UI)

- [ ] تحديث `CompactRegistryEntryScreen`:
  - في دالة `_initializeData()`: التأكد من مطابقة مفاتيح `formData` مع الحقول المتاحة وتعبئة `_dynamicControllers`.
  - في دالة `_submitForm()`: التأكد من أن التعديل يتم عبر `updateEntry` إذا كان السجل موجوداً (يحتوي على `id`).

## المرحلة 4: واجهة تبويب القيود (Entries UI)

- [ ] تحديث `AllEntriesTab`:
  - إضافة `ScrollController` واستخدام `NotificationListener<ScrollNotification>` لجلب المزيد من القيود عند الوصول للأسفل.
  - إظهار مؤشر `CircularProgressIndicator` أسفل الشاشة أثناء تحميل المزيد.
- [ ] تحديث `PremiumEntryCard` في قائمة العرض:
  - عند النقر `onTap`، فتح الشاشة `CompactRegistryEntryScreen` ممررًا بيانات السجل `entry`.

## المرحلة 5: الاختبار والمطابقة (Validation)

- [ ] التحقق من `dart analyze`.
- [ ] إخطار المستخدم بإمكانية تجربة تعديل قيد مبيعات ومعاينة الـ Pagination.
