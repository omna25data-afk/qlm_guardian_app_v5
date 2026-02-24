# التصميم المعماري (Design) - إدارة الأمناء

## 1. إعادة هيكلة المجلدات (Directory Restructuring)

سيتم نقل وتنظيم الملفات الحالية لتصبح أكثر ترتيباً وقابلية للصيانة:

**المسار الجديد:**
`lib/features/admin/presentation/screens/guardians/`

- `admin_guardians_screen.dart` (الشاشة الرئيسية التي تحوي التبويبات العلوية)
- `guardians_list_tab.dart` (تبويبة قائمة الأمناء)
- `guardian_renewals_tab.dart` (تبويبة التجديدات)
- `guardian_details_screen.dart` (شاشة تفاصيل الأمين المحدثة)
- `add_edit_guardian_screen.dart` / `guardian_wizard_form.dart` (نموذج الإضافة والتعديل الجديد)

**مسار ودجتات الأمناء:**
`lib/features/admin/presentation/widgets/guardians/`

- `guardian_list_card.dart` (تصميم البطاقة الجديد)
- `guardian_details_section.dart` (ودجت عام لأقسام التفاصيل)
- `guardian_info_grid_item.dart` (ودجت لعرض الحقل مع أيقونة في التفاصيل)

## 2. التحسينات المرئية والتصميم (UI/UX)

- **التبويبات العلوية**: استخدام `SegmentedButton` أو `TabBar` بتصميم Custom أنيق (مثل إضافة Container بخلفية رمادية فاتحة و Tab بحواف دائرية).
- **بطاقة الأمين**: تصميم يشمل صورة شخصية دائرية في اليمين، والاسم ورقم الهاتف في المنتصف، وشارة (Badge) لحالة الترخيص في اليسار.
- **التفاصيل**: الاعتماد على مكونات `Card` مقسمة من الداخل بـ `Wrap` أو `GridView.builder` لتوزيع الحقول بشكل شبكي (Grid)، مع استخدام أيقونات (HeroIcons مكافئة في Flutter) بجانب كل تسمية، وتلوين الحالات (أخضر=نشط، أحمر=منتهي، أصفر=قريب الانتهاء).
- **نماذج الإضافة/التعديل**: تطبيق تصميم (Stepper / Wizard form) لتسهيل إدخال البيانات الكثيرة، مقسمة إلى (المعلومات الشخصية، الهوية، المهنة، الترخيص).

## 3. التغييرات في الكود الموجود (Proposed Changes)

### `admin_screen.dart`

- تعديل زر "إدارة الأمناء" ليوجه إلى `AdminGuardiansScreen` الجديد.

### `admin_guardians_screen.dart` [NEW]

- شاشة رئيسية تحتوي على `DefaultTabController` و `TabBar` مخصص للتبديل بين قائمة الأمناء وتجديدات الرخص.

### `guardian_details_screen.dart` [MODIFY]

- إعادة كتابة واجهة المستخدم بالكامل لتعتمد على هيكلة الـ Sections المطابقة لـ `GuardiansInfolist.php` من الباك إند.

### `guardian_list_card.dart` [NEW]

- استخلاص كود بناء بطاقة الأمين من الشاشة الحالية إلى ودجت منفصل مع تحسين تصميمه وإضافة `Hero` animation للانتقال للتفاصيل.

## 4. التحقق (Verification)

- سيتم تشغيل التطبيق وعرض شاشات الأمناء من حساب الأدمن والتأكد من مطابقتها للمعايير التصميمية.
