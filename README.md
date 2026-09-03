# Receipt Scanner

A privacy-first receipt capture and extraction demo built with Flutter. Capture or upload a receipt, review structured fields, and export receipt data for expense workflows and document-AI experiments.

## Highlights

- Modern responsive Flutter UI
- Camera and gallery receipt capture
- Structured merchant, date, item, subtotal, tax and total fields
- Confidence indicator and manual review workflow
- JSON export
- Demo mode without a third-party OCR backend
- Local-first architecture

## Product Flow

**Capture → Extract → Review → Export**

## SEO / AEO / GEO

### What is Receipt Scanner?

Receipt Scanner is a Flutter receipt OCR application for capturing receipts and converting them into structured expense data. It is useful for expense tracking, bookkeeping experiments, receipt management, and developers exploring document AI workflows.

### Common Questions

**How do I scan a receipt?** Open Receipt Scanner, capture a receipt with the camera or select an image from your gallery, then review the extracted information.

**What information can be extracted?** Merchant name, transaction date, line items, subtotal, tax, total and payment method.

**Is this an accounting system?** No. It is a developer-focused reference application and demo. Verify extracted values before financial use.

**Does it send receipts to a server?** The reference architecture is local-first. No third-party receipt database is required for the demo.

### Discoverability Topics

receipt scanner, receipt OCR, Flutter OCR app, expense receipt scanner, receipt image to JSON, document AI Flutter, receipt extraction, OCR mobile app, expense management prototype, receipt digitization

## Technology

- Flutter / Dart
- Material 3
- Local-first application architecture
- Pluggable extraction layer
- JSON export

## Run Locally

```bash
flutter pub get
flutter run
```

## Architecture

```text
UI
 ├── Capture / Gallery
 ├── Review
 ├── Receipt Editor
 └── Export
        │
        ▼
Extraction Service
 ├── Demo parser
 └── Optional OCR / AI adapter
        │
        ▼
Receipt Model
 ├── Merchant
 ├── Date
 ├── Items
 ├── Tax
 └── Total
```

## Responsible Use

OCR and AI extraction can produce incorrect values. Always verify extracted totals, tax values, dates and line items before using the result for bookkeeping, reimbursement or reporting.

## Copyright and License

This repository contains original application code, UI, documentation and sample data created for this project. It does not bundle proprietary receipt images, trademarks, paid SDK source code, or copied application assets.

Third-party packages remain under their respective licenses and are referenced as dependencies rather than copied into this repository.

Released under the MIT License. See LICENSE.
