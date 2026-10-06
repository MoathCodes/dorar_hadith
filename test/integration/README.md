# Offline source contract tests

These tests use saved Dorar responses and mocked transports. Normal `dart test` runs do not contact Dorar. The capture manifest records each response URL, timestamp, metadata and hashes.

## Contents

- [Run the tests](#section-1)
- [Coverage](#section-2)
- [Refresh source captures](#section-3)

<a id="section-1"></a>

## Run the tests

```sh
fvm dart test test/integration
fvm dart test test/integration --reporter=expanded
```

<a id="section-2"></a>

## Coverage

- `fixture_integrity_test.dart` checks capture hashes and request targets.
- `upstream_contract_test.dart` checks parsing across multiple direct-source records.
- `source_contract_regression_test.dart` checks source text, structured ranges and independent citations.
- `search_matrix_contract_test.dart` checks filters, source scopes and pagination.
- `discovery_contract_test.dart` checks categories and reference choices.
- `snapshot_test.dart` checks saved response compatibility.

Expected source behavior is recorded separately in `../fixtures/upstream_expectations.json`. Malformed and error responses are synthetic test cases, not upstream observations.

<a id="section-3"></a>

## Refresh source captures

Capture is an explicit development action:

```sh
fvm dart run tool/capture_upstream_contracts.dart
```

Run this command from the package root. It skips existing captures by default. Inspect its selected/forced capture options before requesting replacements; prior responses are archived by hash. Review changed payloads and semantic expectations together before committing them. See the [upstream audit](../../docs/DORAR_UPSTREAM_AUDIT_2026-10-06.md) for the sampling method and known coverage limits.
