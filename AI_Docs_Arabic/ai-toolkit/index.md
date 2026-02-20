---
title: حزمة أدوات الذكاء الاصطناعي في Flutter (شرح الملف)
shortTitle: AI Toolkit
description: >
  تعلم كيفية إضافة مساعد دردشة باستخدام AI Toolkit إلى تطبيق Flutter الخاص بك.
---

ملف تعريفي يرحب بالمستخدمين في "Flutter AI Toolkit". الحزمة عبارة عن مجموعة من مكونات واجهة الدردشة (Widgets) المدعومة بالذكاء الاصطناعي، وتعتمد على واجهة برمجية (API) تجعل من السهل التبديل بين مزودي النماذج (LLM Providers). تدعم بشكل جاهز `Firebase AI Logic`.

## الميزات الرئيسية (Key features)

* **محادثات متعددة الأدوار (Multiturn chat):** استمرار السياق عبر عدة تفاعلات.
* **بث الردود (Streaming responses):** عرض النص بالتدريج في الوقت الفعلي أثناء التوليد.
* **دعم النصوص المنسقة (Rich text).**
* **الإدخال الصوتي (Voice input).**
* **المرفقات المتعددة الوسائط (Multimedia).**
* **تخصيص الواجهات والردود وحفظ المحادثات والتوافق مع عدة منصات.**

## البدء بالعمل (Get started)

يشرح خطوات التثبيت:

1. **التثبيت (Installation):**
   إضافة التبعيات في ملف `pubspec.yaml` (مثل `flutter_ai_toolkit` و `firebase_ai` و `firebase_core`).
2. **الضبط والتكوين (Configuration):**
   إعداد مشروع Firebase، وربط تطبيق Flutter به عبر أداة `flutterfire CLI`. يتم بعد ذلك تهيئة Firebase داخل التطبيق واستخدام `FirebaseProvider` ضمن الويدجت `LlmChatView`. يمكن التبديل بين استخدام Gemini API (للتجارب والنمذجة) أو Vertex AI (لبيئة الإنتاج).
3. **صلاحيات النظام (Device permissions):**
   إعداد أذونات النظام في (Android/iOS/macOS) للسماح بالوصول للشبكة (Network)، والميكروفون (للمقاطع الصوتية)، واختيار الملفات والصور أو التقاطها.
