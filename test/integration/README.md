# Integration Tests - Real Dorar.net API

This directory contains integration tests that make **real HTTP requests** to the Dorar.net API.

## ⚠️ Important Notes

- **These tests hit the REAL Dorar.net servers**
- They may be **slow** (depends on network speed and API response time)
- They may **fail** if Dorar.net is down, slow, or rate-limiting
- They use **real Arabic data** from live hadiths
- Run **sparingly** to avoid overloading the API

## Running the Tests

### Run ALL integration tests
```bash
dart test test/integration/dorar_api_integration_test.dart
```

### Run specific test groups
```bash
# Only hadith search tests
dart test test/integration/dorar_api_integration_test.dart --tags=hadith

# Only sharh tests
dart test test/integration/dorar_api_integration_test.dart --tags=sharh

# Only data tests
dart test test/integration/dorar_api_integration_test.dart --tags=data

# Only Arabic encoding tests
dart test test/integration/dorar_api_integration_test.dart --tags=arabic
```

### Run with verbose output
```bash
dart test test/integration/dorar_api_integration_test.dart --reporter=expanded
```

### Skip integration tests in normal runs
```bash
# Run all tests EXCEPT integration
dart test --exclude-tags=integration
```

## Test Coverage

### ✅ Hadith Operations (15 tests)
- [x] Search via API endpoint (15 results)
- [x] Search via Site endpoint (30 results)
- [x] Get hadith by ID
- [x] Get similar hadiths
- [x] Get alternate sahih hadith
- [x] Get usul hadith with sources
- [x] Filter by degree (Sahih, Hasan, etc.)
- [x] Filter by scholar (Al-Bukhari, Muslim, etc.)
- [x] Pagination

### ✅ Sharh Operations (3 tests)
- [x] Search for sharh
- [x] Get sharh by ID
- [x] Get sharh by hadith text

### ✅ Reference Data (3 tests)
- [x] Get scholar (mohdith) information
- [x] Get book information
- [x] Get all reference data (degrees, books, scholars, narrators)

### ✅ Arabic Text Handling (3 tests)
- [x] Arabic diacritics
- [x] HTML entity decoding
- [x] Mixed Arabic/English content

### ✅ Error Handling (3 tests)
- [x] 404 Not Found
- [x] Timeout errors
- [x] Validation errors

### ✅ Performance (2 tests)
- [x] Response time
- [x] Concurrent requests

**Total: ~35 integration tests**

## What These Tests Verify

### 1. API Communication
- ✅ Correct endpoints are called
- ✅ Query parameters are properly serialized
- ✅ HTTP headers are correct
- ✅ Response parsing works

### 2. Arabic Text Handling
- ✅ HTML entities are decoded (`&#1575;` → `ا`)
- ✅ Arabic characters display correctly
- ✅ Diacritics are handled
- ✅ No encoding corruption

### 3. Data Completeness
- ✅ All required fields are present
- ✅ Metadata is extracted correctly
- ✅ Relationships (similar, alternate, usul) work
- ✅ Pagination works

### 4. Error Handling
- ✅ Network errors are caught
- ✅ Invalid input is rejected
- ✅ Timeouts are handled
- ✅ 404s throw proper exceptions

## Example Output

When tests pass, you'll see:
```
✅ Found 15 hadiths about الصلاة
   First hadith: إِنَّمَا الأَعْمَالُ بِالنِّيَّاتِ...
   Narrator: عمر بن الخطاب
   Scholar: البخاري
   Grade: صحيح

✅ Pagination works: Page 1 ≠ Page 2

✅ Sharh search: Found 12 results
   Hadith: إنما الأعمال بالنيات...
   Sharh: معنى هذا الحديث أن الأعمال...

✅ No HTML entities found in 15 hadiths

✅ Search completed in 843ms
```

## Troubleshooting

### Tests are failing
1. **Check your internet connection**
2. **Verify Dorar.net is up** - Visit https://dorar.net
3. **Wait and retry** - API might be temporarily slow
4. **Check for rate limiting** - You may have made too many requests

### Tests are slow
- This is normal! Network requests take time
- Typical test run: **2-5 minutes** for all integration tests
- Individual tests: **500ms - 3 seconds** each

### "Connection refused" errors
- Your firewall may be blocking the connection
- Dorar.net may be down
- Try again later

### Arabic text looks corrupted
- Your terminal may not support Arabic
- The tests verify proper encoding programmatically
- Check the test assertions, not the console output

## CI/CD Integration

### GitHub Actions Example
```yaml
name: Integration Tests

on:
  schedule:
    - cron: '0 0 * * 0'  # Weekly on Sunday
  workflow_dispatch:      # Manual trigger

jobs:
  integration:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: dart-lang/setup-dart@v1
      - run: dart pub get
      - run: dart test test/integration/ --reporter=expanded
```

### Don't run in every PR
Integration tests should be run:
- ✅ Weekly (scheduled)
- ✅ Before releases
- ✅ Manually when needed
- ❌ Not in every PR/commit (too slow, hits live API)

## Adding New Tests

When adding new integration tests:

1. **Add to this file** - `dorar_api_integration_test.dart`
2. **Tag appropriately** - Use relevant tags
3. **Add print statements** - For debugging
4. **Handle failures gracefully** - Use `orElse` for optional features
5. **Document what you're testing** - Clear test names and comments

Example:
```dart
test('should handle new feature', () async {
  final result = await client.newFeature('test');
  
  expect(result, isNotEmpty);
  print('✅ New feature works!');
}, tags: ['integration', 'new-feature']);
```

## Available Tags

- `integration` - All integration tests
- `hadith` - Hadith-related tests
- `sharh` - Sharh/explanation tests
- `mohdith` - Scholar tests
- `book` - Book tests
- `data` - Reference data tests
- `search` - Search functionality
- `filter` - Filtering tests
- `related` - Related hadith tests
- `arabic` - Arabic text handling
- `encoding` - Character encoding
- `errors` - Error handling
- `performance` - Performance tests

## Maintenance

These tests should be reviewed:
- **After major API changes** to Dorar.net
- **Before each release** of the package
- **When Arabic encoding issues are reported**
- **If Dorar.net changes their HTML structure**

---

**Last Updated:** November 2024  
**Test Count:** 35 integration tests  
**Average Runtime:** 2-5 minutes (depends on network)
