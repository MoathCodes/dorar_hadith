/// Comprehensive CLI example for `dorar_hadith`.
///
/// Run from the package root (requires network for API sections):
///
/// ```bash
/// dart run example/example.dart
/// ```
///
/// Offline reference sections (`bookRef`, `mohdithRef`, `rawiRef`) resolve
/// bundled assets via the package URI on native CLI — no Flutter setup needed.
///
/// **Flutter apps:** call `DorarHadithFlutter.ensureInitialized()` from
/// [`dorar_hadith_flutter`](https://pub.dev/packages/dorar_hadith_flutter)
/// before offline APIs; this example uses only core `dorar_hadith` APIs.
///
/// Covers:
/// - Simple and advanced hadith search
/// - Offline reference data (books, scholars, narrators)
/// - Sharh, details, similar/alternate/usul hadiths
/// - Cache management and sealed [DorarException] handling
library;

import 'package:dorar_hadith/dorar_hadith.dart';

void main() async {
  print('═══════════════════════════════════════════════════════');
  print('مثال شامل لمكتبة dorar_hadith');
  print('═══════════════════════════════════════════════════════\n');

  // إنشاء العميل
  final client = DorarClient();

  try {
    // 1️⃣ البحث البسيط
    print('\n📖 1. البحث البسيط عن الأحاديث');
    print('─────────────────────────────────────────────────────');
    await simpleSearch(client);

    // 2️⃣ البحث المتقدم مع الترشيح
    print('\n\n🔍 2. البحث المتقدم مع الترشيح');
    print('─────────────────────────────────────────────────────');
    await advancedSearch(client);

    // 3️⃣ البيانات المرجعية (بدون إنترنت)
    print('\n\n📚 3. البيانات المرجعية (بدون إنترنت)');
    print('─────────────────────────────────────────────────────');
    await referenceData(client);

    // 4️⃣ شرح الأحاديث
    print('\n\n💡 4. شرح الأحاديث');
    print('─────────────────────────────────────────────────────');
    await hadithExplanations(client);

    // 5️⃣ التفاصيل الكاملة لحديث
    print('\n\n📋 5. التفاصيل الكاملة لحديث');
    print('─────────────────────────────────────────────────────');
    await hadithDetails(client);

    // 6️⃣ معلومات عن الكتب والمحدثين
    print('\n\n📖 6. معلومات تفصيلية');
    print('─────────────────────────────────────────────────────');
    await detailedInfo(client);

    // 7️⃣ الأحاديث المشابهة والبديلة
    print('\n\n🔗 7. الأحاديث المشابهة والبديلة');
    print('─────────────────────────────────────────────────────');
    await relatedHadiths(client);

    // 8️⃣ إدارة الكاش
    print('\n\n💾 8. إدارة الكاش');
    print('─────────────────────────────────────────────────────');
    await cacheManagement(client);

    // 9️⃣ معالجة الأخطاء (Sealed Class Features)
    print('\n\n⚠️  9. معالجة الأخطاء بذكاء (Sealed Class)');
    print('─────────────────────────────────────────────────────');
    await errorHandlingExamples(client);

    print('\n\n═══════════════════════════════════════════════════════');
    print('✅ انتهى المثال بنجاح!');
    print('═══════════════════════════════════════════════════════');
  } on DorarException catch (e) {
    // استخدام Pattern Matching للتعامل مع الأخطاء بشكل شامل
    print('\n❌ حدث خطأ: ${handleDorarException(e)}\n');
  } finally {
    // تنظيف الموارد
    await client.dispose();
  }
}

/// 2️⃣ البحث المتقدم مع الترشيح
Future<void> advancedSearch(DorarClient client) async {
  // البحث مع فلاتر متقدمة
  final params = HadithSearchParams(
    value: 'الصدقة',
    page: 1,
    // فقط الأحاديث الصحيحة
    degrees: [.authenticHadith],
    // من صحيح مسلم
    books: [.sahihMuslim],
    // طريقة البحث: جميع الكلمات
    searchMethod: .allWords,
    // نوع الحديث: أحاديث قدسية
    zone: .qudsi,
  );

  final results = await client.hadith.searchViaSite(params);

  print('البحث عن: "${params.value}"');
  print('الترشيح: أحاديث صحيحة من صحيح مسلم');
  print('عدد النتائج: ${results.data.length}');

  // عرض أول 3 نتائج
  for (
    var i = 0;
    i < (results.data.length < 3 ? results.data.length : 3);
    i++
  ) {
    final h = results.data[i];
    print(
      '\n${i + 1}. ${h.hadith.substring(0, 80 > h.hadith.length ? h.hadith.length : 80)}...',
    );
    print('   الراوي: ${h.rawi} | الدرجة: ${h.grade}');
  }
}

