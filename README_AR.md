# بسم الله الرحمن الرحيم
# Change Language:[ 🇺🇸 EN](README.md)

--- 
# درر الحديث - Dorar Hadith

مكتبة بلغة `Dart` تهدف إلى تسهيل التعامل والحصول على الأحاديث ومتعلقاتها من خلال موقع الدرر السنية.

مستوحاة وكثير من اجزاءها مبني على مستودع [dorar-hadith-api](https://github.com/AhmedElTabarani/dorar-hadith-api) من الأخ: [أحمد الطبراني](https://github.com/AhmedElTabarani).
**تعمل المكتبة على كل برمجيات `Dart` دون الحاجة إلى `Flutter`.**

[![pub package](https://img.shields.io/pub/v/dorar_hadith.svg)](https://pub.dev/packages/dorar_hadith)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)


## مزايا المكتبة

- البحث عن الأحاديث بسرعة مع إمكانية الفلترة بحسب الراوي، الكتاب، الصحة، الراوي والمزيد.
- الحصول على بيانات تفصيلة للحديث.
- إمكانية البحث والحصول على الشرح للأحاديث.
- البحث عن جميع الشروح المتاحة بنص البحث.
- البحث عن الأحاديث المشابه او البديل الصحيح.
- التصنيف الموضوعي للأحاديث في نتائج البحث المفصل.
- البحث في الكتب، والرواة والمحديثين المتوفرين لفلترة النتائج بدون اتصال بالإنترنت.

### إمكانيات البحث

- البحث بنص (متن) الحديث.
- فلترة بصحة الحديث.
- فلترة بالمحدثين.
- فلترة بالرواة.
- فلترة بالكتب.
- فلترة بنوع الحديث (قدسي، أثر، إلخ).
- بيانات لترقيم الصفحات.

## التثبيت

قم بتشغيل الأمر التالي :

```bash
dart pub add dorar_hadith
```

أو بإستخدام `Flutter` :

```bash
flutter pub add dorar_hadith
```

## بداية سريعة

```dart
import 'package:dorar_hadith/dorar_hadith.dart';

void main() async {
  await DorarClient.use((client) async {
    // Search for hadiths about prayer
    final results = await client.searchHadith(
      HadithSearchParams(value: 'الصلاة', page: 1),
    );

    print('Found ${results.data.length} hadiths');

    // Print first hadith
    if (results.data.isNotEmpty) {
      final h = results.data.first;
      print('Hadith: ${h.hadith}');
      print('Narrator: ${h.rawi}');
      print('Scholar: ${h.mohdith}');
      print('Verdict: ${h.hukm}');
    }

    // You can return the result to use else where
    return results;
  });
}
```

**لرؤية مثال كامل يتطرق لكل مزايا المكتبة انظر هنا:**
[`example/example.dart`](example/example.dart)

## طريقة الإستخدام

### ملاحظة مهمة
أغلب العمليات في `DorarClient` والخدمات الباقية تعيد النتائج داخل `Object` بإسم `ApiResponse` وهذا لتسهيل عملية ترقيم الصفحات.
يحتوي `ApiResponse` على عضوين:
- الناتج: `data`
- بيانات الترقيم: `SearchMetadata`
وذلك لتسهيل عملية طلب بيانات جديدة عند الحاجة كالذهاب للصفحة التالية.

### بحث سريع في الأحاديث
البحث عن طريق `client.searchHadith` سريع ويعيد كائنات `Hadith` الخفيفة
مباشرة من واجهة Dorar الرسمية.
- عدد النتائج لا يتجاوز 15 حديث، كما يمكن استخدام الفلاتر بلا إشكال.
- تضم الاستجابة الحقول النصية فقط (`hadith`, `rawi`, `mohdith`, `book`,
  `numberOrPage`, `grade`).
- استخدم `client.searchHadithDetailed` إذا احتجت المعرفات، روابط Dorar،
  بيانات الشرح، أو أي حقول إضافية يوفرها كائن `DetailedHadith`.

```dart
final results = await client.searchHadith(
  HadithSearchParams(value: 'الإيمان'),
);

for (var hadith in results.data) {
  print('${hadith.hadith}');
  print('Grade: ${hadith.hukm}');
}
```

### البحث المفصل مع الفلترة
**ملاحظة:** البحث المفصل يملأ الحقل `DetailedHadith.explainGrade` بدلاً من
`grade` بسبب طريقة عرض الحكم في الموقع ، **لتجنب هذه المشاكل دائمًا استخدم `DetailedHadith.hukm`.**

```dart

final params = HadithSearchParams(
  value: 'الصيام',
  page: 1,
  degrees: [HadithDegree.authenticHadith], // الأحاديث الصحيحة فقط
  mohdith: [MohdithReference.bukhari],
  searchMethod: SearchMethod.anyWord,
  zone: SearchZone.qudsi,
);

final results = await client.searchHadithDetailed(params);
```

### البحث عن حديث بالمعرف (ID)
تعيد هذه العملية كائن `DetailedHadith` كامل البيانات عند توفرها.

```dart
final hadith = await client.getHadithById('12345');
print('Hadith: ${hadith.hadith}');
print('Book: ${hadith.book}');
print('Grade: ${hadith.hukm}');
```

### الأحاديث المشابهة، الأصول، البديل الصحيح
**ملاحظة:** يوجد داخل فئة `DetailedHadith` خصائص للتأكد من توفر هذه الخيارات لهذا الحديث وهي كالتالي:
- للتأكد من وجود صحيح بديل `hasAlternateHadithSahih`
- للتأكد من وجود أحاديث مشابهة `hasSimilarHadith`
- للتأكد من وجود الأصول `hasUsulHadith`

```dart
// الحصول على حديث مشابه
final similar = await client.hadith.getSimilar('12345');
// أو استخدام الاختصار
final sameSimilar = await client.getSimilarHadith('12345');

// الحصول على البديل الصحيح
final alternate = await client.hadith.getAlternate('12345');
// أو استخدام الاختصار
final sameAlternate = await client.getAlternateHadith('12345');

// الحصول على الأصول
final usul = await client.hadith.getUsul('12345');
print('Main hadith: ${usul.hadith.hadith}');
print('Sources: ${usul.count}');
// أو استخدام الاختصار
final sameUsul = await client.getUsulHadith('12345');
```

### البحث عن الشرح
**ملاحظة:** عند البحث بإستخدام `client.searchHadithDetailed` وفي حال وجود حديث له شرح ستجد معرف الشرح داخل `DetailedHadith.sharhMetadata`. استخدمها كما في المثال التالي:

```dart
// الحصول على الشرح بالمعرف
final sharh = await client.sharh.getById('789');

// البحث بنص الشرح
final sharhByText = await client.sharh.getByText('إنما الأعمال بالنيات');
// أو استخدام الاختصار
final sameSharh = await client.getSharhByText('إنما الأعمال بالنيات');

// البحث عن جميع الشروح المتاحة بنص البحث
final sharhResults = await client.searchSharh(
  HadithSearchParams(value: 'الصلاة'),
);
for (var s in sharhResults.data) {
  print('الشرح: ${s.sharhText}');
}
```

### بيانات المرجعية (لا تحتاج إلى اتصال بالشبكة)
هذه البيانات تستخدم في عملية الفلترة، كالبحث عن محدث معين او كتاب معين او راوي معين ثم تمريره في عملية البحث عن الحديث.
وجعلت هذه العملية على الجهاز لكثرة البيانات ولجعل الوصول لها سهلًا.

**ملاحظة:** القيم المرجعية تحتوي فقط على معرف المرجع `id` واسم المرجع مثال: صحيح البخاري، حتى تحصل على تفاصيل هذا المرجع يجب ان تقوم بطلبها راجع: [[#الحصول على تفاصيل المحدث او الكتاب]]  .

#### البحث في المحدثين

```dart
// البحث بالإسم
final bukhari = await client.mohdithRef.searchMohdith('البخاري');

// البحث بالمعرف
final scholar = await client.mohdithRef.getMohdithById('256');

// عرض الجميع مع الترقيم
final allScholars = await client.mohdithRef.getAllMohdith(limit: 50);

// الحصول على اكثر من قيمة من اكثر من معرف
final scholars = await client.mohdithRef.getMohdithByIds(['256', '179']);

// اختصار للبحث في المحدثين بدون الدخول في mohdithRef
final results = await client.searchMohdith('أحمد');
```

#### البحث في الكتب

```dart
// البحث بالإسم
final sahihBooks = await client.bookRef.searchBook('صحيح');

// البحث بالمعرف
final book = await client.bookRef.getBookById('6216');

// عرض الجميع مع الترقيم
final allBooks = await client.bookRef.getAllBooks(limit: 100, offset: 0);

// اختصار للبحث في الكتب بدون الدخول في bookRef
final results = await client.searchBooks('سنن');
```

#### البحث في الرواة

```dart
// البحث بالإسم 
final narrators = await client.rawiRef.searchRawi('أبو هريرة', limit: 10);

// البحث بالمعرف
final abuHurayrah = await client.rawiRef.getRawiById(4396);

// عرض الجميع مع الترقيم
final page1 = await client.rawiRef.getAllRawi(limit: 50, offset: 0);

// عدد النتائج
final total = await client.rawiRef.countRawi();
final searchCount = await client.rawiRef.countRawi(query: 'عبد الله');

// اختصار للبحث في الرواة بدون الدخول في rawiRef
final results = await client.searchRawi('عمر');

// مهم: التخلص من الوسيط بعد الإنتهاء لتفادي بعض الإنذارات والأخطاء
await client.dispose();
```

#### قيم ثابتة
حتى يسهل الفلترة بالكتب والرواة والمحدثين معروفين دون الحاجة على البحث عنهم كل مرة قمت بوضع ما اشتهر من هذه القيم كقيم جاهزة دون الحاجة للبحث، في الكتب مثلًا ستجد صحيح البخاري وصحيح مسلم وغيرهم.
**في حال رغبة بإضافة قيم اخرى ثابتة يرجع فتح Issue على Github**

```dart
// مثال على قيم المحدثين الثابتة
MohdithReference.bukhari  
MohdithReference.muslim     
MohdithReference.abuDawud   
// ... 17 المجموع

// مثال على قيم الكتب الثابتة
BookReference.sahihBukhari  
BookReference.sahihMuslim     
// ... 20 المجموع

// مثال على قيم الرواة الثابتة
RawiReference.abuHurayrah     
RawiReference.aisha          
// ... 21 المجموع

// استخدام القيم هذه في الفلترة
final params = HadithSearchParams(
  value: 'الصلاة',
  page: 1,
  mohdith: [MohdithReference.bukhari],
  books: [BookReference.sahihBukhari],
);
final results = await client.hadith.searchViaSite(params);
```

### الحصول على تفاصيل المحدث او الكتاب

```dart
// الحصول على تفاصيل الكتاب من API
final book = await client.book.getById('123');
print('Book: ${book.name}');
print('Author: ${book.author}');

// الحصول على تفاصيل المحدث من API
final scholar = await client.mohdith.getById('456');
print('Name: ${scholar.name}');
print('Bio: ${scholar.info}');
```

## الخيارات المتاحة

في هذا القسم سنتعرف على جميع الكائنات (Models) والخيارات المتاحة في المكتبة بشكل تفصيلي.

### كائنات الحديث

توفر المكتبة مستويين من الكائنات للتعامل مع الأحاديث:

- `Hadith`: الكائن الخفيف الذي تعيده واجهة Dorar الرسمية. يحتوي على المتن،
  الراوي، المحدث، الكتاب، رقم الصفحة/الحديث، ودرجة الحكم.
- `DetailedHadith`: يمتد من `Hadith` ويضيف كل البيانات الإضافية المستخرجة من
  موقع الدرر (المعرفات، التخريج، روابط الشرح، أصول الحديث، إلخ).

```dart
class Hadith {
  final String hadith;        // متن الحديث
  final String rawi;          // الراوي
  final String mohdith;       // المحدث
  final String book;          // الكتاب المصدر
  final String numberOrPage;  // رقم الصفحة/الحديث
  final String grade;         // درجة الحديث من API
}

class DetailedHadith extends Hadith {
  final String? hadithId;               // المعرف الفريد للحديث
  final String? mohdithId;              // معرف المحدث
  final String? bookId;                 // معرف الكتاب
  final String? explainGrade;           // الحكم التفصيلي (من البحث المفصل)
  final String? takhrij;                // التخريج والمصادر الأخرى
  final List<HadithCategory> categories; // التصنيف الموضوعي للحديث
  final bool hasSimilarHadith;          // هل يوجد أحاديث مشابهة؟
  final bool hasAlternateHadithSahih;   // هل يوجد بديل صحيح؟
  final bool hasUsulHadith;             // هل يوجد أصول للحديث؟
  final String? similarHadithDorar;     // رابط الأحاديث المشابهة
  final String? alternateHadithSahihDorar; // رابط البديل الصحيح
  final String? usulHadithDorar;        // رابط الأصول
  final bool hasSharhMetadata;          // هل يوجد بيانات شرح؟
  final SharhMetadata? sharhMetadata;   // بيانات الشرح
}
```

جميع استدعاءات البحث السريع (`client.searchHadith`) تعيد الكائن الخفيف
`Hadith`. أما البحث عبر الموقع (`searchHadithDetailed`) وباقي الخدمات
(المتشابه، البديل، الأصول) فترفع البيانات إلى `DetailedHadith` بحيث تُعبّئ
المعرفات، روابط Dorar، وبيانات الشرح ويمكن الاعتماد على الرايات (`has*`)
قبل استدعاء الخدمة المناسبة.

أهم الرايات:
- `hasSimilarHadith` ⇒ استدعاء `client.hadith.getSimilar()`
- `hasAlternateHadithSahih` ⇒ استدعاء `client.hadith.getAlternate()`
- `hasUsulHadith` ⇒ استدعاء `client.hadith.getUsul()`
- `hasSharhMetadata` ⇒ استخدام `sharhMetadata.id` أو `sharhMetadata.sharh`
- `hukm` ⇒ يعيد `explainGrade` عند توفره، ويعود إلى `grade` إن كان فارغًا،
  لذا يكفي طباعة `hadith.hukm` لعرض الحكم بنص واحد

### كائن الشرح (Sharh Model)

يمثل الحديث مع شرحه التفصيلي.

```dart
class Sharh {
  // معلومات الحديث الأساسية
  final String hadith;              // نص الحديث
  final String rawi;                // الراوي
  final String mohdith;             // المحدث
  final String book;                // الكتاب المصدر
  final String numberOrPage;        // رقم الصفحة/الحديث
  final String grade;               // درجة الحديث
  final String? takhrij;            // التخريج
  
  // معلومات الشرح
  final bool hasSharhMetadata;      // هل يوجد شرح؟
  final SharhMetadata? sharhMetadata; // بيانات الشرح
  
  // خاصية مساعدة للحصول على نص الشرح مباشرة
  String? get sharhText => sharhMetadata?.sharh;
}
```

**استخدام:**
```dart
final sharh = await client.sharh.getById('789');
if (sharh.hasSharhMetadata && sharh.sharhText != null) {
  print('الشرح: ${sharh.sharhText}');
}
```

### معلومات الشرح (SharhMetadata)

يحتوي على التفاصيل الخاصة بالشرح.

```dart
class SharhMetadata {
  final String id;                  // معرف الشرح
  final bool isContainSharh;        // هل يحتوي على نص الشرح؟
  final String? sharh;              // نص الشرح (إن وجد)
}
```

### التصنيف الموضوعي (HadithCategory)

يمثل التصنيف الموضوعي المستخرج من نتائج البحث في موقع الدرر السنية. كل `DetailedHadith` قد يحتوي على تصنيفات موضوعية متعددة أو لا يحتوي على أي منها.

```dart
class HadithCategory {
  final String id;                  // معرف التصنيف (مستخرج من الرابط)
  final String name;                // اسم التصنيف بالعربية
}
```

**استخدام:**
```dart
final results = await client.searchHadithDetailed(
  HadithSearchParams(value: 'الصلاة'),
);

for (var hadith in results.data) {
  if (hadith.categories.isNotEmpty) {
    print('التصنيفات:');
    for (var cat in hadith.categories) {
      print('  - ${cat.name} (${cat.id})');
    }
  }
}
```

### أصول الحديث (UsulHadith Model)

يمثل الحديث مع جميع مصادره وأصوله.

```dart
class UsulHadith {
  final DetailedHadith hadith;      // الحديث التفصيلي مع البيانات الإضافية
  final List<UsulSource> sources;   // قائمة جميع المصادر
  final int count;                  // عدد المصادر
}

// مصدر واحد من أصول الحديث
class UsulSource {
  final String source;              // اسم المصدر والصفحة
  final String chain;               // سلسلة الإسناد
  final String hadithText;          // نص الحديث في هذا المصدر
}
```

**مثال للاستخدام:**
```dart
final usulResponse = await client.hadith.getUsul('12345');
final usul = usulResponse.data;

print('عدد المصادر: ${usul.count}');
for (var source in usul.sources) {
  print('المصدر: ${source.source}');
  print('الإسناد: ${source.chain}');
}
```

### معلومات الكتاب (BookInfo)

يحتوي على التفاصيل الكاملة للكتاب (يُستخدم عبر API).

```dart
class BookInfo {
  final String name;                // اسم الكتاب
  final String bookId;              // المعرف الفريد
  final String author;              // المؤلف
  final String reviewer;            // المحقق
  final String publisher;           // الناشر
  final String edition;             // رقم الطبعة
  final String editionYear;         // سنة الطبعة
}
```

**الحصول على معلومات كتاب:**
```dart
final book = await client.book.getById('6216');
print('${book.name} - ${book.author}');
print('الناشر: ${book.publisher}');
```

### معلومات المحدث (MohdithInfo)

يحتوي على التفاصيل الكاملة للمحدث (يُستخدم عبر API).

```dart
class MohdithInfo {
  final String name;                // اسم المحدث
  final String mohdithId;           // المعرف الفريد
  final String info;                // السيرة الذاتية والمعلومات التفصيلية
}
```

**الحصول على معلومات محدث:**
```dart
final mohdith = await client.mohdith.getById('256');
print('الاسم: ${mohdith.name}');
print('نبذة: ${mohdith.info}');
```

### القيم المرجعية (Reference Items)

القيم المرجعية هي بيانات خفيفة تُستخدم للبحث والفلترة بدون الحاجة للإنترنت. جميعها تمتد من `ReferenceItem`.

#### الكتب المرجعية (BookItem)

```dart
class BookItem extends ReferenceItem {
  final String id;                  // معرف الكتاب
  final String name;                // اسم الكتاب
  final String? author;             // اسم المؤلف (إن وُجد)
  final String? mohdithId;          // معرف المحدث المؤلف
  final String? category;           // التصنيف (إن وُجد)
}
```

**استخدام:**
```dart
// البحث في الكتب (بدون إنترنت)
final books = await client.bookRef.searchBook('صحيح', limit: 10);
for (var book in books) {
  print('${book.name} - ${book.author}');
  
  // للحصول على تفاصيل كاملة (يحتاج إنترنت)
  final fullInfo = await client.book.getById(book.id);
}
```

#### المحدثين المرجعيين (MohdithItem)

```dart
class MohdithItem extends ReferenceItem {
  final String id;                  // معرف المحدث
  final String name;                // اسم المحدث
  final int? deathYear;             // سنة الوفاة بالهجري (إن وُجدت)
  final String? era;                // الحقبة الزمنية (إن وُجدت)
}
```

**استخدام:**
```dart
// البحث في المحدثين (بدون إنترنت)
final scholars = await client.mohdithRef.searchMohdith('البخاري', limit: 5);
for (var scholar in scholars) {
  print('${scholar.name}');
  if (scholar.deathYear != null) {
    print('توفي سنة: ${scholar.deathYear}هـ');
  }
}
```

#### الرواة المرجعيين (RawiItem)

```dart
class RawiItem extends ReferenceItem {
  final String id;                  // معرف الراوي
  final String name;                // اسم الراوي
}
```

**استخدام:**
```dart
// البحث في الرواة (بدون إنترنت)
final narrators = await client.rawiRef.searchRawi('أبو هريرة', limit: 3);
for (var narrator in narrators) {
  print(narrator.name);
}

// عد النتائج
final total = await client.rawiRef.countRawi();
final searchCount = await client.rawiRef.countRawi(query: 'عبد الله');
```

### بيانات الاستجابة (ApiResponse)

جميع عمليات البحث والاسترجاع تُرجع النتائج داخل `ApiResponse` لتسهيل ترقيم الصفحات وإدارة البيانات.

```dart
class ApiResponse<T> {
  final T data;                     // البيانات الفعلية (حديث، قائمة أحاديث، إلخ)
  final SearchMetadata metadata;    // معلومات إضافية عن النتيجة
}
```

**أمثلة للاستخدام:**
```dart
// البحث يُرجع ApiResponse<List<Hadith>>
final response = await client.searchHadith(
  HadithSearchParams(value: 'الصلاة', page: 1),
);

print('عدد النتائج: ${response.data.length}');
print('الصفحة الحالية: ${response.metadata.page}');
print('من الكاش: ${response.metadata.isCached}');

// أصول الحديث تُرجع ApiResponse<UsulHadith>
final usulResponse = await client.hadith.getUsul('12345');
print('عدد المصادر: ${usulResponse.data.count}');
```

### بيانات البحث الوصفية (SearchMetadata)

يحتوي على معلومات إضافية عن نتيجة البحث.

```dart
class SearchMetadata {
  final int length;                      // عدد النتائج المُرجعة
  final int? currentPageCount;           // عدد النتائج في هذه الصفحة
  final int? total;                      // إجمالي النتائج عبر جميع الصفحات
  final int? page;                       // رقم الصفحة الحالية
  final int? totalPages;                 // إجمالي عدد الصفحات
  final bool? hasNextPage;               // هل يوجد صفحة تالية؟
  final bool? hasPrevPage;               // هل يوجد صفحة سابقة؟
  final bool? removeHtml;                // هل تم إزالة وسوم HTML؟
  final bool? specialist;                // هل تشمل الأحاديث المتخصصة؟
  final int? numberOfNonSpecialist;      // عدد الأحاديث غير المتخصصة
  final int? numberOfSpecialist;         // عدد الأحاديث المتخصصة
  final bool isCached;                   // هل النتيجة من الكاش؟
  final int? usulSourcesCount;           // عدد المصادر (لطلبات أصول الحديث)
  
  // دالة لإنشاء نسخة معدلة
  SearchMetadata copyWith({...});
}
```

**استخدام:**
```dart
final response = await client.searchHadith(params);
final meta = response.metadata;

if (meta.isCached) {
  print('النتيجة من الكاش - سريعة!');
}

print('الصفحة ${meta.page} من أصل ${meta.totalPages}');
print('إجمالي النتائج: ${meta.total}');
print('نتائج هذه الصفحة: ${meta.currentPageCount}');

if (meta.hasNextPage == true) {
  print('يوجد نتائج إضافية في الصفحة التالية');
}
```

### معايير البحث (HadithSearchParams)

يحتوي على جميع معايير وفلاتر البحث عن الأحاديث.

```dart
class HadithSearchParams {
  // إلزامي
  final String value;                    // نص البحث (كلمات الحديث)
  
  // اختياري - خيارات البحث
  final int page;                        // رقم الصفحة (افتراضي: 1)
  final bool removeHtml;                 // إزالة وسوم HTML (افتراضي: true)
  final bool specialist;                 // تضمين الأحاديث المتخصصة (افتراضي: false)
  final String? exclude;                 // كلمات أو عبارات للاستبعاد
  
  // اختياري - الفلاتر
  final SearchMethod? searchMethod;      // طريقة البحث (جميع/أي/مطابق)
  final SearchZone? zone;                // نوع الحديث (مرفوع/قدسي/آثار/شرح)
  final List<HadithDegree>? degrees;     // فلترة بدرجة الصحة
  final List<MohdithReference>? mohdith; // فلترة بالمحدثين
  final List<BookReference>? books;      // فلترة بالكتب
  final List<RawiReference>? rawi;       // فلترة بالرواة
  
  // دالة لإنشاء نسخة معدلة
  HadithSearchParams copyWith({...});
}
```

**أمثلة الاستخدام:**

```dart
// بحث بسيط (الحد الأدنى)
final simple = HadithSearchParams(value: 'الصلاة', page: 1);

// بحث مع فلاتر محددة
final filtered = HadithSearchParams(
  value: 'الإيمان',
  page: 1,
  degrees: [HadithDegree.authenticHadith],      // صحيح فقط
  mohdith: [MohdithReference.bukhari],          // البخاري فقط
  books: [BookReference.sahihBukhari],          // صحيح البخاري فقط
  searchMethod: SearchMethod.allWords,          // جميع الكلمات
  zone: SearchZone.qudsi,                       // أحاديث قدسية
);

// بحث متقدم مع استبعاد كلمات
final advanced = HadithSearchParams(
  value: 'الجنة النار',
  page: 1,
  exclude: 'الدنيا',                           // استبعاد كلمة "الدنيا"
  degrees: [
    HadithDegree.authenticHadith,
    HadithDegree.authenticChain,
  ],
  mohdith: [
    MohdithReference.bukhari,
    MohdithReference.muslim,
  ],
  searchMethod: SearchMethod.anyWord,           // أي كلمة
  removeHtml: true,                             // إزالة HTML
);

// تعديل معايير موجودة
final modified = simple.copyWith(
  page: 2,                                      // الانتقال للصفحة الثانية
  degrees: [HadithDegree.authenticHadith],     // إضافة فلتر
);

final results = await client.searchHadithDetailed(advanced);
```

### درجات صحة الحديث (HadithDegree)

قيم ثابتة لدرجات صحة الأحاديث حسب أحكام المحدثين.

```dart
enum HadithDegree {
  all,                   // جميع الدرجات (بدون فلتر)
  authenticHadith,       // أحاديث حكم المحدثون عليها بالصحة
  authenticChain,        // أحاديث حكم المحدثون على أسانيدها بالصحة
  weakHadith,            // أحاديث حكم المحدثون عليها بالضعف
  weakChain,             // أحاديث حكم المحدثون على أسانيدها بالضعف
  
  // كل قيمة لها:
  final String id;       // المعرف للاستخدام في API
  final String label;    // الوصف العربي
}
```

**استخدام:**
```dart
// فلترة بالأحاديث الصحيحة فقط
final params = HadithSearchParams(
  value: 'الصدقة',
  page: 1,
  degrees: [HadithDegree.authenticHadith],
);

// الأحاديث الصحيحة (الحديث أو السند)
final params2 = HadithSearchParams(
  value: 'الصدقة',
  page: 1,
  degrees: [
    HadithDegree.authenticHadith,
    HadithDegree.authenticChain,
  ],
);

// استخدام الدالات المساعدة
print(HadithDegree.authenticHadith.toString()); // يطبع الوصف العربي
print(HadithDegree.authenticHadith.toQueryParam()); // يطبع المعرف للـAPI
```

### طرق البحث (SearchMethod)

تحدد كيفية البحث في نص الحديث.

```dart
enum SearchMethod {
  allWords,                     // جميع الكلمات (AND)
  anyWord,                      // أي كلمة (OR)
  exactMatch,                   // بحث مطابق (عبارة كاملة)
  
  // كل قيمة لها:
  final String id;              // المعرف للاستخدام في API
  final String label;           // الوصف العربي
}
```

**استخدام:**
```dart
// البحث عن جميع الكلمات (AND)
final allWords = HadithSearchParams(
  value: 'الصلاة الزكاة',
  page: 1,
  searchMethod: SearchMethod.allWords, // أحاديث تحتوي "الصلاة" و"الزكاة" معًا
);

// البحث عن أي كلمة (OR)
final anyWord = HadithSearchParams(
  value: 'الصلاة الزكاة',
  page: 1,
  searchMethod: SearchMethod.anyWord,  // أحاديث تحتوي "الصلاة" أو "الزكاة"
);

// البحث المطابق (العبارة كاملة)
final exact = HadithSearchParams(
  value: 'إنما الأعمال بالنيات',
  page: 1,
  searchMethod: SearchMethod.exactMatch, // العبارة كاملة تمامًا
);

// استخدام الدالات المساعدة
print(SearchMethod.allWords.toString()); // "جميع الكلمات"
print(SearchMethod.allWords.toQueryParam()); // "w"
```

### مناطق البحث (SearchZone)

تحدد تصنيف نوع الحديث للفلترة.

```dart
enum SearchZone {
  all,                          // جميع الأحاديث (بدون فلتر)
  marfoo,                       // الأحاديث المرفوعة (المنسوبة للنبي ﷺ)
  qudsi,                        // الأحاديث القدسية (من الله تعالى)
  sahabaAthar,                  // آثار الصحابة
  sharh,                        // شروح الأحاديث
  
  // كل قيمة لها:
  final String id;              // المعرف للاستخدام في API
  final String label;           // الوصف العربي
}
```

**استخدام:**
```dart
// البحث في الأحاديث القدسية فقط
final qudsi = HadithSearchParams(
  value: 'الجنة',
  page: 1,
  zone: SearchZone.qudsi,
);

// البحث في الأحاديث المرفوعة
final marfoo = HadithSearchParams(
  value: 'الصلاة',
  page: 1,
  zone: SearchZone.marfoo,
);

// البحث في آثار الصحابة
final athar = HadithSearchParams(
  value: 'عمر بن الخطاب',
  page: 1,
  zone: SearchZone.sahabaAthar,
);

// استخدام الدالات المساعدة
print(SearchZone.qudsi.toString()); // "الأحاديث القدسية"
print(SearchZone.qudsi.toQueryParam()); // "1"
```

### إعدادات العميل (Client Options)

يمكنك تخصيص `DorarClient` عند إنشائه.

```dart
final client = DorarClient(
  timeout: Duration(seconds: 15),       // مهلة الطلبات (افتراضي: 15 ثواني)
  // التخزين المؤقت (Cache) مفعل افتراضيًا باستخدام قاعدة بيانات SQLite دائمة
  // (cache.db على الأنظمة الأصلية، و WebAssembly على الويب)
);
```

### التخزين المؤقت الدائم (Persistent Caching)

تستخدم المكتبة الآن قاعدة بيانات SQLite دائمة (`cache.db`) لحفظ النتائج.
- **الأنظمة الأصلية (Native)**: يتم إنشاء قاعدة البيانات في مجلد العمل الحالي (CLI) أو مجلد مستندات التطبيق (Flutter).
- **الويب (Web)**: تستخدم `sqlite3.wasm` للتخزين الدائم في المتصفح.

### إدارة الكاش

```dart
// الحصول على إحصائيات الكاش
final stats = await client.getCacheStats();
print('إجمالي العناصر: ${stats.totalEntries}');
print('العناصر الصالحة: ${stats.validEntries}');
print('معدل الإصابة: ${(stats.hitRate * 100).toStringAsFixed(1)}%');

// مسح كل الكاش
client.clearCache();

// مسح كاش خدمة معينة
client.hadith.clearCache();
client.sharh.clearCache();
client.book.clearCache();
```

### التخلص من الموارد

**مهم جدًا:** يجب دائمًا استدعاء `dispose()` عند الانتهاء من استخدام `DorarClient` لإغلاق اتصالات قاعدة البيانات وتجنب التحذيرات.

```dart
void main() async {
  final client = DorarClient();
  
  try {
    // استخدام المكتبة
    final results = await client.searchHadith(
      HadithSearchParams(value: 'الصلاة', page: 1),
    );
  } finally {
    // التخلص من الموارد (إلزامي)
    await client.dispose();
  }
}
```

### معالجة الأخطاء (Error Handling)

المكتبة تستخدم `sealed class` لتمثيل الأخطاء، مما يجعل التعامل معها أكثر أمانًا ودقة باستخدام Pattern Matching.

#### أنواع الأخطاء (DorarException)

جميع الأخطاء في المكتبة ترث من `DorarException` وهو `sealed class` يحتوي على الأنواع التالية:

```dart
// 1. خطأ الشبكة - مشكلة في الاتصال بالإنترنت
DorarNetworkException {
  final String message;
  final String? details;
}

// 2. انتهاء المهلة - الطلب استغرق وقتًا طويلاً
DorarTimeoutException {
  final String message;
  final Duration timeout;
  final String? details;
}

// 3. غير موجود - المورد المطلوب غير متوفر
DorarNotFoundException {
  final String message;
  final String resource;
  final String? details;
}

// 4. خطأ في التحقق - المدخلات غير صحيحة
DorarValidationException {
  final String message;
  final String? field;        // اسم الحقل الذي به خطأ
  final String? rule;         // القاعدة المخالفة
  final String? details;
}

// 5. خطأ السيرفر - مشكلة في خادم الدرر السنية
DorarServerException {
  final String message;
  final int statusCode;       // رمز حالة HTTP
  final String? details;
}

// 6. خطأ في المعالجة - مشكلة في تحليل الاستجابة
DorarParseException {
  final String message;
  final String? expectedType; // النوع المتوقع
  final String? details;
}

// 7. تجاوز الحد - عدد طلبات كثير جدًا
DorarRateLimitException {
  final String message;
  final int? limit;           // الحد الأقصى للطلبات
  final DateTime? resetAt;    // وقت إعادة التفعيل
  final String? details;
}
```

#### معالجة شاملة باستخدام Switch Expression

أفضل طريقة للتعامل مع الأخطاء هي استخدام Pattern Matching مع `switch`، حيث يضمن المترجم (Compiler) تغطية جميع الحالات:

```dart
try {
  final results = await client.searchHadith(
    HadithSearchParams(value: 'الصلاة', page: 1),
  );
} on DorarException catch (e) {
  // Pattern Matching - المترجم يضمن تغطية كل الحالات!
  final message = switch (e) {
    DorarNetworkException() => 
      '🌐 خطأ في الشبكة: ${e.message}\n'
      'تحقق من اتصالك بالإنترنت',
      
    DorarTimeoutException() => 
      '⏱️ انتهت المهلة بعد ${e.timeout.inSeconds} ثانية\n'
      'حاول مرة أخرى',
      
    DorarNotFoundException() => 
      '🔍 غير موجود: ${e.resource}\n'
      'تأكد من صحة المعرف',
      
    DorarValidationException() => 
      '✋ خطأ في المدخلات: ${e.message}\n'
      '${e.field != null ? "الحقل: ${e.field}" : ""}',
      
    DorarServerException() => 
      '🖥️ خطأ في السيرفر (${e.statusCode}): ${e.message}',
      
    DorarParseException() => 
      '📄 خطأ في معالجة البيانات: ${e.message}',
      
    DorarRateLimitException() => 
      '🚫 تجاوزت الحد المسموح من الطلبات\n'
      '${e.resetAt != null ? "حاول مرة أخرى بعد: ${e.resetAt}" : ""}',
  };
  
  print(message);
}
```

#### دالة مساعدة لرسائل الأخطاء

المكتبة توفر دالة جاهزة لتحويل الأخطاء لرسائل مفهومة:

```dart
import 'package:dorar_hadith/dorar_hadith.dart';

try {
  final results = await client.searchHadith(params);
} on DorarException catch (e) {
  // استخدام الدالة المساعدة
  print(getExceptionMessage(e));
}
```

## الخدمات المتاحة (Available Services)

`DorarClient` يوفر الوصول إلى عدة خدمات متخصصة، كل خدمة مسؤولة عن جزء معين من الوظائف.

### خدمة الأحاديث (Hadith Service)

الخدمة الأساسية للبحث عن الأحاديث والحصول على تفاصيلها.

```dart
final client = DorarClient();

// 1. البحث السريع (عبر API - ~15 نتيجة)
final quickResults = await client.searchHadith(
  HadithSearchParams(value: 'الصلاة', page: 1),
);

// 2. البحث المفصل (عبر الموقع - ~30 نتيجة)
final detailedResults = await client.searchHadithDetailed(
  HadithSearchParams(value: 'الصلاة', page: 1),
);

// 3. الحصول على حديث بالمعرف
final hadith = await client.getHadithById('12345');

// أو استخدام الخدمة مباشرة
final sameResults = await client.hadith.searchViaApi(params);
final sameDetailed = await client.hadith.searchViaSite(params);
final sameHadith = await client.hadith.getById('12345');

// 4. الأحاديث المشابهة
if (hadith.hasSimilarHadith && hadith.hadithId != null) {
  final similar = await client.hadith.getSimilar(hadith.hadithId!);
  print('وجدنا ${similar.length} حديث مشابه');
}

// 5. البديل الصحيح
if (hadith.hasAlternateHadithSahih && hadith.hadithId != null) {
  final alternate = await client.hadith.getAlternate(hadith.hadithId!);
  if (alternate != null) {
    print('البديل الصحيح: ${alternate.hadith}');
  }
}

// 6. أصول الحديث
if (hadith.hasUsulHadith && hadith.hadithId != null) {
  final usulResponse = await client.hadith.getUsul(hadith.hadithId!);
  final usul = usulResponse.data;
  print('عدد المصادر: ${usul.count}');
  for (var source in usul.sources) {
    print('- ${source.source}: ${source.chain}');
  }
}

// 7. مسح الكاش
client.hadith.clearCache();
```

### خدمة الشروح (Sharh Service)

للبحث عن شروح الأحاديث والحصول عليها.

```dart
// 1. البحث في الشروح بنص الحديث
final sharh = await client.sharh.getByText('إنما الأعمال بالنيات');

// يمكن أيضًا البحث في الأحاديث المتخصصة
final specialistSharh = await client.sharh.getByText(
  'نص الحديث',
  specialist: true,
);

// 2. الحصول على شرح بالمعرف
// (المعرف يأتي من DetailedHadith.sharhMetadata.id)
final hadith = await client.getHadithById('12345');
if (hadith.hasSharhMetadata && hadith.sharhMetadata != null) {
  final sharhId = hadith.sharhMetadata!.id;
  final sharh = await client.sharh.getById(sharhId);
  
  if (sharh.sharhText != null) {
    print('الشرح: ${sharh.sharhText}');
  }
}

// 3. البحث عن جميع الشروح المتاحة بنص البحث
final sharhResults = await client.searchSharh(
  HadithSearchParams(value: 'الصلاة'),
);
for (var s in sharhResults.data) {
  print('الحديث: ${s.hadith}');
  print('الشرح: ${s.sharhText}');
}

// 4. مسح الكاش
client.sharh.clearCache();
```

### خدمة الكتب التفصيلية (Book Service)

للحصول على معلومات تفصيلية عن الكتب (يحتاج إنترنت).

```dart
// الحصول على معلومات كتاب بالمعرف
final book = await client.book.getById('6216'); // صحيح البخاري

print('الكتاب: ${book.name}');
print('المؤلف: ${book.author}');
print('المحقق: ${book.reviewer}');
print('الناشر: ${book.publisher}');
print('الطبعة: ${book.edition}');
print('سنة النشر: ${book.editionYear}');

// مسح الكاش
client.book.clearCache();
```

### خدمة المحدثين التفصيليين (Mohdith Service)

للحصول على معلومات تفصيلية عن المحدثين (يحتاج إنترنت).

```dart
// الحصول على معلومات محدث بالمعرف
final mohdith = await client.mohdith.getById('256'); // الإمام البخاري

print('الاسم: ${mohdith.name}');
print('السيرة: ${mohdith.info}');

// مسح الكاش
client.mohdith.clearCache();
```

### خدمة الكتب المرجعية (Book Reference Service)

للبحث في الكتب المتوفرة (بدون إنترنت).

```dart
// 1. البحث بالاسم
final books = await client.bookRef.searchBook('صحيح', limit: 10);

// أو اختصار
final sameBooks = await client.searchBooks('صحيح');

for (var book in books) {
  print('${book.name} - ${book.author}');
}

// 2. الحصول على كتاب بالمعرف
final bukhari = await client.bookRef.getBookById('6216');
print(bukhari.name); // صحيح البخاري

// 3. الحصول على عدة كتب دفعة واحدة
final multipleBooks = await client.bookRef.getBooksByIds([
  '6216', // صحيح البخاري
  '3662', // صحيح مسلم
]);

// 4. عرض جميع الكتب مع الترقيم
final allBooks = await client.bookRef.getAllBooks(
  limit: 50,
  offset: 0,
);

// 5. عد النتائج
final totalBooks = await client.bookRef.countBooks();
final sahihBooks = await client.bookRef.countBooks(query: 'صحيح');
print('إجمالي الكتب: $totalBooks');
print('كتب "صحيح": $sahihBooks');
```

### خدمة المحدثين المرجعيين (Mohdith Reference Service)

للبحث في المحدثين المتوفرين (بدون إنترنت).

```dart
// 1. البحث بالاسم
final scholars = await client.mohdithRef.searchMohdith('البخاري', limit: 5);

// أو اختصار
final sameScholars = await client.searchMohdith('البخاري');

for (var scholar in scholars) {
  print('${scholar.name}');
  if (scholar.deathYear != null) {
    print('سنة الوفاة: ${scholar.deathYear}هـ');
  }
}

// 2. الحصول على محدث بالمعرف
final bukhari = await client.mohdithRef.getMohdithById('256');
print(bukhari.name); // البخاري

// 3. الحصول على عدة محدثين دفعة واحدة
final multipleScholars = await client.mohdithRef.getMohdithByIds([
  '256',  // البخاري
  '261',  // مسلم
]);

// 4. عرض جميع المحدثين مع الترقيم
final allScholars = await client.mohdithRef.getAllMohdith(
  limit: 50,
  offset: 0,
);

// 5. عد النتائج
final totalScholars = await client.mohdithRef.countMohdith();
final classicalScholars = await client.mohdithRef.countMohdith(
  query: 'أحمد',
);
print('إجمالي المحدثين: $totalScholars');
```

### خدمة الرواة المرجعيين (Rawi Reference Service)

للبحث في الرواة المتوفرين (بدون إنترنت).

```dart
// 1. البحث بالاسم
final narrators = await client.rawiRef.searchRawi('أبو هريرة', limit: 10);

// أو اختصار
final sameNarrators = await client.searchRawi('أبو هريرة');

for (var narrator in narrators) {
  print(narrator.name);
}

// 2. الحصول على راوي بالمعرف
final abuHurayrah = await client.rawiRef.getRawiById(4396);
print(abuHurayrah.name); // أبو هريرة عبد الرحمن بن صخر الدوسي

// 3. الحصول على عدة رواة دفعة واحدة
final multipleNarrators = await client.rawiRef.getRawiByIds([
  4396,   // أبو هريرة
  5593,   // عائشة
]);

// 4. عرض جميع الرواة مع الترقيم
final allNarrators = await client.rawiRef.getAllRawi(
  limit: 100,
  offset: 0,
);

// 5. عد النتائج
final totalNarrators = await client.rawiRef.countRawi();
final abdullahNarrators = await client.rawiRef.countRawi(query: 'عبد الله');
print('إجمالي الرواة: $totalNarrators');
print('رواة "عبد الله": $abdullahNarrators');
```

### القيم الثابتة للفلترة

المكتبة توفر قيم ثابتة جاهزة لأشهر المحدثين والكتب والرواة لتسهيل عملية الفلترة.

#### المحدثون الثابتون (MohdithReference)

```dart
// القيم الثابتة المتاحة (20 محدث)
MohdithReference.all             // الجميع (بدون فلتر) - ID: 0
MohdithReference.malik           // الإمام مالك - ID: 179
MohdithReference.shafii          // الإمام الشافعي - ID: 204
MohdithReference.ahmad           // الإمام أحمد - ID: 241
MohdithReference.bukhari         // البخاري - ID: 256
MohdithReference.muslim          // مسلم - ID: 261
MohdithReference.ibnMajah        // ابن ماجه - ID: 273
MohdithReference.abuDawud        // أبو داود - ID: 275
MohdithReference.tirmidhi        // الترمذي - ID: 279
MohdithReference.nasai           // النسائي - ID: 303
MohdithReference.sufyanThawri    // سفيان الثوري - ID: 161
MohdithReference.ibnMubarak      // عبدالله بن المبارك - ID: 181
MohdithReference.sufyanIbnUyaynah // سفيان بن عيينة - ID: 198
MohdithReference.ishaqIbnRahawayh // إسحاق بن راهويه - ID: 238
MohdithReference.darimi          // الدارمي - ID: 250
MohdithReference.ibnKhuzaymah    // ابن خزيمة - ID: 311
MohdithReference.ibnHibban       // ابن حبان - ID: 354
MohdithReference.hakim           // الحاكم - ID: 405
MohdithReference.bayhaqi         // البيهقي - ID: 458
MohdithReference.tabarani        // الطبراني - ID: 360

// كل قيمة لها معرف واسم
final bukhari = MohdithReference.bukhari;
print(bukhari.id);    // "256"
print(bukhari.name);  // "البخاري"

// الاستخدام في الفلترة
final params = HadithSearchParams(
  value: 'الصلاة',
  page: 1,
  mohdith: [MohdithReference.bukhari],
);

// الحصول على المعرف كرقم للاستخدام في الفلترة
final bukhariId = int.parse(MohdithReference.bukhari.id);
```

#### الكتب الثابتة (BookReference)

```dart
// القيم الثابتة المتاحة (21 كتاب)
BookReference.all                 // الجميع (بدون فلتر)
BookReference.sahihBukhari        // صحيح البخاري (6216)
BookReference.sahihMuslim         // صحيح مسلم (3088)
BookReference.arbainNawawi        // الأربعون النووية (13457)
BookReference.sahihMusnad         // الصحيح المسند (96)
BookReference.sunanAbuDawud       // سنن أبي داود (4549)
BookReference.jamiTirmidhi        // سنن الترمذي (3662)
BookReference.sunanNasai          // سنن النسائي (5766)
BookReference.sunanIbnMajah       // سنن ابن ماجه (5299)
BookReference.musnadAhmad         // مسند أحمد (14)
BookReference.muwattaMalik        // موطأ مالك (6453)
BookReference.musnadDarimi        // سنن الدارمي (6277)
BookReference.sahihIbnKhuzaymah   // صحيح ابن خزيمة (3024)
BookReference.sahihIbnHibban      // صحيح ابن حبان (5876)
BookReference.mustadrakHakim      // المستدرك على الصحيحين (2800)
BookReference.sunanBayhaqiKubra   // السنن الكبرى للبيهقي (7989)
BookReference.sunanDaraqutni      // سنن الدارقطني (3233)
BookReference.musannafIbnAbiShaybah // مصنف ابن أبي شيبة (6598)
BookReference.musannafAbdRazzaq   // مصنف عبد الرزاق (7613)
BookReference.riyadSalihin        // رياض الصالحين (10106)
BookReference.bulughMaram         // بلوغ المرام (9927)

// كل قيمة لها معرف واسم
final bukhari = BookReference.sahihBukhari;
print(bukhari.id);    // "6216"
print(bukhari.name);  // "صحيح البخاري"

// الاستخدام في الفلترة
final params = HadithSearchParams(
  value: 'الزكاة',
  page: 1,
  books: [
    BookReference.sahihBukhari,
    BookReference.sahihMuslim,
  ],
);

// الحصول على المعرف كرقم للاستخدام في الفلترة
final bukhariId = int.parse(BookReference.sahihBukhari.id);
```

#### الرواة الثابتون (RawiReference)

**ملاحظة:** يوجد حوالي 14,000 راوي في قاعدة البيانات، لذلك تم توفير بعض الصحابة فقط كقيم ثابتة.

```dart
// القيم الثابتة المتاحة (20 صحابي)
RawiReference.all                // الجميع (بدون فلتر)
RawiReference.abuHurayrah        // أبو هريرة (1416)
RawiReference.aisha              // عائشة أم المؤمنين (6617)
RawiReference.ibnAbbas           // ابن عباس (2664)
RawiReference.ibnUmar            // عبدالله بن عمر (7687)
RawiReference.anasBinMalik       // أنس بن مالك (2177)
RawiReference.jabirIbnAbdullah  // جابر بن عبدالله (3971)
RawiReference.abuSaidKhudri      // أبو سعيد الخدري (779)
RawiReference.ibnMasud           // عبدالله بن مسعود (7918)
RawiReference.abuMusaAshari      // أبو موسى الأشعري (1342)
RawiReference.umarIbnKhattab     // عمر بن الخطاب (8918)
RawiReference.aliIbnAbiTalib     // علي بن أبي طالب (8637)
RawiReference.abuBakr            // أبو بكر الصديق (455)
RawiReference.uthmanIbnAffan     // عثمان بن عفان (8310)
RawiReference.salmanFarisi       // سلمان الفارسي (5947)
RawiReference.muadhIbnJabal      // معاذ بن جبل (10349)
RawiReference.abuDharr           // أبو ذر الغفاري (667)
RawiReference.bilal              // بلال بن رباح (3808)
RawiReference.zaydIbnThabit      // زيد بن ثابت (5545)
RawiReference.ubayyIbnKab        // أبي بن كعب (1695)
RawiReference.abuAyyub           // أبو أيوب الأنصاري (129)

// كل قيمة لها معرف واسم
final abuHurayrah = RawiReference.abuHurayrah;
print(abuHurayrah.id);    // "1416"
print(abuHurayrah.name);  // "أبو هريرة"

// الاستخدام في الفلترة
final params = HadithSearchParams(
  value: 'الجنة',
  page: 1,
  rawi: [RawiReference.abuHurayrah],
);

// الحصول على المعرف كرقم للاستخدام في الفلترة
final abuHurayrahId = int.parse(RawiReference.abuHurayrah.id);

// للبحث عن رواة آخرين، استخدم خدمة البحث
final narrators = await client.rawiRef.searchRawi('عبد الله', limit: 10);
```

### يوجد لدي تحذير بعنوان "Unclosed database"؟

يجب دائمًا استدعاء `client.dispose()`:

```dart
final client = DorarClient();
try {
  // استخدام المكتبة
} finally {
  await client.dispose(); // إلزامي
}
```
او استخدم `DorarClient.use` عند طلب اي شيء من العميل وعند الإنتهاء من الطلب يقوم بالتخلص من العميل تلقائيًا، مثال:
```dart
final results = await DorarClient.use((client) async {
    return await client.searchHadith(
      HadithSearchParams(value: 'الصلاة', page: 1),
    );
});
```
## المساهمة

المساهمة بأي شكل من الأشكال مرحب به.
## License

MIT License - see [LICENSE](LICENSE) file.

## Architecture

```
DorarClient (Facade)
    ├── HadithService
    ├── SharhService  
    ├── BookService
    ├── MohdithService
    ├── MohdithRefService 
    ├── BookRefService 
    └── RawiRefService 
         └── HTTP Client + Cache
              └── HTML Parsers
```

#### سائلًا الله تعالى أن يكتب اجري واجركم
