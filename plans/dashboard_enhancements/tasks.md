# قائمة المهام للتنفيذ (Tasks List)

هذه القائمة مبنية تفصيلياً على وثيقة التصميم `design.md`، ومقسمة لمراحل تُنفذ بالترتيب المنطقي.

## المرحلة الأولى: بناء واجهة التبويبات (Tabs Infrastructure)

- [ ] 1. إنشاء ملف `lib/features/reports/presentation/screens/main_dashboard_screen.dart`.
- [ ] 2. إضافة `DefaultTabController` و `Scaffold` بـ `AppBar` يحتوي على `TabBar` (تبويب للإحصائيات وتبويب للتقارير).
- [ ] 3. وضع `TabBarView` فارغ مبدئياً لانتظار المكونات.

## المرحلة الثانية: تجهيز المكونات الحالية كـ Tabs

- [ ] 4. إعادة هيكلة `GuardianStatisticsScreen` لإزالة الـ `Scaffold` والـ `AppBar` الخاص بها لتصبح `Widget` صافي يوضع كأول `Tab`.
- [ ] 5. إعادة هيكلة `ReportsDashboardScreen` (أو استخلاص محتواها في ويدجت جديد مثل `ReportsTabWidget`) لتوضع كـ `Tab` ثاني.
- [ ] 6. التأكد من أن حقول التصفية (Filters) وقوائم البيانات (Lists) تعمل بشكل صحيح داخل الـ Tab الجديد دون مشاكل في التمرير (Scroll issues).

## المرحلة الثالثة: التوجيه (Routing)

- [ ] 7. البحث عن مسار الروتر (مثلاً في `lib/core/routes/` أو `app_router.dart`) الذي يوجه حالياً إلى `ReportsDashboardScreen`.
- [ ] 8. تغييره ليوجه إلى `MainDashboardScreen` الجديدة بدلاً من القديمة.

## المرحلة الرابعة: الاختبار والمراجعة (Validation)

- [ ] 9. تشغيل محلل الأكواد `flutter analyze` للتأكد من عدم وجود أخطاء في الاستيراد (Imports) أو الاستخدام.
- [ ] 10. إشعار المستخدم بانتهاء العمل وتجربة التنقل بين التبويبات.