/// 8️⃣ إدارة الكاش
Future<void> cacheManagement(DorarClient client) async {
  // البحث الأول (سيتم تخزينه في الكاش)
  final params = HadithSearchParams(value: 'الإيمان', page: 1);

  print('🔍 البحث الأول (من API):');
  final result1 = await client.searchHadith(params);
  print('   النتائج: ${result1.data.length}');
  print('   من الكاش: ${result1.metadata.isCached}');

  // البحث الثاني (من الكاش)
  print('\n🔍 البحث الثاني (من الكاش):');
  final result2 = await client.searchHadith(params);
  print('   النتائج: ${result2.data.length}');
  print('   من الكاش: ${result2.metadata.isCached}');

  // مسح كاش خدمة معينة
  print('\n🧹 مسح كاش خدمة الأحاديث...');
  client.hadith.clearCache();
  print('   تم المسح!');

  // يمكن مسح كل الكاش
  // client.clearCache();
}

/// دالة توضيحية لمعالجة كل نوع من الأخطاء بشكل مختلف
Future<void> demonstrateSpecificErrorHandling(DorarClient client) async {
  try {
    // محاولة عملية قد تفشل
    await client.searchHadith(HadithSearchParams(value: 'x', page: 1));
  } on DorarNetworkException catch (e) {
    print('   📱 تحقق من اتصال الإنترنت');
    print('   تفاصيل: ${e.message}');
  } on DorarTimeoutException catch (e) {
    print('   ⏱️  الطلب استغرق وقتاً طويلاً (${e.timeout.inSeconds}s)');
    print('   💡 جرب مرة أخرى أو تحقق من سرعة الإنترنت');
  } on DorarRateLimitException catch (e) {
    print('   🚫 تجاوزت عدد الطلبات المسموحة');
    if (e.resetAt != null) {
      print('   ⏰ حاول مرة أخرى بعد: ${e.resetAt}');
    }
    if (e.limit != null) {
      print('   📊 الحد الأقصى: ${e.limit} طلب');
    }
  } on DorarServerException catch (e) {
    print('   🖥️  مشكلة في السيرفر (${e.statusCode})');
    print('   💬 ${e.message}');
    if (e.details != null) {
      print('   تفاصيل إضافية: ${e.details}');
    }
  } on DorarValidationException catch (e) {
    print('   ✋ خطأ في المدخلات');
    print('   الحقل: ${e.field ?? "غير محدد"}');
    print('   السبب: ${e.message}');
  } on DorarParseException catch (e) {
    print('   📄 خطأ في معالجة الاستجابة');
    if (e.expectedType != null) {
      print('   النوع المتوقع: ${e.expectedType}');
    }
  } on DorarNotFoundException catch (e) {
    print('   🔍 لم نجد ما تبحث عنه: ${e.resource}');
  }
}

/// 6️⃣ معلومات تفصيلية عن الكتب والمحدثين
Future<void> detailedInfo(DorarClient client) async {
  // معلومات عن كتاب (صحيح البخاري)
  print('📖 معلومات صحيح البخاري:');
  final bukhari = await client.book.getById(BookReference.sahihBukhari.id);

  print('الاسم: ${bukhari.name}');
  print('المؤلف: ${bukhari.author}');
  print('المحقق: ${bukhari.reviewer}');
  print('الناشر: ${bukhari.publisher}');
  print('الطبعة: ${bukhari.edition}');
  print('سنة النشر: ${bukhari.editionYear}');

  // معلومات عن محدث (الإمام البخاري)
  print('\n👤 معلومات الإمام البخاري:');
  final bukhariInfo = await client.mohdith.getById(MohdithReference.bukhari.id);

  print('الاسم: ${bukhariInfo.name}');
  if (bukhariInfo.info.isNotEmpty) {
    final bio = bukhariInfo.info.substring(
      0,
      300 > bukhariInfo.info.length ? bukhariInfo.info.length : 300,
    );
    print('نبذة: $bio...');
  }
}

