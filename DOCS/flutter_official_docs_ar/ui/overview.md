# بناء واجهة المستخدم (UI Overview)

واجهة المستخدم في فلاتر مبنية بالكامل على مفهوم **الودجت (Widgets)**. الودجت في فلاتر ليست مجرد عناصر واجهة بل هي وصف لكيفية عرض جزء معين من الشاشة في لحظة معينة.

---

## 🧱 الودجت هي حجر الأساس (Everything is a Widget)

كل شيء تراه على الشاشة هو ودجت:

* **العناصر المرئية:** النص (Text)، الصورة (Image)، الزر (Button).
* **عناصر التخطيط:** الحاوية (Container)، الأعمدة (Column)، الصفوف (Row).
* **عناصر التفاعل:** الكاشف (GestureDetector).

---

## 🌓 أنواع الودجت (Types of Widgets)

هناك نوعان رئيسيان يجب أن تعرفهما:

### 1. الودجت عديمة الحالة (StatelessWidget)

هي ودجت لا تتغير بمجرد بنائها (Immutable). تستخدم لعرض المعلومات التي لا تعتمد على تفاعل المستخدم الذي يغير حالتها (مثلاً: نص ثابت أو أيقونة).

### 2. الودجت ذات الحالة (StatefulWidget)

هي ودجت يمكن أن تتغير خلال وقت التشغيل (Dynamic). تمتلك كائن "حالة" (State object) الذي يحتفظ بالبيانات التي يمكن أن تتغير (مثل حقل إدخال نصي أو عداد). يتم إعادة بناء الواجهة عند استدعاء `setState()`.

---

## 📐 التخطيط والقيود (Layout and Constraints)

القاعدة الذهبية في تخطيط فلاتر هي:
> **"القيود تتدفق للأسفل، الأحجام تتدفق للأعلى، الأب يحدد الموقع."**
> (Constraints flow down. Sizes flow up. Parents set positions.)

1. يرسل الأب (Parent) قيوداً (مثلاً: أقصى عرض وأقصى طول) للابن (Child).
2. يقرر الابن حجمه الخاص بناءً على تلك القيود.
3. يحدد الأب مكان الابن بناءً على الحجم الذي أرجعه.

---

## 🎨 التصميم الجمالي (Design & Aesthetics)

توفر فلاتر مكتبات جاهزة لاتباع أنماط التصميم العالمية:

* **Material Design:** نمط جوجل الافتراضي (الأكثر استخداماً).
* **Cupertino Widgets:** لمحاكاة تصميم أنظمة iOS (Apple).

---

## 🚦 الخطوة التالية

تعمق في كيفية التعامل مع البيانات في **[البيانات والواجهة الخلفية](../data-and-backend/overview.md)** أو تعلم كيفية اختبار تطبيقك في قسم **[الاختبار](../testing/overview.md)**.

---

### 🔗 المراجع الأصلية (Original References)

بناء الواجهات هو قلب فلاتر، يمكنك التوسع من هنا:

* [مقدمة الواجهة (Intro to UI)](../flutter_official_docs/website_docs/src/content/ui/index.md)
* [كتالوج الودجت (Widget Catalog)](../flutter_official_docs/website_docs/src/content/ui/widgets/index.md)
* [دليل التخطيط (Layout Guide)](../flutter_official_docs/website_docs/src/content/ui/layout/index.md)
* [فهم القيود (Understanding Constraints)](../flutter_official_docs/website_docs/src/content/ui/layout/constraints/index.md)
