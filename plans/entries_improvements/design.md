# التصميم المعماري لتحسين تبويب القيود (النموذج المقسم)

## نظرة عامة

يهدف هذا التصميم إلى تحقيق عرض البيانات الديناميكية كاملة للأنواع السبعة من المحررات، تفعيل نظام التمرير اللانهائي (Infinite Pagination) لعرض جميع القيود بدلاً من 10 فقط، وربط نموذج الإضافة بشكل صحيح ليدعم العرض والتعديل الكامل شامل الحقول الديناميكية (Form Data).

التغييرات ستشمل كلاً من الواجهة الأمامية (Flutter) والواجهة الخلفية (Laravel) لدعم تحديث الحقول الديناميكية.

## 1. الواجهة الخلفية (Backend - Laravel)

بما أن نقطة النهاية الحالية `update` تتجاهل `form_data`، سنحتاج لتحديث الباكند ليقبل التعديل على الحقول الفرعية:

- **`RegistryEntryController.php`**:
  - في دالة `update`، تمرير الطلب إلى خدمة جديدة `RegistryEntryService@updateEntry` لمعالجة التحديث الشامل (الأساسي والفرعي).
- **`RegistryEntryService.php`**:
  - إنشاء دالة التحديث `updateEntry(RegistryEntry $entry, array $data, User $user)`.
  - تحديث بيانات الجدول المركزي `registry_entries`.
  - تحديث الجدول الفرعي (الموديل المرتبط عبر الـ Polymorphic relation الموجود في `contractable`) باستخدام بيانات `form_data`.

## 2. الواجهة الأمامية (Frontend - Flutter)

### 2.1. النماذج (Models)

- **`RegistryEntrySections.dart`**:
  - في `fromJson`، قراءة `json['contract_details']` وتعيينها للمتغير `formData`. هذا سيتيح للواجهة الأمامية الوصول لبيانات الجداول السبعة (مثل `seller_name`، `buyer_name`، إلخ).

### 2.2. الاتصال بالخادم (API & Repositories)

- **`system_repository.dart`** & **`admin_repository.dart`**:
  - إضافة دالة `updateRegistryEntry(int id, Map<String, dynamic> data)` لطلب `PUT /api/registry-entries/{id}`.

### 2.3. إدارة الحالة (State Management)

- **`all_entries_tab.dart` (AllEntriesNotifier)**:
  - إضافة متغيرات الـ Pagination: `int page = 1`, `bool hasMore = true`, `bool isFetchingMore = false`.
  - تعديل `fetchEntries()` لجلب صفحة جديدة ودمجها مع القائمة إذا لم تكن عملية `refresh`.
  - إضافة دالة `loadMore()` تُستدعى من الـ UI.
- **`add_entry_provider.dart` (AddEntryNotifier)**:
  - إضافة دالة `updateEntry(int id, Map<String, dynamic> data)` تستدعي الـ Repository، وتُرجع حالة النجاح.

### 2.4. واجهة المستخدم (UI)

- **`record_books_tab.dart`** (تبويب القيود / AllEntriesTab):
  - إضافة `ScrollController` واستخدام `NotificationListener<ScrollNotification>` على `ListView.builder` لتفعيل `loadMore` عند الوصول للأسفل.
  - إظهار مؤشر تحميل (Loading Indicator) في نهاية القائمة أثناء جلب المزيد.
- **`PremiumEntryCard`**:
  - تحديث حدث النقر `onTap` أو زر التعديل لفتح `CompactRegistryEntryScreen` ممرراً الـ `entry`.
- **`CompactRegistryEntryScreen`**:
  - في `_initializeData()`: إذا كان `initialData != null`، يتم قراءة الـ `formData` وتعبئة حقول `_dynamicControllers` تلقائياً عبر مطابقة المفاتيح.
  - في `_submitForm()`: التحقق إذا كان `widget.initialData?.id != null`، فيتم استدعاء `notifier.updateEntry()` بدلاً من `submitEntry()`.
  - *تحسين العرض*: إما إبقاء الشاشة كنموذج إدخال قابل للتعديل بالكامل، أو تمرير flag (مثل `isReadOnly`) لتعطيل الإدخال للحقول إذا كان المطلوب "عرض" فقط. سنفترض حالياً أن النقر على הקيد يفتحها بوضع التعديل لتسهيل التبادل.

## 3. تدفق البيانات (Data Flow) عند التعديل

1. المستخدم ينقر على قيد في قائمة `AllEntriesTab`.
2. تُفتح شاشة `CompactRegistryEntryScreen`، وتعرض البيانات الأساسية (الأطراف، الرسوم) والبيانات الديناميكية من `formData`.
3. يقوم المستخدم بتعديل حقل ديناميكي (مثلاً `sale_price`).
4. عند الضغط على "حفظ"، تُجمع البيانات وترسل عبر `updateEntry` كطلب `PUT`.
5. يستقبل الباكند الطلب، يحدّث الجدول الأساسي والجدول الفرعي.
6. يعود التطبيق بتأكيد نجاح ويُحدّث القائمة عبر استدعاء نقطة النهاية للصورة المحدثة للقيد.

## 4. خطة التنفيذ المقترحة

1. تطبيق تغييرات النماذج والباكند الأساسية.
2. تفعيل التمرير اللانهائي (Pagination) في شاشة القيود لعرض جميع القيود.
3. تحديث نموذج الإضافة المقسم لدعم تعبئة بيانات التعديل.
4. تحديث نقاط الاتصال (Repositories) وتفعيل الإرسال.
5. الاختبار والمطابقة.