/// 9️⃣ أمثلة على معالجة الأخطاء باستخدام Sealed Classes
Future<void> errorHandlingExamples(DorarClient client) async {
  print('💡 Sealed Classes تتيح Pattern Matching الشامل\n');

  // مثال 1: محاولة البحث بمعامل غير صحيح
  print('1️⃣  مثال: خطأ في التحقق من الصحة (Validation)');
  try {
    await client.searchHadith(
      HadithSearchParams(value: '', page: 0), // صفحة غير صحيحة
    );
  } on DorarValidationException catch (e) {
    print('   ❌ خطأ في التحقق: ${e.message}');
    if (e.field != null) print('   الحقل: ${e.field}');
    if (e.rule != null) print('   القاعدة: ${e.rule}');
  } catch (e) {
    print('   خطأ غير متوقع: $e');
  }

  // مثال 2: محاولة الحصول على حديث غير موجود
  print('\n2️⃣  مثال: مورد غير موجود (Not Found)');
  try {
    await client.getHadithById('999999999');
  } on DorarNotFoundException catch (e) {
    print('   ❌ غير موجود: ${e.resource}');
    print('   رسالة: ${e.message}');
  } catch (e) {
    print('   خطأ آخر: $e');
  }

  // مثال 3: استخدام Switch Expression للتعامل الشامل
  print('\n3️⃣  مثال: Switch Expression (Pattern Matching)');
  try {
    // محاولة بحث قد تفشل
    await client.searchHadith(HadithSearchParams(value: 'test', page: 9999));
  } on DorarException catch (e) {
    // Pattern Matching الشامل - يجب تغطية كل الحالات!
    final errorMessage = switch (e) {
      DorarNetworkException() => '🌐 خطأ في الشبكة: ${e.message}',
      DorarTimeoutException() =>
        '⏱️  انتهت المهلة بعد ${e.timeout.inSeconds} ثانية',
      DorarNotFoundException() => '🔍 ${e.resource} غير موجود',
      DorarValidationException() => '✋ خطأ في المدخلات: ${e.message}',
      DorarServerException() => '🖥️  خطأ في السيرفر (${e.statusCode})',
      DorarParseException() => '📄 خطأ في معالجة البيانات: ${e.message}',
      DorarRateLimitException() => '🚫 تجاوزت الحد المسموح من الطلبات',
    };

    print('   $errorMessage');
  }

  // مثال 4: التعامل مع أخطاء محددة بشكل مختلف
  print('\n4️⃣  مثال: معالجة مخصصة لكل نوع خطأ');
  await demonstrateSpecificErrorHandling(client);
}

/// 5️⃣ التفاصيل الكاملة لحديث
Future<void> hadithDetails(DorarClient client) async {
  // البحث عن حديث
  final result = await client.searchHadithDetailed(
    HadithSearchParams(value: 'إنما الأعمال بالنيات'),
  );

  if (result.data.isNotEmpty) {
    final hadith = result.data.first;
    print('📝 معلومات الحديث:');
    print('───────────────────────────────────────────────────');
    print('النص: ${hadith.hadith}');
    print('───────────────────────────────────────────────────');
    print('الراوي: ${hadith.rawi}');
    print('المحدث: ${hadith.mohdith}');
    print('الكتاب: ${hadith.book}');
    print('رقم الحديث/الصفحة: ${hadith.numberOrPage}');

    if (hadith.explainGrade != null && hadith.explainGrade!.isNotEmpty) {
      print('الدرجة: ${hadith.explainGrade}');
    }

    if (hadith.takhrij != null && hadith.takhrij!.isNotEmpty) {
      final takhrij = hadith.takhrij!.substring(
        0,
        150 > hadith.takhrij!.length ? hadith.takhrij!.length : 150,
      );
      print('التخريج: $takhrij...');
    }

    // معلومات إضافية إذا كان لديها معرفات
    if (hadith.hadithId != null) {
      print('\nمعرف الحديث: ${hadith.hadithId}');

      // محاولة الحصول على الأحاديث المشابهة
      if (hadith.hasSimilarHadith) {
        try {
          final similar = await client.hadith.getSimilar(hadith.hadithId!);
          print('عدد الأحاديث المشابهة: ${similar.length}');
        } catch (e) {
          print('لم نتمكن من جلب الأحاديث المشابهة');
        }
      }
    }
  }
}

