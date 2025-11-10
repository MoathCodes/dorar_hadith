/// Mock HTTP responses for testing services
library;

/// Mock alternate hadith response (second element - with Arabic content)
const mockAlternateHadithResponse = '''
<html>
<body>
  <div class="border-bottom">
    <div>حديث أصلي</div>
    <div></div>
  </div>
  <div class="border-bottom">
    <div>حديث بديل صحيح</div>
    <div>
  <strong>الراوي: <span>ابن عمر</span></strong>
  <strong>المحدث: <span><a view-card="mhd" card-link="261">مسلم</a></span></strong>
  <strong>المصدر: <span><a view-card="book" card-link="3088">صحيح مسلم</a></span></strong>
      <strong>خلاصة حكم المحدث: <span>صحيح</span></strong>
    </div>
  </div>
</body>
</html>
''';

/// Mock book page response (JSON format, returns HTML inside JSON string - with Arabic)
const mockBookPageResponse =
    '''"<h5>6216 - صحيح البخاري</h5><span>الإمام محمد بن إسماعيل البخاري</span><span>مراجعة الشيخ عبد الله</span><span>دار السلام للنشر</span><span>الطبعة الأولى</span><span>2020</span>"''';

/// Mock data endpoint responses
const mockBooksDataResponse = '''
[
  {"id": "6216", "name": "صحيح البخاري"},
  {"id": "3088", "name": "صحيح مسلم"}
]
''';

const mockDegreesDataResponse = '''
[
  {"id": "0", "name": "جميع الدرجات"},
  {"id": "1", "name": "صحيح"}
]
''';

/// Mock single hadith by ID response (with Arabic content and proper structure)
const mockHadithByIdResponse = '''
<html>
<body>
  <div class="border-bottom">
    <div>- : إنما الأعمال بالنيات</div>
    <div>
  <strong>الراوي: <span>عمر بن الخطاب</span></strong>
  <strong>المحدث: <span><a view-card="mhd" card-link="256">البخاري</a></span></strong>
  <strong>المصدر: <span><a view-card="book" card-link="6216">صحيح البخاري</a></span></strong>
      <strong>الصفحة أو الرقم: <span>1</span></strong>
      <strong>خلاصة حكم المحدث: <span>صحيح</span></strong>
    </div>
  </div>
</body>
</html>
''';

/// Mock successful hadith search API response (with Arabic labels)
const mockHadithSearchApiResponse =
    '''{"ahadith":{"result":"<div><span>1 - إنما الأعمال بالنيات</span></div><div class=\\"hadith-info\\"><span class=\\"info-subtitle\\">الراوي:</span><span>عمر بن الخطاب</span><span class=\\"info-subtitle\\">المحدث:</span><span><a view-card=\\"mhd\\" card-link=\\"256\\">البخاري</a></span><span class=\\"info-subtitle\\">المصدر:</span><span><a view-card=\\"book\\" card-link=\\"6216\\">صحيح البخاري</a></span><span class=\\"info-subtitle\\">الصفحة أو الرقم:</span><span>1</span><span class=\\"info-subtitle\\">خلاصة حكم المحدث:</span><span>[صحيح]</span></div><div><span>2 - المؤمن مرآة أخيه</span></div><div class=\\"hadith-info\\"><span class=\\"info-subtitle\\">الراوي:</span><span>أبو هريرة</span><span class=\\"info-subtitle\\">المحدث:</span><span><a view-card=\\"mhd\\" card-link=\\"279\\">الترمذي</a></span><span class=\\"info-subtitle\\">المصدر:</span><span>جامع الترمذي</span><span class=\\"info-subtitle\\">الصفحة أو الرقم:</span><span>123</span><span class=\\"info-subtitle\\">خلاصة حكم المحدث:</span><span>حسن</span></div>"}}''';

