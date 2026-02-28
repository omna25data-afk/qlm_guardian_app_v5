# مجموعة أدوات الذكاء الاصطناعي لفلاتر (Flutter AI Toolkit Deep Dive)

تُعد **Flutter AI Toolkit** مجموعة من الودجت الجاهزة التي تسهل إضافة نافذة دردشة ذكية إلى تطبيقك. تم تصميم هذه الأدوات لتكون مرنة، حيث تعتمد على واجهة برمجية (API) مجردة لمزودي نماذج اللغة الكبيرة (LLM)، مما يسهل تبديل المزود (مثل Gemini أو OpenAI) دون تغيير كبير في الكود.

---

## 🚀 الميزات الرئيسية (Key Features)

* **دردشة متعددة الأدوار (Multiturn Chat):** الحفاظ على سياق المحادثة عبر عدة تفاعلات.
* **استجابات متدفقة (Streaming Responses):** عرض الردود في الوقت الفعلي أثناء توليدها.
* **مدخلات متعددة الوسائط:** دعم إرسال واستقبال الصور، الملفات، والروابط.
* **إدخال صوتي:** السماح للمستخدمين بإدخال الأوامر بالصوت.
* **تخصيص كامل للتصميم:** واجهات تتناسب مع تصميم تطبيقك (Material أو Cupertino).
* **دعم عبر المنصات:** يعمل على Android, iOS, Web, و macOS.

---

## 🛠️ البداية السريعة (Getting Started)

### 1. التثبيت

أضف الاعتمادات التالية إلى ملف `pubspec.yaml`:

```yaml
dependencies:
  flutter_ai_toolkit: ^latest
  firebase_ai: ^latest
  firebase_core: ^latest
```

### 2. الإعداد مع Firebase

تعتمد الأدوات بشكل أساسي على Firebase لتوفير أمان واتصال سهل مع نماذج Gemini.

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

// استخدام LlmChatView في واجهة المستخدم
LlmChatView(
  provider: FirebaseProvider(
    model: FirebaseAI.googleAI().generativeModel(
      model: 'gemini-2.5-flash',
    ),
  ),
)
```

---

## 📱 تجربة المستخدم (User Experience)

توفر `LlmChatView` تجربة غنية تلقائياً:

* **إدخال نصي متعدد الأسطر:** دعم اللصق وإضافة أسطر جديدة (Shift+Enter على الديسك توب).
* **المرفقات:** زر (+) لإرفاق صور من الكاميرا أو المعرض، أو ملفات PDF/TXT.
* **تكبير الصور:** يمكن للمنتقدين النقر على مصغرات الصور لتكبيرها.
* **تعديل الرسائل:** يمكن للمستخدم تعديل آخر رسالة أرسلها لإعادة توجيه الطلب للذكاء الاصطناعي.

---

## 🏗️ إنشاء مزود مخصص (Custom LLM Provider)

إذا كنت لا ترغب في استخدام Firebase، يمكنك إنشاء مزود خاص بك عبر تنفيذ واجهة `LlmProvider`:

```dart
class MyCustomProvider extends LlmProvider with ChangeNotifier {
  @override
  Stream<String> sendMessageStream(String prompt, {Iterable<Attachment> attachments = const []}) async* {
    // كود الاتصال بـ API الخاص بك هنا
    yield "استجابة تجريبية...";
  }

  @override
  Iterable<ChatMessage> get history => _history;
  
  // تنفيذ بقية الواجهة...
}
```

---

### 🔗 المراجع الأصلية (Original References)

للتعمق أكثر في الأكواد البرمجية والتخصيص المتقدم:

* **[نظرة عامة على Toolkit](../flutter_official_docs/website_docs/src/content/ai/ai-toolkit/index.md)**
* **[تجربة المستخدم (UX Guide)](../flutter_official_docs/website_docs/src/content/ai/ai-toolkit/user-experience.md)**
* **[المزودون المخصصون (Custom Providers)](../flutter_official_docs/website_docs/src/content/ai/ai-toolkit/custom-llm-providers.md)**
* **[تكامل الميزات (Feature Integration)](../flutter_official_docs/website_docs/src/content/ai/ai-toolkit/feature-integration.md)**