/// 4️⃣ شرح الأحاديث
Future<void> hadithExplanations(DorarClient client) async {
  // الطريقة الصحيحة: البحث عن حديث أولاً، ثم جلب الشرح إذا كان متوفراً
  final hadithResults = await client.searchHadithDetailed(
    HadithSearchParams(value: 'النية', page: 1),
  );

  if (hadithResults.data.isNotEmpty) {
    // البحث عن حديث له شرح
    final hadithWithSharh = hadithResults.data.firstWhere(
      (h) => h.hasSharhMetadata && h.sharhMetadata?.id != null,
      orElse: () => hadithResults.data.first,
    );

    print('الحديث:');
    print(
      hadithWithSharh.hadith.substring(
        0,
        120 > hadithWithSharh.hadith.length
            ? hadithWithSharh.hadith.length
            : 120,
      ),
    );
    print('...');

    // جلب الشرح باستخدام المعرف من بيانات الحديث
    if (hadithWithSharh.hasSharhMetadata &&
        hadithWithSharh.sharhMetadata?.id != null) {
      try {
        final sharh = await client.sharh.getById(
          hadithWithSharh.sharhMetadata!.id,
        );

        if (sharh.sharhText != null) {
          final sharhText = sharh.sharhText!;
          final preview = sharhText.substring(
            0,
            200 > sharhText.length ? sharhText.length : 200,
          );
          print('\n📖 الشرح متوفر:');
          print('$preview...');
        }

        print('\nالراوي: ${sharh.hadith.rawi}');
        print('المحدث: ${sharh.hadith.mohdith}');
        print('الكتاب: ${sharh.hadith.book}');
      } catch (e) {
        print('\n⚠️  لم نتمكن من جلب الشرح');
      }
    } else {
      print('\n⚠️  هذا الحديث ليس له شرح متوفر');
    }
  }
}

/// دالة مساعدة لمعالجة الأخطاء باستخدام Pattern Matching
String handleDorarException(DorarException exception) {
  // استخدام Switch Expression - الكومبايلر يضمن تغطية كل الحالات!
  return switch (exception) {
    DorarNetworkException() =>
      '🌐 خطأ في الشبكة: ${exception.message}\n'
          '💡 تأكد من اتصالك بالإنترنت',
    DorarTimeoutException() =>
      '⏱️  انتهت المهلة بعد ${exception.timeout.inSeconds} ثانية\n'
          '💡 حاول مرة أخرى أو تحقق من سرعة الإنترنت',
    DorarNotFoundException() =>
      '🔍 غير موجود: ${exception.resource}\n'
          '💡 تأكد من صحة المعرف أو معايير البحث',
    DorarValidationException() =>
      '✋ خطأ في المدخلات: ${exception.message}\n'
          '${exception.field != null ? "الحقل: ${exception.field}\n" : ""}'
          '💡 راجع المعاملات التي أدخلتها',
    DorarServerException() =>
      '🖥️  خطأ في السيرفر (${exception.statusCode}): ${exception.message}\n'
          '💡 حاول مرة أخرى لاحقاً',
    DorarParseException() =>
      '📄 خطأ في معالجة البيانات: ${exception.message}\n'
          '${exception.expectedType != null ? "النوع المتوقع: ${exception.expectedType}\n" : ""}'
          '💡 قد يكون هناك تحديث في API',
    DorarRateLimitException() =>
      '🚫 تجاوزت الحد المسموح من الطلبات\n'
          '${exception.resetAt != null ? "⏰ حاول مرة أخرى بعد: ${exception.resetAt}\n" : ""}'
          '${exception.limit != null ? "📊 الحد الأقصى: ${exception.limit} طلب\n" : ""}'
          '💡 انتظر قليلاً قبل المحاولة مرة أخرى',
  };
}

