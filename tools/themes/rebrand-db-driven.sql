SET NOCOUNT ON;
SET XACT_ABORT ON;
BEGIN TRANSACTION;

-- ================================================================
-- DB-DRIVEN REBRANDING — No view compilation needed
-- Works by injecting CSS into HeaderCustomHtml and updating logos
-- ================================================================

-- 1. Store 1: Arty Electra — Amber solar accent CSS injection
UPDATE Setting SET Value = N'
<style>
/* Arty Electra Brand Overrides */
.arty-electra-header { border-bottom: 2px solid #F5A623 !important; }
.header-logo a { display:flex; align-items:center; text-decoration:none; }
.header-logo img { height:40px; margin-right:12px; border-radius:4px; }
.arty-electra-brand { font-family:Inter,sans-serif; font-size:22px; font-weight:700; color:#000; letter-spacing:-0.5px; }
.arty-electra-hero { background:linear-gradient(135deg,#fff 0%,#FFF5E0 100%); padding:64px 0; text-align:center; }
.arty-electra-hero h1 { font-family:Inter,sans-serif; font-size:48px; font-weight:700; color:#000; margin-bottom:16px; }
.arty-electra-hero .lead { font-family:Inter,sans-serif; font-size:18px; color:#4d4d4d; max-width:600px; margin:0 auto 32px; }
.arty-electra-hero .cta { display:inline-block; background:#000; color:#fff; padding:14px 32px; border-radius:4px; font-family:Inter,sans-serif; font-weight:600; font-size:16px; text-decoration:none; }
.arty-electra-hero .cta:hover { background:#D4860B; }
.product-box .prices .actual-price { color:#D4860B !important; font-weight:700; }
.master-wrapper-page { background: #fff; }
footer { background: #000 !important; color: #fff !important; }
footer a { color: #ebebeb !important; }
footer a:hover { color: #F5A623 !important; }
.btn-primary { background: #000 !important; border-color: #000 !important; }
.btn-primary:hover { background: #D4860B !important; border-color: #D4860B !important; }
</style>
' + ISNULL((SELECT Value FROM Setting WHERE Name='commonsettings.headercustomhtml' AND StoreId=0),'')
WHERE Name='commonsettings.headercustomhtml' AND StoreId=0;

IF @@ROWCOUNT = 0
INSERT INTO Setting (Name, Value, StoreId) VALUES ('commonsettings.headercustomhtml', N'
<style>
.arty-electra-header { border-bottom: 2px solid #F5A623 !important; }
.product-box .prices .actual-price { color:#D4860B !important; font-weight:700; }
footer { background: #000 !important; color: #fff !important; }
footer a { color: #ebebeb !important; }
footer a:hover { color: #F5A623 !important; }
.btn-primary { background: #000 !important; border-color: #000 !important; }
.btn-primary:hover { background: #D4860B !important; border-color: #D4860B !important; }
</style>
', 0);

-- 2. Store 2: Victoria Falls — Warm African market CSS injection
-- First, clear any existing Store 2 header HTML
DELETE FROM Setting WHERE Name='commonsettings.headercustomhtml' AND StoreId=2;
INSERT INTO Setting (Name, Value, StoreId) VALUES ('commonsettings.headercustomhtml', N'
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&amp;family=Playfair+Display:wght@400;500;600;700&amp;display=swap" rel="stylesheet">
<style>
/* Victoria Falls Artisan Market Brand Overrides */
body { font-family: Inter, sans-serif !important; color: #2D2A26 !important; background: #FDFCFA !important; }
.header { background: #F5F0E8 !important; border-bottom: 3px solid #C65D3B !important; }
.header-logo a { text-decoration: none; }
.header-logo span:first-of-type { font-family:"Playfair Display",Georgia,serif !important; font-size:24px; font-weight:600; color:#C65D3B; letter-spacing:-0.5px; }
.header-logo span:last-of-type { display:block; font-family:Inter,sans-serif; font-size:11px; font-weight:400; color:#5B7C3F; text-transform:uppercase; letter-spacing:2px; }
.header-menu { background: #F5F0E8 !important; }
.header-menu a { font-family:Inter,sans-serif; font-size:14px; font-weight:500; color:#4A4540 !important; }
.header-menu a:hover { color:#C65D3B !important; }
.product-box .product-title { font-family:"Playfair Display",Georgia,serif !important; font-size:18px; font-weight:600; color:#2D2A26; }
.product-box .prices .actual-price { color:#A04020 !important; font-weight:700; }
.footer { background: #2D2A26 !important; color: #F5F0E8 !important; }
.footer a { color: #9A9590 !important; }
.footer a:hover { color: #C65D3B !important; }
.footer .title { font-family:"Playfair Display",Georgia,serif !important; color:#F5E6E0 !important; }
.btn-primary { background: #C65D3B !important; border-color: #C65D3B !important; color: #fff !important; }
.btn-primary:hover { background: #A04020 !important; border-color: #A04020 !important; }
.master-wrapper-page { background: #FDFCFA !important; }
.category-item .category-name { font-family:"Playfair Display",Georgia,serif !important; }
.category-item:hover .category-name { color:#C65D3B !important; }
</style>
', 2);

-- 3. Update store-specific footer HTML
DELETE FROM Setting WHERE Name='commonsettings.footercustomhtml' AND StoreId=2;
INSERT INTO Setting (Name, Value, StoreId) VALUES ('commonsettings.footercustomhtml', N'
<div style="background:#2D2A26;color:#9A9590;text-align:center;padding:16px;font-family:Inter,sans-serif;font-size:13px;">
  &copy; 2025 Victoria Falls Artisan Market. Crafted with care in Zimbabwe &amp; Zambia.
</div>
', 2);

-- 4. Update homepage title/description per store
UPDATE Store SET HomepageTitle = 'Arty Electra — Solar Power for Africa', HomepageDescription = 'Clean, reliable solar energy solutions. From panels to batteries, we light the way forward.' WHERE Id = 1;
UPDATE Store SET HomepageTitle = 'Victoria Falls Artisan Market', HomepageDescription = 'Hand-crafted goods from the heart of Southern Africa. Every piece tells a story of tradition, skill, and community.' WHERE Id = 2;

COMMIT TRANSACTION;
PRINT 'DB-DRIVEN REBRANDING COMPLETE';
