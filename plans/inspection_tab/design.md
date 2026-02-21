# وثيقة التصميم المعماري (Design Document) - تبويب فحص وتفتيش (محدّث)

## 🔎 نظرة عامة

تبويب "فحص وتفتيش" يدمج **3 موارد رئيسية** من الباكند:

1. **فحوصات السجلات** (`RecordBookInspection`) - استلام/إرجاع/إكمال فحص
2. **سجلات الأمناء** (`RecordBook` عبر Guardian filter) - إحصائيات القيود
3. **الإجراءات** (`RecordBookProcedure`) - صرف/افتتاح/إغلاق/أرشفة

## البيانات من الباكند

### 1. RecordBookInspection (الفحوصات)

**Model fields:** `record_book_id`, `inspector_user_id`, `inspection_number`, `hijri_year`, `quarter` (1-4), `status` (draft/in_progress/completed/approved/rejected/pending), `received_at`, `received_at_hijri`, `returned_at`, `returned_at_hijri`, `general_notes`

**Relationships:** `recordBook` → `legitimateGuardian`, `inspector`, `entryNotes`, `procedures`, `qualityEvaluations`

**Actions:** استلام السجل (received_at), إرجاعه (returned_at), إكمال الفحص (status→completed)

### 2. RecordBookProcedure (الإجراءات)

**Types:** `ISSUED` (صرف السجل), `OPENED` (افتتاح سنوي), `CLOSED` (إغلاق سنوي), `ARCHIVED` (أرشفة)

**Fields:** `record_book_id`, `procedure_type`, `hijri_year`, `procedure_date`, `start_page`, `end_page`, `start_constraint_number`, `end_constraint_number`, `performed_by`, `notes`

### 3. EntryInspectionNote (ملاحظات الفحص)

**13 حقل مخالفة بوليانية** (missing_seller_ownership_document, jurisdiction_violation, has_blanks, etc)

## التعديلات المقترحة

### Backend (Laravel)

- إضافة routes + controller methods لـ record-book-inspections, record-book-procedures

### Flutter

- إضافة endpoints + repository methods + provider state
- إعادة هيكلة InspectionTab بـ 3 أقسام فرعية (Chips/SegmentedButton)