/// 3️⃣ البيانات المرجعية (بدون إنترنت)
Future<void> referenceData(DorarClient client) async {
  // البحث في الكتب
  print('\n📚 البحث في الكتب:');
  final books = await client.bookRef.searchBook('صحيح', limit: 5);
  print('وجدنا ${books.length} كتاب:');
  for (var book in books) {
    final author = book.author ?? 'غير محدد';
    print('  • ${book.name}');
    print('    المؤلف: $author');
  }

  // البحث في المحدثين
  print('\n👤 البحث في المحدثين:');
  final scholars = await client.mohdithRef.searchMohdith('البخاري', limit: 3);
  print('وجدنا ${scholars.length} محدث:');
  for (var scholar in scholars) {
    print('  • ${scholar.name}');
  }

  // البحث في الرواة
  print('\n📜 البحث في الرواة:');
  final narrators = await client.rawiRef.searchRawi('أبو هريرة', limit: 3);
  print('وجدنا ${narrators.length} راوي:');
  for (var narrator in narrators) {
    print('  • ${narrator.name}');
  }

  // الإحصائيات
  print('\n📊 الإحصائيات:');
  final totalBooks = await client.bookRef.countBooks();
  final totalScholars = await client.mohdithRef.countMohdith();
  final totalNarrators = await client.rawiRef.countRawi();
  print('  - إجمالي الكتب: $totalBooks');
  print('  - إجمالي المحدثين: $totalScholars');
  print('  - إجمالي الرواة: $totalNarrators');
}

/// 7️⃣ الأحاديث المشابهة والبديلة
Future<void> relatedHadiths(DorarClient client) async {
  // البحث عن حديث له أحاديث مشابهة
  final searchResult = await client.searchHadithDetailed(
    HadithSearchParams(value: 'الطهور شطر الإيمان', page: 1),
  );

  if (searchResult.data.isNotEmpty) {
    final hadith = searchResult.data.first;

    if (hadith.hadithId != null) {
      print('الحديث: ${hadith.hadith}');
      print('معرف الحديث: ${hadith.hadithId}');

      // الأحاديث المشابهة
      if (hadith.hasSimilarHadith) {
        try {
          final similar = await client.hadith.getSimilar(hadith.hadithId!);
          print('\n📚 وجدنا ${similar.length} حديث مشابه');
          if (similar.isNotEmpty) {
            final first = similar.first;
            print(
              '   مثال: ${first.hadith.substring(0, 80 > first.hadith.length ? first.hadith.length : 80)}...',
            );
          }
        } catch (e) {
          print('لم نتمكن من جلب الأحاديث المشابهة');
        }
      }

      // الحديث الصحيح البديل
      if (hadith.hasAlternateHadithSahih) {
        try {
          final alternate = await client.hadith.getAlternate(hadith.hadithId!);
          if (alternate != null) {
            print('\n✅ الحديث الصحيح البديل:');
            print(
              '   ${alternate.hadith.substring(0, 80 > alternate.hadith.length ? alternate.hadith.length : 80)}...',
            );
            print('   الدرجة: ${alternate.grade}');
          }
        } catch (e) {
          print('لم نتمكن من جلب الحديث البديل');
        }
      }

      // أصول الحديث (Usul)
      if (hadith.hasUsulHadith) {
        try {
          final usulResponse = await client.hadith.getUsul(hadith.hadithId!);
          final usul = usulResponse.data;
          print('\n📖 أصول الحديث:');
          print('   عدد المصادر: ${usul.count}');
          if (usul.sources.isNotEmpty) {
            print('   أول مصدر: ${usul.sources.first.source}');
          }
        } catch (e) {
          print('لم نتمكن من جلب أصول الحديث');
        }
      }
    }
  } else {
    print('لم نجد نتائج للبحث');
  }
}

/// 1️⃣ البحث البسيط عن الأحاديث
Future<void> simpleSearch(DorarClient client) async {
  // البحث عن أحاديث تحتوي على كلمة "الصلاة"
  final results = await client.searchHadith(
    HadithSearchParams(value: 'الصلاة', page: 1),
  );

  print('البحث عن: "الصلاة"');
  print('عدد النتائج: ${results.data.length}');

  if (results.data.isNotEmpty) {
    final hadith = results.data.first;
    print('\nأول حديث:');
    print(
      'النص: ${hadith.hadith.substring(0, 150 > hadith.hadith.length ? hadith.hadith.length : 150)}...',
    );
    print('الراوي: ${hadith.rawi}');
    print('المحدث: ${hadith.mohdith}');
    print('الكتاب: ${hadith.book}');
    print('الدرجة: ${hadith.grade}');
  }
}
