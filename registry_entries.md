# توثيق جدول القيود المركزي (Registry Entries Schema)

**اسم الجدول:** `registry_entries`
**الوصف:** الجدول المركزي لتخزين جميع قيود العقود والوثائق (زواج، طلاق، بيع، وكالات، إلخ) ويربط بين الأمناء، سجلات التوثيق، والأطراف.

## هيكل الجدول (Table Structure)

| اسم العمود (English) | اسم العمود (عربي) | النوع (Type) | الوصف (Description) |
| :--- | :--- | :--- | :--- |
| **البيانات الأساسية** | | | |
| `id` | المعرف | Integer | المعرف الفريد للقيد (Primary Key). |
| `serial_number` | الرقم التسلسلي | Integer | رقم تسلسلي عام للقيد. |
| `hijri_year` | السنة الهجرية | Integer | السنة الهجرية التي يتبع لها القيد. |
| `constraint_type_id` | معرف نوع القيد | Foreign ID | يرتبط بجدول `constraint_types`. يحدد نوع القيد (زواج، طلاق، إلخ). |
| `contract_type_id` | معرف نوع العقد | Foreign ID | يرتبط بجدول `contract_types`. يحدد التفاصيل الدقيقة للعقد. |
| **الأطراف** | | | |
| `first_party_name` | اسم الطرف الأول | String | اسم الطرف الأول في العقد (مثلاً الزوج، البائع). |
| `second_party_name` | اسم الطرف الثاني | String | اسم الطرف الثاني في العقد (مثلاً الزوجة، المشتري). |
| **الكاتب / المحرر** | | | |
| `writer_type` | نوع الكاتب | Enum | نوع كاتب المحرر (`guardian`, `documentation`, `external`). الافتراضي `guardian`. |
| `writer_id` | معرف الكاتب | Foreign ID | يرتبط بجدول `users`. معرف المستخدم الذي قام بالكتابة. |
| `other_writer_id` | معرف الكاتب الآخر | Foreign ID | يرتبط بجدول `other_writers`. في حال كان الكاتب من خارج النظام. |
| `writer_name` | اسم الكاتب | String | اسم كاتب المحرر (نصي). |
| **التواريخ** | | | |
| `document_hijri_date` | تاريخ التحرير (هـ) | Date | تاريخ تحرير الوثيقة بالهجري. |
| `document_gregorian_date` | تاريخ التحرير (م) | Date | تاريخ تحرير الوثيقة بالميلادي. |
| **بيانات قيد التوثيق (قلم المحكمة)** | | | |
| `doc_record_book_id` | معرف سجل التوثيق | Foreign ID | يرتبط بجدول `record_books`. السجل الذي تم فيه التوثيق. |
| `doc_record_book_number` | رقم سجل التوثيق | Integer | رقم السجل الفعلي للتوثيق (نسخة للمعالجة السريعة). |
| `doc_page_number` | رقم الصفحة (توثيق) | Integer | رقم الصفحة في سجل التوثيق. |
| `doc_entry_number` | رقم القيد (توثيق) | Integer | رقم القيد المتسلسل في سجل التوثيق. |
| `doc_box_number` | رقم الصندوق | Integer | رقم الصندوق (البوكس) المحفوظ فيه الوثيقة. |
| `doc_document_number` | رقم الوثيقة | Integer | رقم الوثيقة داخل الصندوق. |
| `doc_hijri_date` | تاريخ القيد (هـ) | Date | تاريخ القيد في سجل التوثيق بالهجري. |
| `doc_gregorian_date` | تاريخ القيد (م) | Date | تاريخ القيد في سجل التوثيق بالميلادي. |
| **بيانات الرسوم والمالية** | | | |
| `fee_amount` | مبلغ الرسوم | Decimal | الرسوم الأساسية. |
| `penalty_amount` | مبلغ الغرامة | Decimal | غرامة التأخير إن وُجدت. |
| `has_authentication_fee` | رسوم مصادقة؟ | Boolean | هل يوجد رسوم مصادقة (400 ريال)؟ |
| `authentication_fee_amount` | قيمة رسوم المصادقة | Decimal | قيمة رسوم المصادقة. |
| `has_transfer_fee` | رسوم انتقال؟ | Boolean | هل يوجد رسوم انتقال (400 ريال)؟ |
| `transfer_fee_amount` | قيمة رسوم الانتقال | Decimal | قيمة رسوم الانتقال. |
| `has_other_fee` | رسوم أخرى؟ | Boolean | هل يوجد رسوم أخرى (400 ريال)؟ |
| `other_fee_amount` | قيمة الرسوم الأخرى | Decimal | قيمة الرسوم الأخرى. |
| `support_amount` | مبلغ الدعم | Decimal | مبلغ الدعم المخصصة. |
| `sustainability_amount` | الاستدامة | Decimal | مبلغ الاستدامة. |
| `receipt_number` | رقم السند | String | رقم سند القبض (الإيصال). |
| `exemption_type` | نوع الإعفاء | String | `null`, `full`, `fees`, `penalty`, `government`, `poor` |
| `exemption_reason` | سبب الإعفاء | String | وصف سبب الإعفاء. |
| **بيانات قيد الأمين** | | | |
| `guardian_id` | معرف الأمين | Foreign ID | يرتبط بجدول `legitimate_guardians`. الأمين الشرعي المسؤول. |
| `guardian_record_book_id` | معرف سجل الأمين | Foreign ID | يرتبط بجدول `record_books`. سجل الأمين الخاص. |
| `guardian_record_book_number` | رقم سجل الأمين | Integer | رقم السجل الفعلي للأمين (نسخة للمعالجة السريعة). |
| `guardian_page_number` | رقم الصفحة (أمين) | Integer | رقم الصفحة في سجل الأمين. |
| `guardian_entry_number` | رقم القيد (أمين) | Integer | رقم القيد المتسلسل في سجل الأمين. |
| `guardian_hijri_date` | تاريخ القيد (أمين) | Date | تاريخ تقييد الوثيقة لدى الأمين (هجري). |
| **العلاقات المتقدمة والحالة** | | | |
| `constraintable_type` | نوع القيد المفصل | String | نوع النموذج المرتبط بتفاصيل العقد (Polymorphic). |
| `constraintable_id` | معرف القيد المفصل | Unsigned Big Integer | معرف السجل في الجدول التفصيلي المرتبط. |
| `status` | الحالة | Enum | حالة القيد: `draft`, `registered_guardian`, `pending_documentation`, `documented`, `rejected`. |
| `delivery_status` | حالة التسليم | Enum | حالة تسليم الوثيقة: `kept` (محفوظة), `delivered` (سلمت). |
| **بيانات النظام** | | | |
| `notes` | ملاحظات | Text | ملاحظات عامة على القيد. |
| `created_by` | أُنشئ بواسطة | Foreign ID | يرتبط بجدول `users`. المستخدم الذي أنشأ السجل. |
| `created_at` | تاريخ الإنشاء | Timestamp | وقت وتاريخ إنشاء السجل في النظام. |
| `updated_at` | تاريخ التحديث | Timestamp | وقت وتاريخ آخر تعديل. |
| `deleted_at` | تاريخ الحذف | Timestamp | تاريخ الحذف المؤقت (Soft Delete). |
