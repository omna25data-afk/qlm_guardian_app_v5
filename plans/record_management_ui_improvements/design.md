# التصميم المعماري (Design)

## نظرة عامة

بناءً على المتطلبات، سنقوم بتحديث واجهات إدارة السجلات (التبويبات وبطاقات العرض) لتعزيز تجربة المستخدم وإظهار تفاصيل أوفى عن السجلات والقيود، إلى جانب توفير خيارات متقدمة للتحكم في عرض البيانات (فرز، تصفية، عرض بطولات مختلفة، تجميع). سيتم الاعتماد حصرياً على المتغيرات الحقيقية الموجودة في النماذج `RecordBook` و `RegistryEntrySections`.

## 1. بطاقة السجل (`PremiumRecordBookCard`)

**الملف:** `lib/features/admin/presentation/widgets/premium_record_book_card.dart`
التعديلات (توسيع القسم الأوسط Main Info):

- **فئة السجل ومجموعته**: عرض الحقلين `recordCategory` و `recordGroup` إلى جانب `category`.
- **تواريخ الإجراءات (بالهجري)**: عرض `openingProcedureDateHijri` (تاريخ الافتتاح) و `closingProcedureDateHijri` (تاريخ الإغلاق) إن وجدت.
- **تفاصيل النموذج والوزارة**: عرض رقم النموذج `formNumber` ورقم السجل بالوزارة `ministryRecordNumber`.
- **قيود السجل**: عرض `startConstraintNumber` إلى `endConstraintNumber` لتوضيح النطاق المخصص للسجل من القيود.

## 2. بطاقة القيد (`PremiumEntryCard`)

**الملف:** `lib/features/admin/presentation/widgets/premium_entry_card.dart`
التعديلات:

- **تحديث حالة القيد**: التأكد من مطابقتها لحالات `RegistryEntryStatus` (مسودة `draft`، مقيد لدى الأمين `registered_guardian`، بانتظار التوثيق `pending_documentation`، موثق `documented`، مرفوض `rejected`) بالاعتماد على `entry.statusInfo.status`.
- **البيانات المالية**: إضافة قسم يعرض `entry.financialInfo.totalAmount` (الرسوم الإجمالية) و `entry.financialInfo.paidAmount` (المبلغ المدفوع)، ويمكن عرض تفاصيل مصغرة مثل رسوم المصادقة `authenticationFeeAmount` ورسوم الانتقال `transferFeeAmount`.
- **بيانات قيد الأمين**: إضافة بيانات قيد الأمين من `entry.guardianInfo` وتتضمن رقم السجل الفعلي `guardianRecordBookNumber`، رقم الصفحة `guardianPageNumber`، رقم القيد المتسلسل `guardianEntryNumber`، وتاريخ التقييد `guardianHijriDate`.
- **بيانات قيد التوثيق (قلم المحكمة)**: إضافة بيانات الوثيقة من `entry.documentInfo` مثل رقم السجل الفعلي `docRecordBookNumber`، رقم الصفحة `docPageNumber`، ورقم القيد المتسلسل `docEntryNumber`.
- **بيانات الكاتب**: عرض نوع الكاتب `entry.writerInfo.writerType` واسم الكاتب `entry.writerInfo.writerName`.
- **أيقونة التعديل**: إضافة `IconButton` (شكل قلم) في البطاقة، يستدعي دالة تمرر كـ `onEdit` لفتح `CompactRegistryEntryScreen` وتمرير بيانات القيد الحالي كـ `initialData`.

## 3. الأيقونات والأدوات في التبويبات الثلاثة

التبويبات:

- `lib/features/admin/presentation/screens/tabs/record_books_tab.dart`
- `lib/features/admin/presentation/screens/tabs/all_entries_tab.dart`
- `lib/features/admin/presentation/screens/tabs/inspection_tab.dart`

**التعديلات (في كل تبويب):**

- إضافة شريط أدوات (Toolbar) أو صف من الأيقونات استكمالاً لحقل البحث الحالي (`SearchBar` المخصص).
- الأيقونات المطلوبة:
  - **الفرز (Sort)**: `Icons.sort`
  - **التصفية (Filter)**: `Icons.filter_alt_outlined`
  - **طريقة العرض (View Type)**: `Icons.grid_view` أو `Icons.list`
  - **التجميع (Group By)**: `Icons.folder_copy_outlined`
- سيتم ربط هذه الأيقونات مبدئياً بـ `BottomSheet` أو عرض رسالة (SnackBar/Dialog مؤقت) لتوضيح الغرض منها.

## 4. التحقق والاختبار (Verification)

- سيتم إنشاء اختبار User Journey باستخدام `flutter_driver` (`flutter_driver_user_journey_test` MCP tool) يغطي:
  - التوجه لتبويبات السجلات.
  - التحقق من وجود الأيقونات الجديدة.
  - التحقق من ظهور البيانات الإضافية المذكورة أعلاه في بطاقتي السجل والقيد.
  - تجربة النقر على زر تعديل القيد للتأكد من فتح نافذة التعديل بالشكل المطلوب.