/// Mock hadith search site response (HTML - with Arabic content and proper structure)
const mockHadithSearchSiteResponse = '''
<html>
<body>
  <div id="home">
    <a aria-controls="home">نتائج (2)</a>
    <a aria-controls="specialist">متخصص (0)</a>
    <div class="border-bottom">
      <div><a tag="123"><span>إنما الأعمال بالنيات</span></a></div>
      <div>
  <strong>الراوي: <span>عمر بن الخطاب</span></strong>
  <strong>المحدث: <span><a view-card="mhd" card-link="256">البخاري</a></span></strong>
  <strong>المصدر: <span><a view-card="book" card-link="6216">صحيح البخاري</a></span></strong>
        <strong>الصفحة أو الرقم: <span>1</span></strong>
        <strong>خلاصة حكم المحدث: <span>صحيح</span></strong>
        <a href="/h/123?sims=1">أحاديث مشابهة</a>
        <a xplain="456">شرح</a>
      </div>
    </div>
    <div class="border-bottom">
      <div><a tag="124"><span>المؤمن مرآة أخيه</span></a></div>
      <div>
        <strong>الراوي: <span>أبو هريرة</span></strong>
        <strong>المحدث: <span><a view-card="mhd" card-link="3">الترمذي</a></span></strong>
        <strong>المصدر: <span>جامع الترمذي</span></strong>
        <strong>الصفحة أو الرقم: <span>123</span></strong>
        <strong>خلاصة حكم المحدث: <span>حسن</span></strong>
      </div>
    </div>
  </div>
  <div id="specialist">
    <div class="border-bottom">
      <div><a tag="789"><span>حديث متخصص</span></a></div>
      <div>
  <strong>الراوي: <span>علي بن أبي طالب</span></strong>
  <strong>المحدث: <span><a view-card="mhd" card-link="256">البخاري</a></span></strong>
  <strong>المصدر: <span><a view-card="book" card-link="6216">صحيح البخاري</a></span></strong>
        <strong>الصفحة أو الرقم: <span>999</span></strong>
        <strong>خلاصة حكم المحدث: <span>صحيح</span></strong>
      </div>
    </div>
  </div>
</body>
</html>
''';

const mockMohdithDataResponse = '''
[
  {"id": "256", "name": "البخاري"},
  {"id": "261", "name": "مسلم"}
]
''';

/// Mock mohdith page response (with Arabic content)
const mockMohdithPageResponse = '''
<html>
<body>
  <h4>معلومات المحدث</h4>
  <span>الإمام البخاري (194-256 هـ)</span>
</body>
</html>
''';

/// Mock error responses
const mockNotFoundResponse = '''
<html>
<body>
  <h1>404 Not Found</h1>
</body>
</html>
''';

const mockServerErrorResponse = '''
<html>
<body>
  <h1>500 Internal Server Error</h1>
</body>
</html>
''';

/// Mock sharh page response (with Arabic content)
const mockSharhPageResponse = '''
<html>
<body>
  <article>
    <h4>شرح الحديث</h4>
    <p>هذا شرح الحديث الشريف</p>
    <span>إنما الأعمال بالنيات</span>
  </article>
  <div class="primary-text-color">عمر بن الخطاب</div>
  <div class="primary-text-color">البخاري</div>
  <div class="primary-text-color">صحيح البخاري</div>
  <div class="primary-text-color">1/1</div>
  <div class="primary-text-color">صحيح</div>
  <div class="primary-text-color">متحقق</div>
  <div class="text-justify">نص الحديث:</div>
  <div>هذا شرح تفصيلي للحديث عن النيات، إنما الأعمال بالنيات، وأهميتها في الإسلام.</div>
</body>
</html>
''';

/// Mock sharh search results with IDs (with Arabic content)
const mockSharhSearchResponse = '''
<html>
<body>
  <div id="home">
    <div class="result border-bottom">
      <a xplain="123">حديث 1</a>
      <span>إنما الأعمال بالنيات</span>
    </div>
    <div class="result border-bottom">
      <a xplain="456">حديث 2</a>
      <span>المؤمن مرآة أخيه</span>
    </div>
    <div class="result border-bottom">
      <a xplain="0">حديث بدون شرح</a>
      <span>نص حديث ما</span>
    </div>
  </div>
</body>
</html>
''';

