# التكامل مع Gemini في فلاتر (Gemini Integration Deep Dive)

تُعد نماذج **Gemini** من جوجل أقوى نماذج الذكاء الاصطناعي المتاحة للمطورين اليوم. يمكنك دمج هذه القدرات في تطبيق فلاتر الخاص بك بطريقتين رئيسيتين، اعتماداً على مرحلة المشروع واحتياجات الأمان.

---

## 🛠️ طرق التكامل (Integration Methods)

### 1. حزمة Google Generative AI (للنماذج الأولية)

هي الطريقة الأسرع للبدء. تستخدم مفتاح API مباشرة من [Google AI Studio](https://aistudio.google.com/).

* **الحزمة:** `google_generative_ai`
* **مثالية لـ:** الاختبارات المحلية، التطبيقات الشخصية، والنماذج الأولية السريعة.

```dart
final model = GenerativeModel(
  model: 'gemini-1.5-flash',
  apiKey: 'YOUR_API_KEY',
);

final response = await model.generateContent([Content.text('اكتب كود فلاتر لزر متحرك')]);
print(response.text);
```

### 2. Firebase AI Logic (للتطبيقات الإنتاجية)

عندما يكون تطبيقك جاهزاً للنشر، يفضل استخدام Firebase لإدارة مفاتيح API بشكل آمن وتقديم ميزات مثل App Check.

* **الحزمة:** `firebase_ai`
* **المميزات:** أمان أعلى، إدارة مركزية، وتكامل مع خدمات Firebase الأخرى.

---

## 🌟 ميزات متقدمة (Advanced Features)

* **الدردشة المستمرة (Chat Session):** الحفاظ على سياق المحادثة بدلاً من إرسال طلبات منفصلة.
* **المدخلات المرئية (Multimodal):** إرسال الصور مع النصوص للنموذج (مثلاً: "اشرح ما يوجد في هذه الصورة").
* **استدعاء الدوال (Function Calling):** تمكين الذكاء الاصطناعي من استدعاء دوال برمجية داخل تطبيقك (مثل: "احجز موعداً" -> يستدعي دالة `bookAppointment()`).

---

## 💡 نصائح للأداء

* **استخدام النماذج الخفيفة:** استخدم `gemini-1.5-flash` للسرعة والتكلفة المنخفضة، و `gemini-1.5-pro` للمهام المعقدة جداً.
* **Streaming:** استخدم `generateContentStream` لعرض النص للمستخدم تدريجياً، مما يحسن من تجربة المستخدم المتصورة.

---

### 🔗 المراجع الأصلية (Original References)

* **[البناء باستخدام الذكاء الاصطناعي (Create with AI)](../flutter_official_docs/website_docs/src/content/ai/create-with-ai.md)**
* **[دليل البدء مع Gemini (Firebase)](https://firebase.google.com/docs/ai-logic/get-started)**
* **[أمثلة الكود (Dart SDK)](https://pub.dev/packages/google_generative_ai/example)**
