# واجهات المستخدم التوليدية (Generative UI - GenUI Deep Dive)

تُعد **GenUI SDK** لفلاتر بمثابة طبقة تنسيق متطورة. تقوم هذه الحزمة بتنسيق تدفق المعلومات بين المستخدم، والودجت الخاصة بك، ووكيل الذكاء الاصطناعي (AI Agent)، محولةً المحادثات النصية الجامدة إلى تجارب تفاعلية غنية.

---

## 🧐 ما هو GenUI؟

بدلاً من عرض "جدار من النصوص" للمستخدم، يقوم GenUI بتوليد واجهة رسومية (مثل أزرار، منتقي تاريخ، أو كنزولات منتجات) بناءً على سياق المحادثة.

* **JSON-based format:** يستخدم صيغة JSON لتركيب الواجهة من كتالوج الودجت الخاص بك.
* **الحلقة التفاعلية:** عند تفاعل المستخدم مع الواجهة المولدة، يتم إرسال التغييرات مرة أخرى للذكاء الاصطناعي لتحديث السياق.

---

## 🛠️ المكونات الأساسية

1. **الكتالوج (Catalog):** مجموعة الودجت التي تسمح للذكاء الاصطناعي باستخدامها.
2. **معالج الرسائل (MessageProcessor):** يقوم بتحويل ردود الذكاء الاصطناعي إلى عناصر واجهة (Surfaces).
3. **مولد المحتوى (ContentGenerator):** المسؤول عن الاتصال بنموذج اللغة (مثل Gemini).
4. **المحادثة (GenUiConversation):** المنسق العمومي الذي يربط كل ما سبق ويدير حالة المحادثة.

---

## 🚀 البدء السريع

### 1. إضافة الحزم

```bash
dart pub add genui genui_google_generative_ai
```

### 2. إعداد الاتصال

```dart
final catalog = Catalog(components: [/* الودجت الخاصة بك */]);
final messageProcessor = A2uiMessageProcessor(catalogs: [catalog]);

final contentGenerator = GoogleGenerativeAiContentGenerator(
  catalog: catalog,
  apiKey: 'YOUR_GEMINI_API_KEY',
  modelName: 'models/gemini-2.5-flash',
  systemInstruction: 'أنت مساعد ذكي، قم بتوليد واجهات تفاعلية بناءً على طلب المستخدم.',
);

final conversation = GenUiConversation(
  contentGenerator: contentGenerator,
  a2uiMessageProcessor: messageProcessor,
);
```

---

## 🔄 ربط البيانات والحيوية (Data Binding)

يعتمد GenUI على مفهوم **DataModel**، وهو مخزن مركزي لجميع حالات واجهة المستخدم الديناميكية.

* **Reactivity:** عندما تتغير البيانات في النموذج، يتم تحديث الودجت المرتبطة بها فقط.
* **Path Binding:** يمكن ربط خصائص الودجت بمسارات معينة في البيانات (مثلاً: `/user/name`).

---

## 💡 حالات الاستخدام

* **عروض المنتجات:** عرض "Carousel" قابل للنقر بدلاً من قائمة نصية.
* **النماذج الديناميكية:** توليد استمارة كاملة (Sliders, Date Pickers) عندما يطلب المستخدم التخطيط لرحلة.

---

:::experimental
تنبيه: حزمة `genui` حالياً في مرحلة **Alpha**، وقد تطرأ عليها تغييرات كبيرة في المستقبل.
:::

---

### 🔗 المراجع الأصلية (Original References)

* **[مقدمة GenUI](../flutter_official_docs/website_docs/src/content/ai/genui/index.md)**
* **[دليل البدء (Get Started)](../flutter_official_docs/website_docs/src/content/ai/genui/get-started.md)**
* **[المكونات والمفاهيم (Components)](../flutter_official_docs/website_docs/src/content/ai/genui/components.md)**
* **[المدخلات والأحداث (Input and Events)](../flutter_official_docs/website_docs/src/content/ai/genui/input-events.md)**