/// Mock similar hadiths response (with Arabic content)
const mockSimilarHadithsResponse = '''
<html>
<body>
  <div class="border-bottom">
    <div>حديث مشابه 1</div>
    <div>
  <strong>الراوي: <span>أبو هريرة</span></strong>
  <strong>المحدث: <span><a view-card="mhd" card-link="261">مسلم</a></span></strong>
      <strong>المصدر: <span>صحيح مسلم</span></strong>
      <strong>الصفحة أو الرقم: <span>456</span></strong>
      <strong>خلاصة حكم المحدث: <span>صحيح</span></strong>
    </div>
  </div>
  <div class="border-bottom">
    <div>حديث مشابه 2</div>
    <div>
      <strong>الراوي: <span>عائشة</span></strong>
  <strong>المحدث: <span><a view-card="mhd" card-link="256">البخاري</a></span></strong>
      <strong>المصدر: <span>صحيح البخاري</span></strong>
      <strong>الصفحة أو الرقم: <span>789</span></strong>
      <strong>خلاصة حكم المحدث: <span>صحيح</span></strong>
    </div>
  </div>
</body>
</html>
''';

/// Mock usul hadith response (with Arabic content)
const mockUsulHadithResponse = '''
<html>
<body>
  <div class="border-bottom">
    <div>إنما الأعمال بالنيات</div>
    <div>
  <strong>الراوي: <span>عمر بن الخطاب</span></strong>
  <strong>المحدث: <span><a view-card="mhd" card-link="256">البخاري</a></span></strong>
      <strong>المصدر: <span>صحيح البخاري</span></strong>
      <strong>الصفحة أو الرقم: <span>1</span></strong>
      <strong>خلاصة حكم المحدث: <span>صحيح</span></strong>
    </div>
  </div>
  <article>
    <h5>Main hadith (this article is skipped by the parser)</h5>
  </article>
  <article>
    <h5>
      <span style="color:maroon">المصدر الأول</span>
      <span style="color:blue">السلسلة الأولى</span>
      نص الحديث الأول
    </h5>
  </article>
  <article>
    <h5>
      <span style="color:maroon">المصدر الثاني</span>
      <span style="color:blue">السلسلة الثانية</span>
      نص الحديث الثاني
    </h5>
  </article>
</body>
</html>
''';

/// Class containing all mock responses
class MockResponses {
  // Data endpoint responses (ASCII-only for URL compatibility in tests)
  static const booksData =
      '[{"id":"6216","name":"Sahih Bukhari"},{"id":"3088","name":"Sahih Muslim"},{"id":"3239","name":"Jami Al-Tirmidhi"}]';

  static const degreesData =
      '[{"id":"0","name":"All Degrees"},{"id":"1","name":"Sahih"},{"id":"2","name":"Hasan"},{"id":"3","name":"Daif"},{"id":"4","name":"Mawdu"}]';

  static const methodSearchData =
      '[{"id":"0","name":"Normal Search"},{"id":"1","name":"Exact Search"},{"id":"2","name":"Text Search"}]';

  static const mohdithData =
      '[{"id":"256","name":"Al-Bukhari"},{"id":"261","name":"Muslim"},{"id":"279","name":"Al-Tirmidhi"}]';

  static const rawiData =
      '[{"id":"1","name":"Umar ibn Al-Khattab"},{"id":"2","name":"Abu Hurayrah"},{"id":"3","name":"Aisha"}]';

  static const zoneSearchData =
      '[{"id":"0","name":"All Zones"},{"id":"1","name":"Matn"},{"id":"2","name":"Rawi"},{"id":"3","name":"Mohdith"},{"id":"4","name":"Source"}]';
}
