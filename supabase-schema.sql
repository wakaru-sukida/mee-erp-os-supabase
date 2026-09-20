-- Mee-ERP OS — Supabase schema (ชุดสำรอง: สร้างจาก seed rows ในโค้ดโมดูล)
-- ⚠️ แนะนำให้ใช้ปุ่ม "สร้างสคริปต์จากชีตจริง" ในหน้า Database Setup แทน
--
-- คอลัมน์ระบบขึ้นต้นด้วย _ (ไม่ชนฟิลด์ข้อมูลจริงอย่าง id / tenant_id ในชีต)
--   _pk · _tenant · _seq (ลำดับแถว) · _extra (คีย์ที่ยังไม่มีคอลัมน์) · _created_at · _updated_at
--
-- รันซ้ำได้ และรองรับฐานข้อมูลที่เคยรันสคริปต์เวอร์ชันเก่า (คอลัมน์ระบบชื่อ id/tenant_id/seq/extra):
-- แต่ละตารางมีชุด alter แบบ idempotent ที่เพิ่มคอลัมน์ใหม่และถอดคอลัมน์ระบบชุดเก่าออกให้

create extension if not exists "pgcrypto";

create table if not exists tenant (
  id          uuid primary key default gen_random_uuid(),
  code        text unique not null,
  name_th     text not null,
  is_active   boolean not null default true,
  created_at  timestamptz not null default now()
);
insert into tenant (code, name_th) values ('default','องค์กรเริ่มต้น') on conflict (code) do nothing;

-- ============ INVT-ITEM ============
create table if not exists "invt_item_class" (
  _pk         bigint generated always as identity primary key,
  _tenant     uuid references tenant(id) on delete cascade,
  _seq        integer not null default 0,
  "no" text,
  "cid" text,
  "en" text,
  "a" text,
  "co" text,
  "br" text,
  "sort" numeric,
  "s" text,
  "remark" text,
  "IsActive" text,
  "createdAt" text,
  "createdBy" text,
  "updatedAt" text,
  "updatedBy" text,
  _extra      jsonb not null default '{}'::jsonb,
  _created_at timestamptz not null default now(),
  _updated_at timestamptz not null default now()
);
alter table "invt_item_class" drop column if exists "id";
alter table "invt_item_class" drop column if exists "tenant_id";
alter table "invt_item_class" drop column if exists "seq";
alter table "invt_item_class" drop column if exists "extra";
alter table "invt_item_class" drop column if exists "created_at";
alter table "invt_item_class" drop column if exists "updated_at";
alter table "invt_item_class" add column if not exists _pk bigint generated always as identity;
alter table "invt_item_class" add column if not exists _tenant uuid references tenant(id) on delete cascade;
alter table "invt_item_class" add column if not exists _seq integer not null default 0;
alter table "invt_item_class" add column if not exists _extra jsonb not null default '{}'::jsonb;
alter table "invt_item_class" add column if not exists _created_at timestamptz not null default now();
alter table "invt_item_class" add column if not exists _updated_at timestamptz not null default now();
alter table "invt_item_class" add column if not exists "no" text;
alter table "invt_item_class" add column if not exists "cid" text;
alter table "invt_item_class" add column if not exists "en" text;
alter table "invt_item_class" add column if not exists "a" text;
alter table "invt_item_class" add column if not exists "co" text;
alter table "invt_item_class" add column if not exists "br" text;
alter table "invt_item_class" add column if not exists "sort" numeric;
alter table "invt_item_class" add column if not exists "s" text;
alter table "invt_item_class" add column if not exists "remark" text;
alter table "invt_item_class" add column if not exists "IsActive" text;
alter table "invt_item_class" add column if not exists "createdAt" text;
alter table "invt_item_class" add column if not exists "createdBy" text;
alter table "invt_item_class" add column if not exists "updatedAt" text;
alter table "invt_item_class" add column if not exists "updatedBy" text;
create index if not exists "invt_item_class_tenant_seq_idx" on "invt_item_class" (_tenant, _seq);
create table if not exists "invt_item_type" (
  _pk         bigint generated always as identity primary key,
  _tenant     uuid references tenant(id) on delete cascade,
  _seq        integer not null default 0,
  "no" text,
  "sort" numeric,
  _extra      jsonb not null default '{}'::jsonb,
  _created_at timestamptz not null default now(),
  _updated_at timestamptz not null default now()
);
alter table "invt_item_type" drop column if exists "id";
alter table "invt_item_type" drop column if exists "tenant_id";
alter table "invt_item_type" drop column if exists "seq";
alter table "invt_item_type" drop column if exists "extra";
alter table "invt_item_type" drop column if exists "created_at";
alter table "invt_item_type" drop column if exists "updated_at";
alter table "invt_item_type" add column if not exists _pk bigint generated always as identity;
alter table "invt_item_type" add column if not exists _tenant uuid references tenant(id) on delete cascade;
alter table "invt_item_type" add column if not exists _seq integer not null default 0;
alter table "invt_item_type" add column if not exists _extra jsonb not null default '{}'::jsonb;
alter table "invt_item_type" add column if not exists _created_at timestamptz not null default now();
alter table "invt_item_type" add column if not exists _updated_at timestamptz not null default now();
alter table "invt_item_type" add column if not exists "no" text;
alter table "invt_item_type" add column if not exists "sort" numeric;
create index if not exists "invt_item_type_tenant_seq_idx" on "invt_item_type" (_tenant, _seq);
create table if not exists "invt_item_category" (
  _pk         bigint generated always as identity primary key,
  _tenant     uuid references tenant(id) on delete cascade,
  _seq        integer not null default 0,
  "no" text,
  "catid" text,
  "a" text,
  "en" text,
  "co" text,
  "br" text,
  "tid" text,
  "itype" text,
  "grp" text,
  "sort" numeric,
  "remark" text,
  "s" text,
  _extra      jsonb not null default '{}'::jsonb,
  _created_at timestamptz not null default now(),
  _updated_at timestamptz not null default now()
);
alter table "invt_item_category" drop column if exists "id";
alter table "invt_item_category" drop column if exists "tenant_id";
alter table "invt_item_category" drop column if exists "seq";
alter table "invt_item_category" drop column if exists "extra";
alter table "invt_item_category" drop column if exists "created_at";
alter table "invt_item_category" drop column if exists "updated_at";
alter table "invt_item_category" add column if not exists _pk bigint generated always as identity;
alter table "invt_item_category" add column if not exists _tenant uuid references tenant(id) on delete cascade;
alter table "invt_item_category" add column if not exists _seq integer not null default 0;
alter table "invt_item_category" add column if not exists _extra jsonb not null default '{}'::jsonb;
alter table "invt_item_category" add column if not exists _created_at timestamptz not null default now();
alter table "invt_item_category" add column if not exists _updated_at timestamptz not null default now();
alter table "invt_item_category" add column if not exists "no" text;
alter table "invt_item_category" add column if not exists "catid" text;
alter table "invt_item_category" add column if not exists "a" text;
alter table "invt_item_category" add column if not exists "en" text;
alter table "invt_item_category" add column if not exists "co" text;
alter table "invt_item_category" add column if not exists "br" text;
alter table "invt_item_category" add column if not exists "tid" text;
alter table "invt_item_category" add column if not exists "itype" text;
alter table "invt_item_category" add column if not exists "grp" text;
alter table "invt_item_category" add column if not exists "sort" numeric;
alter table "invt_item_category" add column if not exists "remark" text;
alter table "invt_item_category" add column if not exists "s" text;
create index if not exists "invt_item_category_tenant_seq_idx" on "invt_item_category" (_tenant, _seq);
create table if not exists "invt_item_grade" (
  _pk         bigint generated always as identity primary key,
  _tenant     uuid references tenant(id) on delete cascade,
  _seq        integer not null default 0,
  "no" text,
  "gdid" text,
  "a" text,
  "en" text,
  "co" text,
  "br" text,
  "tid" text,
  "sort" numeric,
  "remark" text,
  "s" text,
  _extra      jsonb not null default '{}'::jsonb,
  _created_at timestamptz not null default now(),
  _updated_at timestamptz not null default now()
);
alter table "invt_item_grade" drop column if exists "id";
alter table "invt_item_grade" drop column if exists "tenant_id";
alter table "invt_item_grade" drop column if exists "seq";
alter table "invt_item_grade" drop column if exists "extra";
alter table "invt_item_grade" drop column if exists "created_at";
alter table "invt_item_grade" drop column if exists "updated_at";
alter table "invt_item_grade" add column if not exists _pk bigint generated always as identity;
alter table "invt_item_grade" add column if not exists _tenant uuid references tenant(id) on delete cascade;
alter table "invt_item_grade" add column if not exists _seq integer not null default 0;
alter table "invt_item_grade" add column if not exists _extra jsonb not null default '{}'::jsonb;
alter table "invt_item_grade" add column if not exists _created_at timestamptz not null default now();
alter table "invt_item_grade" add column if not exists _updated_at timestamptz not null default now();
alter table "invt_item_grade" add column if not exists "no" text;
alter table "invt_item_grade" add column if not exists "gdid" text;
alter table "invt_item_grade" add column if not exists "a" text;
alter table "invt_item_grade" add column if not exists "en" text;
alter table "invt_item_grade" add column if not exists "co" text;
alter table "invt_item_grade" add column if not exists "br" text;
alter table "invt_item_grade" add column if not exists "tid" text;
alter table "invt_item_grade" add column if not exists "sort" numeric;
alter table "invt_item_grade" add column if not exists "remark" text;
alter table "invt_item_grade" add column if not exists "s" text;
create index if not exists "invt_item_grade_tenant_seq_idx" on "invt_item_grade" (_tenant, _seq);
create table if not exists "invt_item_brand" (
  _pk         bigint generated always as identity primary key,
  _tenant     uuid references tenant(id) on delete cascade,
  _seq        integer not null default 0,
  "no" text,
  "bnid" text,
  "a" text,
  "en" text,
  "co" text,
  "br" text,
  "tid" text,
  "sort" numeric,
  "remark" text,
  "s" text,
  _extra      jsonb not null default '{}'::jsonb,
  _created_at timestamptz not null default now(),
  _updated_at timestamptz not null default now()
);
alter table "invt_item_brand" drop column if exists "id";
alter table "invt_item_brand" drop column if exists "tenant_id";
alter table "invt_item_brand" drop column if exists "seq";
alter table "invt_item_brand" drop column if exists "extra";
alter table "invt_item_brand" drop column if exists "created_at";
alter table "invt_item_brand" drop column if exists "updated_at";
alter table "invt_item_brand" add column if not exists _pk bigint generated always as identity;
alter table "invt_item_brand" add column if not exists _tenant uuid references tenant(id) on delete cascade;
alter table "invt_item_brand" add column if not exists _seq integer not null default 0;
alter table "invt_item_brand" add column if not exists _extra jsonb not null default '{}'::jsonb;
alter table "invt_item_brand" add column if not exists _created_at timestamptz not null default now();
alter table "invt_item_brand" add column if not exists _updated_at timestamptz not null default now();
alter table "invt_item_brand" add column if not exists "no" text;
alter table "invt_item_brand" add column if not exists "bnid" text;
alter table "invt_item_brand" add column if not exists "a" text;
alter table "invt_item_brand" add column if not exists "en" text;
alter table "invt_item_brand" add column if not exists "co" text;
alter table "invt_item_brand" add column if not exists "br" text;
alter table "invt_item_brand" add column if not exists "tid" text;
alter table "invt_item_brand" add column if not exists "sort" numeric;
alter table "invt_item_brand" add column if not exists "remark" text;
alter table "invt_item_brand" add column if not exists "s" text;
create index if not exists "invt_item_brand_tenant_seq_idx" on "invt_item_brand" (_tenant, _seq);
create table if not exists "invt_uom" (
  _pk         bigint generated always as identity primary key,
  _tenant     uuid references tenant(id) on delete cascade,
  _seq        integer not null default 0,
  "no" text,
  "dec" text,
  "sort" numeric,
  _extra      jsonb not null default '{}'::jsonb,
  _created_at timestamptz not null default now(),
  _updated_at timestamptz not null default now()
);
alter table "invt_uom" drop column if exists "id";
alter table "invt_uom" drop column if exists "tenant_id";
alter table "invt_uom" drop column if exists "seq";
alter table "invt_uom" drop column if exists "extra";
alter table "invt_uom" drop column if exists "created_at";
alter table "invt_uom" drop column if exists "updated_at";
alter table "invt_uom" add column if not exists _pk bigint generated always as identity;
alter table "invt_uom" add column if not exists _tenant uuid references tenant(id) on delete cascade;
alter table "invt_uom" add column if not exists _seq integer not null default 0;
alter table "invt_uom" add column if not exists _extra jsonb not null default '{}'::jsonb;
alter table "invt_uom" add column if not exists _created_at timestamptz not null default now();
alter table "invt_uom" add column if not exists _updated_at timestamptz not null default now();
alter table "invt_uom" add column if not exists "no" text;
alter table "invt_uom" add column if not exists "dec" text;
alter table "invt_uom" add column if not exists "sort" numeric;
create index if not exists "invt_uom_tenant_seq_idx" on "invt_uom" (_tenant, _seq);
create table if not exists "invt_uom_group" (
  _pk         bigint generated always as identity primary key,
  _tenant     uuid references tenant(id) on delete cascade,
  _seq        integer not null default 0,
  "sort" numeric,
  "no" text,
  _extra      jsonb not null default '{}'::jsonb,
  _created_at timestamptz not null default now(),
  _updated_at timestamptz not null default now()
);
alter table "invt_uom_group" drop column if exists "id";
alter table "invt_uom_group" drop column if exists "tenant_id";
alter table "invt_uom_group" drop column if exists "seq";
alter table "invt_uom_group" drop column if exists "extra";
alter table "invt_uom_group" drop column if exists "created_at";
alter table "invt_uom_group" drop column if exists "updated_at";
alter table "invt_uom_group" add column if not exists _pk bigint generated always as identity;
alter table "invt_uom_group" add column if not exists _tenant uuid references tenant(id) on delete cascade;
alter table "invt_uom_group" add column if not exists _seq integer not null default 0;
alter table "invt_uom_group" add column if not exists _extra jsonb not null default '{}'::jsonb;
alter table "invt_uom_group" add column if not exists _created_at timestamptz not null default now();
alter table "invt_uom_group" add column if not exists _updated_at timestamptz not null default now();
alter table "invt_uom_group" add column if not exists "sort" numeric;
alter table "invt_uom_group" add column if not exists "no" text;
create index if not exists "invt_uom_group_tenant_seq_idx" on "invt_uom_group" (_tenant, _seq);
create table if not exists "invt_uom_group_conversion" (
  _pk         bigint generated always as identity primary key,
  _tenant     uuid references tenant(id) on delete cascade,
  _seq        integer not null default 0,
  _extra      jsonb not null default '{}'::jsonb,
  _created_at timestamptz not null default now(),
  _updated_at timestamptz not null default now()
);
alter table "invt_uom_group_conversion" drop column if exists "id";
alter table "invt_uom_group_conversion" drop column if exists "tenant_id";
alter table "invt_uom_group_conversion" drop column if exists "seq";
alter table "invt_uom_group_conversion" drop column if exists "extra";
alter table "invt_uom_group_conversion" drop column if exists "created_at";
alter table "invt_uom_group_conversion" drop column if exists "updated_at";
alter table "invt_uom_group_conversion" add column if not exists _pk bigint generated always as identity;
alter table "invt_uom_group_conversion" add column if not exists _tenant uuid references tenant(id) on delete cascade;
alter table "invt_uom_group_conversion" add column if not exists _seq integer not null default 0;
alter table "invt_uom_group_conversion" add column if not exists _extra jsonb not null default '{}'::jsonb;
alter table "invt_uom_group_conversion" add column if not exists _created_at timestamptz not null default now();
alter table "invt_uom_group_conversion" add column if not exists _updated_at timestamptz not null default now();
create index if not exists "invt_uom_group_conversion_tenant_seq_idx" on "invt_uom_group_conversion" (_tenant, _seq);
create table if not exists "invt_item" (
  _pk         bigint generated always as identity primary key,
  _tenant     uuid references tenant(id) on delete cascade,
  _seq        integer not null default 0,
  "no" text,
  "typ" text,
  "cat" text,
  "brand" text,
  "uom" text,
  _extra      jsonb not null default '{}'::jsonb,
  _created_at timestamptz not null default now(),
  _updated_at timestamptz not null default now()
);
alter table "invt_item" drop column if exists "id";
alter table "invt_item" drop column if exists "tenant_id";
alter table "invt_item" drop column if exists "seq";
alter table "invt_item" drop column if exists "extra";
alter table "invt_item" drop column if exists "created_at";
alter table "invt_item" drop column if exists "updated_at";
alter table "invt_item" add column if not exists _pk bigint generated always as identity;
alter table "invt_item" add column if not exists _tenant uuid references tenant(id) on delete cascade;
alter table "invt_item" add column if not exists _seq integer not null default 0;
alter table "invt_item" add column if not exists _extra jsonb not null default '{}'::jsonb;
alter table "invt_item" add column if not exists _created_at timestamptz not null default now();
alter table "invt_item" add column if not exists _updated_at timestamptz not null default now();
alter table "invt_item" add column if not exists "no" text;
alter table "invt_item" add column if not exists "typ" text;
alter table "invt_item" add column if not exists "cat" text;
alter table "invt_item" add column if not exists "brand" text;
alter table "invt_item" add column if not exists "uom" text;
create index if not exists "invt_item_tenant_seq_idx" on "invt_item" (_tenant, _seq);
create table if not exists "invt_item_group" (
  _pk         bigint generated always as identity primary key,
  _tenant     uuid references tenant(id) on delete cascade,
  _seq        integer not null default 0,
  "no" text,
  "bt" text,
  "br" text,
  _extra      jsonb not null default '{}'::jsonb,
  _created_at timestamptz not null default now(),
  _updated_at timestamptz not null default now()
);
alter table "invt_item_group" drop column if exists "id";
alter table "invt_item_group" drop column if exists "tenant_id";
alter table "invt_item_group" drop column if exists "seq";
alter table "invt_item_group" drop column if exists "extra";
alter table "invt_item_group" drop column if exists "created_at";
alter table "invt_item_group" drop column if exists "updated_at";
alter table "invt_item_group" add column if not exists _pk bigint generated always as identity;
alter table "invt_item_group" add column if not exists _tenant uuid references tenant(id) on delete cascade;
alter table "invt_item_group" add column if not exists _seq integer not null default 0;
alter table "invt_item_group" add column if not exists _extra jsonb not null default '{}'::jsonb;
alter table "invt_item_group" add column if not exists _created_at timestamptz not null default now();
alter table "invt_item_group" add column if not exists _updated_at timestamptz not null default now();
alter table "invt_item_group" add column if not exists "no" text;
alter table "invt_item_group" add column if not exists "bt" text;
alter table "invt_item_group" add column if not exists "br" text;
create index if not exists "invt_item_group_tenant_seq_idx" on "invt_item_group" (_tenant, _seq);

-- ============ ITSA-AUDT ============
create table if not exists "itsa_audt_user_activity_log" (
  _pk         bigint generated always as identity primary key,
  _tenant     uuid references tenant(id) on delete cascade,
  _seq        integer not null default 0,
  "no" text,
  "ts" text,
  "user" text,
  "dept" text,
  "action" text,
  "module" text,
  "target" text,
  "detail" text,
  _extra      jsonb not null default '{}'::jsonb,
  _created_at timestamptz not null default now(),
  _updated_at timestamptz not null default now()
);
alter table "itsa_audt_user_activity_log" drop column if exists "id";
alter table "itsa_audt_user_activity_log" drop column if exists "tenant_id";
alter table "itsa_audt_user_activity_log" drop column if exists "seq";
alter table "itsa_audt_user_activity_log" drop column if exists "extra";
alter table "itsa_audt_user_activity_log" drop column if exists "created_at";
alter table "itsa_audt_user_activity_log" drop column if exists "updated_at";
alter table "itsa_audt_user_activity_log" add column if not exists _pk bigint generated always as identity;
alter table "itsa_audt_user_activity_log" add column if not exists _tenant uuid references tenant(id) on delete cascade;
alter table "itsa_audt_user_activity_log" add column if not exists _seq integer not null default 0;
alter table "itsa_audt_user_activity_log" add column if not exists _extra jsonb not null default '{}'::jsonb;
alter table "itsa_audt_user_activity_log" add column if not exists _created_at timestamptz not null default now();
alter table "itsa_audt_user_activity_log" add column if not exists _updated_at timestamptz not null default now();
alter table "itsa_audt_user_activity_log" add column if not exists "no" text;
alter table "itsa_audt_user_activity_log" add column if not exists "ts" text;
alter table "itsa_audt_user_activity_log" add column if not exists "user" text;
alter table "itsa_audt_user_activity_log" add column if not exists "dept" text;
alter table "itsa_audt_user_activity_log" add column if not exists "action" text;
alter table "itsa_audt_user_activity_log" add column if not exists "module" text;
alter table "itsa_audt_user_activity_log" add column if not exists "target" text;
alter table "itsa_audt_user_activity_log" add column if not exists "detail" text;
create index if not exists "itsa_audt_user_activity_log_tenant_seq_idx" on "itsa_audt_user_activity_log" (_tenant, _seq);
create table if not exists "itsa_audt_login_log" (
  _pk         bigint generated always as identity primary key,
  _tenant     uuid references tenant(id) on delete cascade,
  _seq        integer not null default 0,
  "ts" text,
  "a" text,
  "s" text,
  _extra      jsonb not null default '{}'::jsonb,
  _created_at timestamptz not null default now(),
  _updated_at timestamptz not null default now()
);
alter table "itsa_audt_login_log" drop column if exists "id";
alter table "itsa_audt_login_log" drop column if exists "tenant_id";
alter table "itsa_audt_login_log" drop column if exists "seq";
alter table "itsa_audt_login_log" drop column if exists "extra";
alter table "itsa_audt_login_log" drop column if exists "created_at";
alter table "itsa_audt_login_log" drop column if exists "updated_at";
alter table "itsa_audt_login_log" add column if not exists _pk bigint generated always as identity;
alter table "itsa_audt_login_log" add column if not exists _tenant uuid references tenant(id) on delete cascade;
alter table "itsa_audt_login_log" add column if not exists _seq integer not null default 0;
alter table "itsa_audt_login_log" add column if not exists _extra jsonb not null default '{}'::jsonb;
alter table "itsa_audt_login_log" add column if not exists _created_at timestamptz not null default now();
alter table "itsa_audt_login_log" add column if not exists _updated_at timestamptz not null default now();
alter table "itsa_audt_login_log" add column if not exists "ts" text;
alter table "itsa_audt_login_log" add column if not exists "a" text;
alter table "itsa_audt_login_log" add column if not exists "s" text;
create index if not exists "itsa_audt_login_log_tenant_seq_idx" on "itsa_audt_login_log" (_tenant, _seq);
create table if not exists "itsa_audt_data_change_log" (
  _pk         bigint generated always as identity primary key,
  _tenant     uuid references tenant(id) on delete cascade,
  _seq        integer not null default 0,
  "ts" text,
  "a" text,
  "by" text,
  _extra      jsonb not null default '{}'::jsonb,
  _created_at timestamptz not null default now(),
  _updated_at timestamptz not null default now()
);
alter table "itsa_audt_data_change_log" drop column if exists "id";
alter table "itsa_audt_data_change_log" drop column if exists "tenant_id";
alter table "itsa_audt_data_change_log" drop column if exists "seq";
alter table "itsa_audt_data_change_log" drop column if exists "extra";
alter table "itsa_audt_data_change_log" drop column if exists "created_at";
alter table "itsa_audt_data_change_log" drop column if exists "updated_at";
alter table "itsa_audt_data_change_log" add column if not exists _pk bigint generated always as identity;
alter table "itsa_audt_data_change_log" add column if not exists _tenant uuid references tenant(id) on delete cascade;
alter table "itsa_audt_data_change_log" add column if not exists _seq integer not null default 0;
alter table "itsa_audt_data_change_log" add column if not exists _extra jsonb not null default '{}'::jsonb;
alter table "itsa_audt_data_change_log" add column if not exists _created_at timestamptz not null default now();
alter table "itsa_audt_data_change_log" add column if not exists _updated_at timestamptz not null default now();
alter table "itsa_audt_data_change_log" add column if not exists "ts" text;
alter table "itsa_audt_data_change_log" add column if not exists "a" text;
alter table "itsa_audt_data_change_log" add column if not exists "by" text;
create index if not exists "itsa_audt_data_change_log_tenant_seq_idx" on "itsa_audt_data_change_log" (_tenant, _seq);
create table if not exists "itsa_audt_permission_audit" (
  _pk         bigint generated always as identity primary key,
  _tenant     uuid references tenant(id) on delete cascade,
  _seq        integer not null default 0,
  "a" text,
  "d" text,
  "s" text,
  _extra      jsonb not null default '{}'::jsonb,
  _created_at timestamptz not null default now(),
  _updated_at timestamptz not null default now()
);
alter table "itsa_audt_permission_audit" drop column if exists "id";
alter table "itsa_audt_permission_audit" drop column if exists "tenant_id";
alter table "itsa_audt_permission_audit" drop column if exists "seq";
alter table "itsa_audt_permission_audit" drop column if exists "extra";
alter table "itsa_audt_permission_audit" drop column if exists "created_at";
alter table "itsa_audt_permission_audit" drop column if exists "updated_at";
alter table "itsa_audt_permission_audit" add column if not exists _pk bigint generated always as identity;
alter table "itsa_audt_permission_audit" add column if not exists _tenant uuid references tenant(id) on delete cascade;
alter table "itsa_audt_permission_audit" add column if not exists _seq integer not null default 0;
alter table "itsa_audt_permission_audit" add column if not exists _extra jsonb not null default '{}'::jsonb;
alter table "itsa_audt_permission_audit" add column if not exists _created_at timestamptz not null default now();
alter table "itsa_audt_permission_audit" add column if not exists _updated_at timestamptz not null default now();
alter table "itsa_audt_permission_audit" add column if not exists "a" text;
alter table "itsa_audt_permission_audit" add column if not exists "d" text;
alter table "itsa_audt_permission_audit" add column if not exists "s" text;
create index if not exists "itsa_audt_permission_audit_tenant_seq_idx" on "itsa_audt_permission_audit" (_tenant, _seq);
create table if not exists "itsa_audt_api_audit" (
  _pk         bigint generated always as identity primary key,
  _tenant     uuid references tenant(id) on delete cascade,
  _seq        integer not null default 0,
  "a" text,
  "cnt" text,
  "s" text,
  _extra      jsonb not null default '{}'::jsonb,
  _created_at timestamptz not null default now(),
  _updated_at timestamptz not null default now()
);
alter table "itsa_audt_api_audit" drop column if exists "id";
alter table "itsa_audt_api_audit" drop column if exists "tenant_id";
alter table "itsa_audt_api_audit" drop column if exists "seq";
alter table "itsa_audt_api_audit" drop column if exists "extra";
alter table "itsa_audt_api_audit" drop column if exists "created_at";
alter table "itsa_audt_api_audit" drop column if exists "updated_at";
alter table "itsa_audt_api_audit" add column if not exists _pk bigint generated always as identity;
alter table "itsa_audt_api_audit" add column if not exists _tenant uuid references tenant(id) on delete cascade;
alter table "itsa_audt_api_audit" add column if not exists _seq integer not null default 0;
alter table "itsa_audt_api_audit" add column if not exists _extra jsonb not null default '{}'::jsonb;
alter table "itsa_audt_api_audit" add column if not exists _created_at timestamptz not null default now();
alter table "itsa_audt_api_audit" add column if not exists _updated_at timestamptz not null default now();
alter table "itsa_audt_api_audit" add column if not exists "a" text;
alter table "itsa_audt_api_audit" add column if not exists "cnt" text;
alter table "itsa_audt_api_audit" add column if not exists "s" text;
create index if not exists "itsa_audt_api_audit_tenant_seq_idx" on "itsa_audt_api_audit" (_tenant, _seq);
create table if not exists "itsa_audt_audit_report" (
  _pk         bigint generated always as identity primary key,
  _tenant     uuid references tenant(id) on delete cascade,
  _seq        integer not null default 0,
  "a" text,
  "d" text,
  "ts" text,
  _extra      jsonb not null default '{}'::jsonb,
  _created_at timestamptz not null default now(),
  _updated_at timestamptz not null default now()
);
alter table "itsa_audt_audit_report" drop column if exists "id";
alter table "itsa_audt_audit_report" drop column if exists "tenant_id";
alter table "itsa_audt_audit_report" drop column if exists "seq";
alter table "itsa_audt_audit_report" drop column if exists "extra";
alter table "itsa_audt_audit_report" drop column if exists "created_at";
alter table "itsa_audt_audit_report" drop column if exists "updated_at";
alter table "itsa_audt_audit_report" add column if not exists _pk bigint generated always as identity;
alter table "itsa_audt_audit_report" add column if not exists _tenant uuid references tenant(id) on delete cascade;
alter table "itsa_audt_audit_report" add column if not exists _seq integer not null default 0;
alter table "itsa_audt_audit_report" add column if not exists _extra jsonb not null default '{}'::jsonb;
alter table "itsa_audt_audit_report" add column if not exists _created_at timestamptz not null default now();
alter table "itsa_audt_audit_report" add column if not exists _updated_at timestamptz not null default now();
alter table "itsa_audt_audit_report" add column if not exists "a" text;
alter table "itsa_audt_audit_report" add column if not exists "d" text;
alter table "itsa_audt_audit_report" add column if not exists "ts" text;
create index if not exists "itsa_audt_audit_report_tenant_seq_idx" on "itsa_audt_audit_report" (_tenant, _seq);

-- ============ ITSA-CONF ============
create table if not exists "itsa_conf_modules" (
  _pk         bigint generated always as identity primary key,
  _tenant     uuid references tenant(id) on delete cascade,
  _seq        integer not null default 0,
  _extra      jsonb not null default '{}'::jsonb,
  _created_at timestamptz not null default now(),
  _updated_at timestamptz not null default now()
);
alter table "itsa_conf_modules" drop column if exists "id";
alter table "itsa_conf_modules" drop column if exists "tenant_id";
alter table "itsa_conf_modules" drop column if exists "seq";
alter table "itsa_conf_modules" drop column if exists "extra";
alter table "itsa_conf_modules" drop column if exists "created_at";
alter table "itsa_conf_modules" drop column if exists "updated_at";
alter table "itsa_conf_modules" add column if not exists _pk bigint generated always as identity;
alter table "itsa_conf_modules" add column if not exists _tenant uuid references tenant(id) on delete cascade;
alter table "itsa_conf_modules" add column if not exists _seq integer not null default 0;
alter table "itsa_conf_modules" add column if not exists _extra jsonb not null default '{}'::jsonb;
alter table "itsa_conf_modules" add column if not exists _created_at timestamptz not null default now();
alter table "itsa_conf_modules" add column if not exists _updated_at timestamptz not null default now();
create index if not exists "itsa_conf_modules_tenant_seq_idx" on "itsa_conf_modules" (_tenant, _seq);
create table if not exists "itsa_conf_submodules" (
  _pk         bigint generated always as identity primary key,
  _tenant     uuid references tenant(id) on delete cascade,
  _seq        integer not null default 0,
  _extra      jsonb not null default '{}'::jsonb,
  _created_at timestamptz not null default now(),
  _updated_at timestamptz not null default now()
);
alter table "itsa_conf_submodules" drop column if exists "id";
alter table "itsa_conf_submodules" drop column if exists "tenant_id";
alter table "itsa_conf_submodules" drop column if exists "seq";
alter table "itsa_conf_submodules" drop column if exists "extra";
alter table "itsa_conf_submodules" drop column if exists "created_at";
alter table "itsa_conf_submodules" drop column if exists "updated_at";
alter table "itsa_conf_submodules" add column if not exists _pk bigint generated always as identity;
alter table "itsa_conf_submodules" add column if not exists _tenant uuid references tenant(id) on delete cascade;
alter table "itsa_conf_submodules" add column if not exists _seq integer not null default 0;
alter table "itsa_conf_submodules" add column if not exists _extra jsonb not null default '{}'::jsonb;
alter table "itsa_conf_submodules" add column if not exists _created_at timestamptz not null default now();
alter table "itsa_conf_submodules" add column if not exists _updated_at timestamptz not null default now();
create index if not exists "itsa_conf_submodules_tenant_seq_idx" on "itsa_conf_submodules" (_tenant, _seq);
create table if not exists "itsa_conf_docnum" (
  _pk         bigint generated always as identity primary key,
  _tenant     uuid references tenant(id) on delete cascade,
  _seq        integer not null default 0,
  _extra      jsonb not null default '{}'::jsonb,
  _created_at timestamptz not null default now(),
  _updated_at timestamptz not null default now()
);
alter table "itsa_conf_docnum" drop column if exists "id";
alter table "itsa_conf_docnum" drop column if exists "tenant_id";
alter table "itsa_conf_docnum" drop column if exists "seq";
alter table "itsa_conf_docnum" drop column if exists "extra";
alter table "itsa_conf_docnum" drop column if exists "created_at";
alter table "itsa_conf_docnum" drop column if exists "updated_at";
alter table "itsa_conf_docnum" add column if not exists _pk bigint generated always as identity;
alter table "itsa_conf_docnum" add column if not exists _tenant uuid references tenant(id) on delete cascade;
alter table "itsa_conf_docnum" add column if not exists _seq integer not null default 0;
alter table "itsa_conf_docnum" add column if not exists _extra jsonb not null default '{}'::jsonb;
alter table "itsa_conf_docnum" add column if not exists _created_at timestamptz not null default now();
alter table "itsa_conf_docnum" add column if not exists _updated_at timestamptz not null default now();
create index if not exists "itsa_conf_docnum_tenant_seq_idx" on "itsa_conf_docnum" (_tenant, _seq);
create table if not exists "itsa_conf_general" (
  _pk         bigint generated always as identity primary key,
  _tenant     uuid references tenant(id) on delete cascade,
  _seq        integer not null default 0,
  _extra      jsonb not null default '{}'::jsonb,
  _created_at timestamptz not null default now(),
  _updated_at timestamptz not null default now()
);
alter table "itsa_conf_general" drop column if exists "id";
alter table "itsa_conf_general" drop column if exists "tenant_id";
alter table "itsa_conf_general" drop column if exists "seq";
alter table "itsa_conf_general" drop column if exists "extra";
alter table "itsa_conf_general" drop column if exists "created_at";
alter table "itsa_conf_general" drop column if exists "updated_at";
alter table "itsa_conf_general" add column if not exists _pk bigint generated always as identity;
alter table "itsa_conf_general" add column if not exists _tenant uuid references tenant(id) on delete cascade;
alter table "itsa_conf_general" add column if not exists _seq integer not null default 0;
alter table "itsa_conf_general" add column if not exists _extra jsonb not null default '{}'::jsonb;
alter table "itsa_conf_general" add column if not exists _created_at timestamptz not null default now();
alter table "itsa_conf_general" add column if not exists _updated_at timestamptz not null default now();
create index if not exists "itsa_conf_general_tenant_seq_idx" on "itsa_conf_general" (_tenant, _seq);
create table if not exists "itsa_conf_sysparam" (
  _pk         bigint generated always as identity primary key,
  _tenant     uuid references tenant(id) on delete cascade,
  _seq        integer not null default 0,
  _extra      jsonb not null default '{}'::jsonb,
  _created_at timestamptz not null default now(),
  _updated_at timestamptz not null default now()
);
alter table "itsa_conf_sysparam" drop column if exists "id";
alter table "itsa_conf_sysparam" drop column if exists "tenant_id";
alter table "itsa_conf_sysparam" drop column if exists "seq";
alter table "itsa_conf_sysparam" drop column if exists "extra";
alter table "itsa_conf_sysparam" drop column if exists "created_at";
alter table "itsa_conf_sysparam" drop column if exists "updated_at";
alter table "itsa_conf_sysparam" add column if not exists _pk bigint generated always as identity;
alter table "itsa_conf_sysparam" add column if not exists _tenant uuid references tenant(id) on delete cascade;
alter table "itsa_conf_sysparam" add column if not exists _seq integer not null default 0;
alter table "itsa_conf_sysparam" add column if not exists _extra jsonb not null default '{}'::jsonb;
alter table "itsa_conf_sysparam" add column if not exists _created_at timestamptz not null default now();
alter table "itsa_conf_sysparam" add column if not exists _updated_at timestamptz not null default now();
create index if not exists "itsa_conf_sysparam_tenant_seq_idx" on "itsa_conf_sysparam" (_tenant, _seq);
create table if not exists "itsa_conf_localization" (
  _pk         bigint generated always as identity primary key,
  _tenant     uuid references tenant(id) on delete cascade,
  _seq        integer not null default 0,
  _extra      jsonb not null default '{}'::jsonb,
  _created_at timestamptz not null default now(),
  _updated_at timestamptz not null default now()
);
alter table "itsa_conf_localization" drop column if exists "id";
alter table "itsa_conf_localization" drop column if exists "tenant_id";
alter table "itsa_conf_localization" drop column if exists "seq";
alter table "itsa_conf_localization" drop column if exists "extra";
alter table "itsa_conf_localization" drop column if exists "created_at";
alter table "itsa_conf_localization" drop column if exists "updated_at";
alter table "itsa_conf_localization" add column if not exists _pk bigint generated always as identity;
alter table "itsa_conf_localization" add column if not exists _tenant uuid references tenant(id) on delete cascade;
alter table "itsa_conf_localization" add column if not exists _seq integer not null default 0;
alter table "itsa_conf_localization" add column if not exists _extra jsonb not null default '{}'::jsonb;
alter table "itsa_conf_localization" add column if not exists _created_at timestamptz not null default now();
alter table "itsa_conf_localization" add column if not exists _updated_at timestamptz not null default now();
create index if not exists "itsa_conf_localization_tenant_seq_idx" on "itsa_conf_localization" (_tenant, _seq);
create table if not exists "itsa_conf_featureflag" (
  _pk         bigint generated always as identity primary key,
  _tenant     uuid references tenant(id) on delete cascade,
  _seq        integer not null default 0,
  _extra      jsonb not null default '{}'::jsonb,
  _created_at timestamptz not null default now(),
  _updated_at timestamptz not null default now()
);
alter table "itsa_conf_featureflag" drop column if exists "id";
alter table "itsa_conf_featureflag" drop column if exists "tenant_id";
alter table "itsa_conf_featureflag" drop column if exists "seq";
alter table "itsa_conf_featureflag" drop column if exists "extra";
alter table "itsa_conf_featureflag" drop column if exists "created_at";
alter table "itsa_conf_featureflag" drop column if exists "updated_at";
alter table "itsa_conf_featureflag" add column if not exists _pk bigint generated always as identity;
alter table "itsa_conf_featureflag" add column if not exists _tenant uuid references tenant(id) on delete cascade;
alter table "itsa_conf_featureflag" add column if not exists _seq integer not null default 0;
alter table "itsa_conf_featureflag" add column if not exists _extra jsonb not null default '{}'::jsonb;
alter table "itsa_conf_featureflag" add column if not exists _created_at timestamptz not null default now();
alter table "itsa_conf_featureflag" add column if not exists _updated_at timestamptz not null default now();
create index if not exists "itsa_conf_featureflag_tenant_seq_idx" on "itsa_conf_featureflag" (_tenant, _seq);

-- ============ ITSA-DASH ============
create table if not exists "itsa_dash_user_dashboard" (
  _pk         bigint generated always as identity primary key,
  _tenant     uuid references tenant(id) on delete cascade,
  _seq        integer not null default 0,
  "no" text,
  "a" text,
  "level" text,
  "ts" text,
  _extra      jsonb not null default '{}'::jsonb,
  _created_at timestamptz not null default now(),
  _updated_at timestamptz not null default now()
);
alter table "itsa_dash_user_dashboard" drop column if exists "id";
alter table "itsa_dash_user_dashboard" drop column if exists "tenant_id";
alter table "itsa_dash_user_dashboard" drop column if exists "seq";
alter table "itsa_dash_user_dashboard" drop column if exists "extra";
alter table "itsa_dash_user_dashboard" drop column if exists "created_at";
alter table "itsa_dash_user_dashboard" drop column if exists "updated_at";
alter table "itsa_dash_user_dashboard" add column if not exists _pk bigint generated always as identity;
alter table "itsa_dash_user_dashboard" add column if not exists _tenant uuid references tenant(id) on delete cascade;
alter table "itsa_dash_user_dashboard" add column if not exists _seq integer not null default 0;
alter table "itsa_dash_user_dashboard" add column if not exists _extra jsonb not null default '{}'::jsonb;
alter table "itsa_dash_user_dashboard" add column if not exists _created_at timestamptz not null default now();
alter table "itsa_dash_user_dashboard" add column if not exists _updated_at timestamptz not null default now();
alter table "itsa_dash_user_dashboard" add column if not exists "no" text;
alter table "itsa_dash_user_dashboard" add column if not exists "a" text;
alter table "itsa_dash_user_dashboard" add column if not exists "level" text;
alter table "itsa_dash_user_dashboard" add column if not exists "ts" text;
create index if not exists "itsa_dash_user_dashboard_tenant_seq_idx" on "itsa_dash_user_dashboard" (_tenant, _seq);
create table if not exists "itsa_dash_security_dashboard" (
  _pk         bigint generated always as identity primary key,
  _tenant     uuid references tenant(id) on delete cascade,
  _seq        integer not null default 0,
  "no" text,
  "a" text,
  "ts" text,
  _extra      jsonb not null default '{}'::jsonb,
  _created_at timestamptz not null default now(),
  _updated_at timestamptz not null default now()
);
alter table "itsa_dash_security_dashboard" drop column if exists "id";
alter table "itsa_dash_security_dashboard" drop column if exists "tenant_id";
alter table "itsa_dash_security_dashboard" drop column if exists "seq";
alter table "itsa_dash_security_dashboard" drop column if exists "extra";
alter table "itsa_dash_security_dashboard" drop column if exists "created_at";
alter table "itsa_dash_security_dashboard" drop column if exists "updated_at";
alter table "itsa_dash_security_dashboard" add column if not exists _pk bigint generated always as identity;
alter table "itsa_dash_security_dashboard" add column if not exists _tenant uuid references tenant(id) on delete cascade;
alter table "itsa_dash_security_dashboard" add column if not exists _seq integer not null default 0;
alter table "itsa_dash_security_dashboard" add column if not exists _extra jsonb not null default '{}'::jsonb;
alter table "itsa_dash_security_dashboard" add column if not exists _created_at timestamptz not null default now();
alter table "itsa_dash_security_dashboard" add column if not exists _updated_at timestamptz not null default now();
alter table "itsa_dash_security_dashboard" add column if not exists "no" text;
alter table "itsa_dash_security_dashboard" add column if not exists "a" text;
alter table "itsa_dash_security_dashboard" add column if not exists "ts" text;
create index if not exists "itsa_dash_security_dashboard_tenant_seq_idx" on "itsa_dash_security_dashboard" (_tenant, _seq);
create table if not exists "itsa_dash_system_dashboard" (
  _pk         bigint generated always as identity primary key,
  _tenant     uuid references tenant(id) on delete cascade,
  _seq        integer not null default 0,
  "a" text,
  "s" text,
  _extra      jsonb not null default '{}'::jsonb,
  _created_at timestamptz not null default now(),
  _updated_at timestamptz not null default now()
);
alter table "itsa_dash_system_dashboard" drop column if exists "id";
alter table "itsa_dash_system_dashboard" drop column if exists "tenant_id";
alter table "itsa_dash_system_dashboard" drop column if exists "seq";
alter table "itsa_dash_system_dashboard" drop column if exists "extra";
alter table "itsa_dash_system_dashboard" drop column if exists "created_at";
alter table "itsa_dash_system_dashboard" drop column if exists "updated_at";
alter table "itsa_dash_system_dashboard" add column if not exists _pk bigint generated always as identity;
alter table "itsa_dash_system_dashboard" add column if not exists _tenant uuid references tenant(id) on delete cascade;
alter table "itsa_dash_system_dashboard" add column if not exists _seq integer not null default 0;
alter table "itsa_dash_system_dashboard" add column if not exists _extra jsonb not null default '{}'::jsonb;
alter table "itsa_dash_system_dashboard" add column if not exists _created_at timestamptz not null default now();
alter table "itsa_dash_system_dashboard" add column if not exists _updated_at timestamptz not null default now();
alter table "itsa_dash_system_dashboard" add column if not exists "a" text;
alter table "itsa_dash_system_dashboard" add column if not exists "s" text;
create index if not exists "itsa_dash_system_dashboard_tenant_seq_idx" on "itsa_dash_system_dashboard" (_tenant, _seq);
create table if not exists "itsa_dash_integration_dashboard" (
  _pk         bigint generated always as identity primary key,
  _tenant     uuid references tenant(id) on delete cascade,
  _seq        integer not null default 0,
  "a" text,
  "s" text,
  _extra      jsonb not null default '{}'::jsonb,
  _created_at timestamptz not null default now(),
  _updated_at timestamptz not null default now()
);
alter table "itsa_dash_integration_dashboard" drop column if exists "id";
alter table "itsa_dash_integration_dashboard" drop column if exists "tenant_id";
alter table "itsa_dash_integration_dashboard" drop column if exists "seq";
alter table "itsa_dash_integration_dashboard" drop column if exists "extra";
alter table "itsa_dash_integration_dashboard" drop column if exists "created_at";
alter table "itsa_dash_integration_dashboard" drop column if exists "updated_at";
alter table "itsa_dash_integration_dashboard" add column if not exists _pk bigint generated always as identity;
alter table "itsa_dash_integration_dashboard" add column if not exists _tenant uuid references tenant(id) on delete cascade;
alter table "itsa_dash_integration_dashboard" add column if not exists _seq integer not null default 0;
alter table "itsa_dash_integration_dashboard" add column if not exists _extra jsonb not null default '{}'::jsonb;
alter table "itsa_dash_integration_dashboard" add column if not exists _created_at timestamptz not null default now();
alter table "itsa_dash_integration_dashboard" add column if not exists _updated_at timestamptz not null default now();
alter table "itsa_dash_integration_dashboard" add column if not exists "a" text;
alter table "itsa_dash_integration_dashboard" add column if not exists "s" text;
create index if not exists "itsa_dash_integration_dashboard_tenant_seq_idx" on "itsa_dash_integration_dashboard" (_tenant, _seq);
create table if not exists "itsa_dash_audit_dashboard" (
  _pk         bigint generated always as identity primary key,
  _tenant     uuid references tenant(id) on delete cascade,
  _seq        integer not null default 0,
  "ts" text,
  "a" text,
  _extra      jsonb not null default '{}'::jsonb,
  _created_at timestamptz not null default now(),
  _updated_at timestamptz not null default now()
);
alter table "itsa_dash_audit_dashboard" drop column if exists "id";
alter table "itsa_dash_audit_dashboard" drop column if exists "tenant_id";
alter table "itsa_dash_audit_dashboard" drop column if exists "seq";
alter table "itsa_dash_audit_dashboard" drop column if exists "extra";
alter table "itsa_dash_audit_dashboard" drop column if exists "created_at";
alter table "itsa_dash_audit_dashboard" drop column if exists "updated_at";
alter table "itsa_dash_audit_dashboard" add column if not exists _pk bigint generated always as identity;
alter table "itsa_dash_audit_dashboard" add column if not exists _tenant uuid references tenant(id) on delete cascade;
alter table "itsa_dash_audit_dashboard" add column if not exists _seq integer not null default 0;
alter table "itsa_dash_audit_dashboard" add column if not exists _extra jsonb not null default '{}'::jsonb;
alter table "itsa_dash_audit_dashboard" add column if not exists _created_at timestamptz not null default now();
alter table "itsa_dash_audit_dashboard" add column if not exists _updated_at timestamptz not null default now();
alter table "itsa_dash_audit_dashboard" add column if not exists "ts" text;
alter table "itsa_dash_audit_dashboard" add column if not exists "a" text;
create index if not exists "itsa_dash_audit_dashboard_tenant_seq_idx" on "itsa_dash_audit_dashboard" (_tenant, _seq);
create table if not exists "itsa_dash_performance_dashboard" (
  _pk         bigint generated always as identity primary key,
  _tenant     uuid references tenant(id) on delete cascade,
  _seq        integer not null default 0,
  "a" text,
  "d" text,
  _extra      jsonb not null default '{}'::jsonb,
  _created_at timestamptz not null default now(),
  _updated_at timestamptz not null default now()
);
alter table "itsa_dash_performance_dashboard" drop column if exists "id";
alter table "itsa_dash_performance_dashboard" drop column if exists "tenant_id";
alter table "itsa_dash_performance_dashboard" drop column if exists "seq";
alter table "itsa_dash_performance_dashboard" drop column if exists "extra";
alter table "itsa_dash_performance_dashboard" drop column if exists "created_at";
alter table "itsa_dash_performance_dashboard" drop column if exists "updated_at";
alter table "itsa_dash_performance_dashboard" add column if not exists _pk bigint generated always as identity;
alter table "itsa_dash_performance_dashboard" add column if not exists _tenant uuid references tenant(id) on delete cascade;
alter table "itsa_dash_performance_dashboard" add column if not exists _seq integer not null default 0;
alter table "itsa_dash_performance_dashboard" add column if not exists _extra jsonb not null default '{}'::jsonb;
alter table "itsa_dash_performance_dashboard" add column if not exists _created_at timestamptz not null default now();
alter table "itsa_dash_performance_dashboard" add column if not exists _updated_at timestamptz not null default now();
alter table "itsa_dash_performance_dashboard" add column if not exists "a" text;
alter table "itsa_dash_performance_dashboard" add column if not exists "d" text;
create index if not exists "itsa_dash_performance_dashboard_tenant_seq_idx" on "itsa_dash_performance_dashboard" (_tenant, _seq);
create table if not exists "itsa_dash_backup_dashboard" (
  _pk         bigint generated always as identity primary key,
  _tenant     uuid references tenant(id) on delete cascade,
  _seq        integer not null default 0,
  "ts" text,
  "s" text,
  _extra      jsonb not null default '{}'::jsonb,
  _created_at timestamptz not null default now(),
  _updated_at timestamptz not null default now()
);
alter table "itsa_dash_backup_dashboard" drop column if exists "id";
alter table "itsa_dash_backup_dashboard" drop column if exists "tenant_id";
alter table "itsa_dash_backup_dashboard" drop column if exists "seq";
alter table "itsa_dash_backup_dashboard" drop column if exists "extra";
alter table "itsa_dash_backup_dashboard" drop column if exists "created_at";
alter table "itsa_dash_backup_dashboard" drop column if exists "updated_at";
alter table "itsa_dash_backup_dashboard" add column if not exists _pk bigint generated always as identity;
alter table "itsa_dash_backup_dashboard" add column if not exists _tenant uuid references tenant(id) on delete cascade;
alter table "itsa_dash_backup_dashboard" add column if not exists _seq integer not null default 0;
alter table "itsa_dash_backup_dashboard" add column if not exists _extra jsonb not null default '{}'::jsonb;
alter table "itsa_dash_backup_dashboard" add column if not exists _created_at timestamptz not null default now();
alter table "itsa_dash_backup_dashboard" add column if not exists _updated_at timestamptz not null default now();
alter table "itsa_dash_backup_dashboard" add column if not exists "ts" text;
alter table "itsa_dash_backup_dashboard" add column if not exists "s" text;
create index if not exists "itsa_dash_backup_dashboard_tenant_seq_idx" on "itsa_dash_backup_dashboard" (_tenant, _seq);

-- ============ ITSA-FILE ============
create table if not exists "itsa_file_storage_configuration" (
  _pk         bigint generated always as identity primary key,
  _tenant     uuid references tenant(id) on delete cascade,
  _seq        integer not null default 0,
  "no" text,
  "a" text,
  "type" text,
  "usage" text,
  "s" text,
  _extra      jsonb not null default '{}'::jsonb,
  _created_at timestamptz not null default now(),
  _updated_at timestamptz not null default now()
);
alter table "itsa_file_storage_configuration" drop column if exists "id";
alter table "itsa_file_storage_configuration" drop column if exists "tenant_id";
alter table "itsa_file_storage_configuration" drop column if exists "seq";
alter table "itsa_file_storage_configuration" drop column if exists "extra";
alter table "itsa_file_storage_configuration" drop column if exists "created_at";
alter table "itsa_file_storage_configuration" drop column if exists "updated_at";
alter table "itsa_file_storage_configuration" add column if not exists _pk bigint generated always as identity;
alter table "itsa_file_storage_configuration" add column if not exists _tenant uuid references tenant(id) on delete cascade;
alter table "itsa_file_storage_configuration" add column if not exists _seq integer not null default 0;
alter table "itsa_file_storage_configuration" add column if not exists _extra jsonb not null default '{}'::jsonb;
alter table "itsa_file_storage_configuration" add column if not exists _created_at timestamptz not null default now();
alter table "itsa_file_storage_configuration" add column if not exists _updated_at timestamptz not null default now();
alter table "itsa_file_storage_configuration" add column if not exists "no" text;
alter table "itsa_file_storage_configuration" add column if not exists "a" text;
alter table "itsa_file_storage_configuration" add column if not exists "type" text;
alter table "itsa_file_storage_configuration" add column if not exists "usage" text;
alter table "itsa_file_storage_configuration" add column if not exists "s" text;
create index if not exists "itsa_file_storage_configuration_tenant_seq_idx" on "itsa_file_storage_configuration" (_tenant, _seq);
create table if not exists "itsa_file_folder" (
  _pk         bigint generated always as identity primary key,
  _tenant     uuid references tenant(id) on delete cascade,
  _seq        integer not null default 0,
  "a" text,
  "d" text,
  "s" text,
  _extra      jsonb not null default '{}'::jsonb,
  _created_at timestamptz not null default now(),
  _updated_at timestamptz not null default now()
);
alter table "itsa_file_folder" drop column if exists "id";
alter table "itsa_file_folder" drop column if exists "tenant_id";
alter table "itsa_file_folder" drop column if exists "seq";
alter table "itsa_file_folder" drop column if exists "extra";
alter table "itsa_file_folder" drop column if exists "created_at";
alter table "itsa_file_folder" drop column if exists "updated_at";
alter table "itsa_file_folder" add column if not exists _pk bigint generated always as identity;
alter table "itsa_file_folder" add column if not exists _tenant uuid references tenant(id) on delete cascade;
alter table "itsa_file_folder" add column if not exists _seq integer not null default 0;
alter table "itsa_file_folder" add column if not exists _extra jsonb not null default '{}'::jsonb;
alter table "itsa_file_folder" add column if not exists _created_at timestamptz not null default now();
alter table "itsa_file_folder" add column if not exists _updated_at timestamptz not null default now();
alter table "itsa_file_folder" add column if not exists "a" text;
alter table "itsa_file_folder" add column if not exists "d" text;
alter table "itsa_file_folder" add column if not exists "s" text;
create index if not exists "itsa_file_folder_tenant_seq_idx" on "itsa_file_folder" (_tenant, _seq);
create table if not exists "itsa_file_quota" (
  _pk         bigint generated always as identity primary key,
  _tenant     uuid references tenant(id) on delete cascade,
  _seq        integer not null default 0,
  "a" text,
  "d" text,
  "s" text,
  _extra      jsonb not null default '{}'::jsonb,
  _created_at timestamptz not null default now(),
  _updated_at timestamptz not null default now()
);
alter table "itsa_file_quota" drop column if exists "id";
alter table "itsa_file_quota" drop column if exists "tenant_id";
alter table "itsa_file_quota" drop column if exists "seq";
alter table "itsa_file_quota" drop column if exists "extra";
alter table "itsa_file_quota" drop column if exists "created_at";
alter table "itsa_file_quota" drop column if exists "updated_at";
alter table "itsa_file_quota" add column if not exists _pk bigint generated always as identity;
alter table "itsa_file_quota" add column if not exists _tenant uuid references tenant(id) on delete cascade;
alter table "itsa_file_quota" add column if not exists _seq integer not null default 0;
alter table "itsa_file_quota" add column if not exists _extra jsonb not null default '{}'::jsonb;
alter table "itsa_file_quota" add column if not exists _created_at timestamptz not null default now();
alter table "itsa_file_quota" add column if not exists _updated_at timestamptz not null default now();
alter table "itsa_file_quota" add column if not exists "a" text;
alter table "itsa_file_quota" add column if not exists "d" text;
alter table "itsa_file_quota" add column if not exists "s" text;
create index if not exists "itsa_file_quota_tenant_seq_idx" on "itsa_file_quota" (_tenant, _seq);
create table if not exists "itsa_file_file_sharing" (
  _pk         bigint generated always as identity primary key,
  _tenant     uuid references tenant(id) on delete cascade,
  _seq        integer not null default 0,
  "a" text,
  "d" text,
  "s" text,
  _extra      jsonb not null default '{}'::jsonb,
  _created_at timestamptz not null default now(),
  _updated_at timestamptz not null default now()
);
alter table "itsa_file_file_sharing" drop column if exists "id";
alter table "itsa_file_file_sharing" drop column if exists "tenant_id";
alter table "itsa_file_file_sharing" drop column if exists "seq";
alter table "itsa_file_file_sharing" drop column if exists "extra";
alter table "itsa_file_file_sharing" drop column if exists "created_at";
alter table "itsa_file_file_sharing" drop column if exists "updated_at";
alter table "itsa_file_file_sharing" add column if not exists _pk bigint generated always as identity;
alter table "itsa_file_file_sharing" add column if not exists _tenant uuid references tenant(id) on delete cascade;
alter table "itsa_file_file_sharing" add column if not exists _seq integer not null default 0;
alter table "itsa_file_file_sharing" add column if not exists _extra jsonb not null default '{}'::jsonb;
alter table "itsa_file_file_sharing" add column if not exists _created_at timestamptz not null default now();
alter table "itsa_file_file_sharing" add column if not exists _updated_at timestamptz not null default now();
alter table "itsa_file_file_sharing" add column if not exists "a" text;
alter table "itsa_file_file_sharing" add column if not exists "d" text;
alter table "itsa_file_file_sharing" add column if not exists "s" text;
create index if not exists "itsa_file_file_sharing_tenant_seq_idx" on "itsa_file_file_sharing" (_tenant, _seq);
create table if not exists "itsa_file_file_log" (
  _pk         bigint generated always as identity primary key,
  _tenant     uuid references tenant(id) on delete cascade,
  _seq        integer not null default 0,
  "ts" text,
  "a" text,
  "d" text,
  _extra      jsonb not null default '{}'::jsonb,
  _created_at timestamptz not null default now(),
  _updated_at timestamptz not null default now()
);
alter table "itsa_file_file_log" drop column if exists "id";
alter table "itsa_file_file_log" drop column if exists "tenant_id";
alter table "itsa_file_file_log" drop column if exists "seq";
alter table "itsa_file_file_log" drop column if exists "extra";
alter table "itsa_file_file_log" drop column if exists "created_at";
alter table "itsa_file_file_log" drop column if exists "updated_at";
alter table "itsa_file_file_log" add column if not exists _pk bigint generated always as identity;
alter table "itsa_file_file_log" add column if not exists _tenant uuid references tenant(id) on delete cascade;
alter table "itsa_file_file_log" add column if not exists _seq integer not null default 0;
alter table "itsa_file_file_log" add column if not exists _extra jsonb not null default '{}'::jsonb;
alter table "itsa_file_file_log" add column if not exists _created_at timestamptz not null default now();
alter table "itsa_file_file_log" add column if not exists _updated_at timestamptz not null default now();
alter table "itsa_file_file_log" add column if not exists "ts" text;
alter table "itsa_file_file_log" add column if not exists "a" text;
alter table "itsa_file_file_log" add column if not exists "d" text;
create index if not exists "itsa_file_file_log_tenant_seq_idx" on "itsa_file_file_log" (_tenant, _seq);

-- ============ ITSA-INTG ============
create table if not exists "itsa_intg_api" (
  _pk         bigint generated always as identity primary key,
  _tenant     uuid references tenant(id) on delete cascade,
  _seq        integer not null default 0,
  "no" text,
  "a" text,
  "type" text,
  "endpoint" text,
  "s" text,
  _extra      jsonb not null default '{}'::jsonb,
  _created_at timestamptz not null default now(),
  _updated_at timestamptz not null default now()
);
alter table "itsa_intg_api" drop column if exists "id";
alter table "itsa_intg_api" drop column if exists "tenant_id";
alter table "itsa_intg_api" drop column if exists "seq";
alter table "itsa_intg_api" drop column if exists "extra";
alter table "itsa_intg_api" drop column if exists "created_at";
alter table "itsa_intg_api" drop column if exists "updated_at";
alter table "itsa_intg_api" add column if not exists _pk bigint generated always as identity;
alter table "itsa_intg_api" add column if not exists _tenant uuid references tenant(id) on delete cascade;
alter table "itsa_intg_api" add column if not exists _seq integer not null default 0;
alter table "itsa_intg_api" add column if not exists _extra jsonb not null default '{}'::jsonb;
alter table "itsa_intg_api" add column if not exists _created_at timestamptz not null default now();
alter table "itsa_intg_api" add column if not exists _updated_at timestamptz not null default now();
alter table "itsa_intg_api" add column if not exists "no" text;
alter table "itsa_intg_api" add column if not exists "a" text;
alter table "itsa_intg_api" add column if not exists "type" text;
alter table "itsa_intg_api" add column if not exists "endpoint" text;
alter table "itsa_intg_api" add column if not exists "s" text;
create index if not exists "itsa_intg_api_tenant_seq_idx" on "itsa_intg_api" (_tenant, _seq);
create table if not exists "itsa_intg_webhook" (
  _pk         bigint generated always as identity primary key,
  _tenant     uuid references tenant(id) on delete cascade,
  _seq        integer not null default 0,
  "a" text,
  "d" text,
  "s" text,
  _extra      jsonb not null default '{}'::jsonb,
  _created_at timestamptz not null default now(),
  _updated_at timestamptz not null default now()
);
alter table "itsa_intg_webhook" drop column if exists "id";
alter table "itsa_intg_webhook" drop column if exists "tenant_id";
alter table "itsa_intg_webhook" drop column if exists "seq";
alter table "itsa_intg_webhook" drop column if exists "extra";
alter table "itsa_intg_webhook" drop column if exists "created_at";
alter table "itsa_intg_webhook" drop column if exists "updated_at";
alter table "itsa_intg_webhook" add column if not exists _pk bigint generated always as identity;
alter table "itsa_intg_webhook" add column if not exists _tenant uuid references tenant(id) on delete cascade;
alter table "itsa_intg_webhook" add column if not exists _seq integer not null default 0;
alter table "itsa_intg_webhook" add column if not exists _extra jsonb not null default '{}'::jsonb;
alter table "itsa_intg_webhook" add column if not exists _created_at timestamptz not null default now();
alter table "itsa_intg_webhook" add column if not exists _updated_at timestamptz not null default now();
alter table "itsa_intg_webhook" add column if not exists "a" text;
alter table "itsa_intg_webhook" add column if not exists "d" text;
alter table "itsa_intg_webhook" add column if not exists "s" text;
create index if not exists "itsa_intg_webhook_tenant_seq_idx" on "itsa_intg_webhook" (_tenant, _seq);
create table if not exists "itsa_intg_oauth_client" (
  _pk         bigint generated always as identity primary key,
  _tenant     uuid references tenant(id) on delete cascade,
  _seq        integer not null default 0,
  "a" text,
  "d" text,
  "s" text,
  _extra      jsonb not null default '{}'::jsonb,
  _created_at timestamptz not null default now(),
  _updated_at timestamptz not null default now()
);
alter table "itsa_intg_oauth_client" drop column if exists "id";
alter table "itsa_intg_oauth_client" drop column if exists "tenant_id";
alter table "itsa_intg_oauth_client" drop column if exists "seq";
alter table "itsa_intg_oauth_client" drop column if exists "extra";
alter table "itsa_intg_oauth_client" drop column if exists "created_at";
alter table "itsa_intg_oauth_client" drop column if exists "updated_at";
alter table "itsa_intg_oauth_client" add column if not exists _pk bigint generated always as identity;
alter table "itsa_intg_oauth_client" add column if not exists _tenant uuid references tenant(id) on delete cascade;
alter table "itsa_intg_oauth_client" add column if not exists _seq integer not null default 0;
alter table "itsa_intg_oauth_client" add column if not exists _extra jsonb not null default '{}'::jsonb;
alter table "itsa_intg_oauth_client" add column if not exists _created_at timestamptz not null default now();
alter table "itsa_intg_oauth_client" add column if not exists _updated_at timestamptz not null default now();
alter table "itsa_intg_oauth_client" add column if not exists "a" text;
alter table "itsa_intg_oauth_client" add column if not exists "d" text;
alter table "itsa_intg_oauth_client" add column if not exists "s" text;
create index if not exists "itsa_intg_oauth_client_tenant_seq_idx" on "itsa_intg_oauth_client" (_tenant, _seq);
create table if not exists "itsa_intg_external_system" (
  _pk         bigint generated always as identity primary key,
  _tenant     uuid references tenant(id) on delete cascade,
  _seq        integer not null default 0,
  "a" text,
  "d" text,
  "s" text,
  _extra      jsonb not null default '{}'::jsonb,
  _created_at timestamptz not null default now(),
  _updated_at timestamptz not null default now()
);
alter table "itsa_intg_external_system" drop column if exists "id";
alter table "itsa_intg_external_system" drop column if exists "tenant_id";
alter table "itsa_intg_external_system" drop column if exists "seq";
alter table "itsa_intg_external_system" drop column if exists "extra";
alter table "itsa_intg_external_system" drop column if exists "created_at";
alter table "itsa_intg_external_system" drop column if exists "updated_at";
alter table "itsa_intg_external_system" add column if not exists _pk bigint generated always as identity;
alter table "itsa_intg_external_system" add column if not exists _tenant uuid references tenant(id) on delete cascade;
alter table "itsa_intg_external_system" add column if not exists _seq integer not null default 0;
alter table "itsa_intg_external_system" add column if not exists _extra jsonb not null default '{}'::jsonb;
alter table "itsa_intg_external_system" add column if not exists _created_at timestamptz not null default now();
alter table "itsa_intg_external_system" add column if not exists _updated_at timestamptz not null default now();
alter table "itsa_intg_external_system" add column if not exists "a" text;
alter table "itsa_intg_external_system" add column if not exists "d" text;
alter table "itsa_intg_external_system" add column if not exists "s" text;
create index if not exists "itsa_intg_external_system_tenant_seq_idx" on "itsa_intg_external_system" (_tenant, _seq);
create table if not exists "itsa_intg_api_monitor" (
  _pk         bigint generated always as identity primary key,
  _tenant     uuid references tenant(id) on delete cascade,
  _seq        integer not null default 0,
  "a" text,
  "d" text,
  "s" text,
  _extra      jsonb not null default '{}'::jsonb,
  _created_at timestamptz not null default now(),
  _updated_at timestamptz not null default now()
);
alter table "itsa_intg_api_monitor" drop column if exists "id";
alter table "itsa_intg_api_monitor" drop column if exists "tenant_id";
alter table "itsa_intg_api_monitor" drop column if exists "seq";
alter table "itsa_intg_api_monitor" drop column if exists "extra";
alter table "itsa_intg_api_monitor" drop column if exists "created_at";
alter table "itsa_intg_api_monitor" drop column if exists "updated_at";
alter table "itsa_intg_api_monitor" add column if not exists _pk bigint generated always as identity;
alter table "itsa_intg_api_monitor" add column if not exists _tenant uuid references tenant(id) on delete cascade;
alter table "itsa_intg_api_monitor" add column if not exists _seq integer not null default 0;
alter table "itsa_intg_api_monitor" add column if not exists _extra jsonb not null default '{}'::jsonb;
alter table "itsa_intg_api_monitor" add column if not exists _created_at timestamptz not null default now();
alter table "itsa_intg_api_monitor" add column if not exists _updated_at timestamptz not null default now();
alter table "itsa_intg_api_monitor" add column if not exists "a" text;
alter table "itsa_intg_api_monitor" add column if not exists "d" text;
alter table "itsa_intg_api_monitor" add column if not exists "s" text;
create index if not exists "itsa_intg_api_monitor_tenant_seq_idx" on "itsa_intg_api_monitor" (_tenant, _seq);
create table if not exists "itsa_intg_api_log" (
  _pk         bigint generated always as identity primary key,
  _tenant     uuid references tenant(id) on delete cascade,
  _seq        integer not null default 0,
  "ts" text,
  "a" text,
  "s" text,
  _extra      jsonb not null default '{}'::jsonb,
  _created_at timestamptz not null default now(),
  _updated_at timestamptz not null default now()
);
alter table "itsa_intg_api_log" drop column if exists "id";
alter table "itsa_intg_api_log" drop column if exists "tenant_id";
alter table "itsa_intg_api_log" drop column if exists "seq";
alter table "itsa_intg_api_log" drop column if exists "extra";
alter table "itsa_intg_api_log" drop column if exists "created_at";
alter table "itsa_intg_api_log" drop column if exists "updated_at";
alter table "itsa_intg_api_log" add column if not exists _pk bigint generated always as identity;
alter table "itsa_intg_api_log" add column if not exists _tenant uuid references tenant(id) on delete cascade;
alter table "itsa_intg_api_log" add column if not exists _seq integer not null default 0;
alter table "itsa_intg_api_log" add column if not exists _extra jsonb not null default '{}'::jsonb;
alter table "itsa_intg_api_log" add column if not exists _created_at timestamptz not null default now();
alter table "itsa_intg_api_log" add column if not exists _updated_at timestamptz not null default now();
alter table "itsa_intg_api_log" add column if not exists "ts" text;
alter table "itsa_intg_api_log" add column if not exists "a" text;
alter table "itsa_intg_api_log" add column if not exists "s" text;
create index if not exists "itsa_intg_api_log_tenant_seq_idx" on "itsa_intg_api_log" (_tenant, _seq);

-- ============ ITSA-LOGS ============
create table if not exists "itsa_logs_system_log" (
  _pk         bigint generated always as identity primary key,
  _tenant     uuid references tenant(id) on delete cascade,
  _seq        integer not null default 0,
  "no" text,
  "ts" text,
  "level" text,
  "source" text,
  "msg" text,
  _extra      jsonb not null default '{}'::jsonb,
  _created_at timestamptz not null default now(),
  _updated_at timestamptz not null default now()
);
alter table "itsa_logs_system_log" drop column if exists "id";
alter table "itsa_logs_system_log" drop column if exists "tenant_id";
alter table "itsa_logs_system_log" drop column if exists "seq";
alter table "itsa_logs_system_log" drop column if exists "extra";
alter table "itsa_logs_system_log" drop column if exists "created_at";
alter table "itsa_logs_system_log" drop column if exists "updated_at";
alter table "itsa_logs_system_log" add column if not exists _pk bigint generated always as identity;
alter table "itsa_logs_system_log" add column if not exists _tenant uuid references tenant(id) on delete cascade;
alter table "itsa_logs_system_log" add column if not exists _seq integer not null default 0;
alter table "itsa_logs_system_log" add column if not exists _extra jsonb not null default '{}'::jsonb;
alter table "itsa_logs_system_log" add column if not exists _created_at timestamptz not null default now();
alter table "itsa_logs_system_log" add column if not exists _updated_at timestamptz not null default now();
alter table "itsa_logs_system_log" add column if not exists "no" text;
alter table "itsa_logs_system_log" add column if not exists "ts" text;
alter table "itsa_logs_system_log" add column if not exists "level" text;
alter table "itsa_logs_system_log" add column if not exists "source" text;
alter table "itsa_logs_system_log" add column if not exists "msg" text;
create index if not exists "itsa_logs_system_log_tenant_seq_idx" on "itsa_logs_system_log" (_tenant, _seq);
create table if not exists "itsa_logs_application_log" (
  _pk         bigint generated always as identity primary key,
  _tenant     uuid references tenant(id) on delete cascade,
  _seq        integer not null default 0,
  "ts" text,
  "a" text,
  "msg" text,
  _extra      jsonb not null default '{}'::jsonb,
  _created_at timestamptz not null default now(),
  _updated_at timestamptz not null default now()
);
alter table "itsa_logs_application_log" drop column if exists "id";
alter table "itsa_logs_application_log" drop column if exists "tenant_id";
alter table "itsa_logs_application_log" drop column if exists "seq";
alter table "itsa_logs_application_log" drop column if exists "extra";
alter table "itsa_logs_application_log" drop column if exists "created_at";
alter table "itsa_logs_application_log" drop column if exists "updated_at";
alter table "itsa_logs_application_log" add column if not exists _pk bigint generated always as identity;
alter table "itsa_logs_application_log" add column if not exists _tenant uuid references tenant(id) on delete cascade;
alter table "itsa_logs_application_log" add column if not exists _seq integer not null default 0;
alter table "itsa_logs_application_log" add column if not exists _extra jsonb not null default '{}'::jsonb;
alter table "itsa_logs_application_log" add column if not exists _created_at timestamptz not null default now();
alter table "itsa_logs_application_log" add column if not exists _updated_at timestamptz not null default now();
alter table "itsa_logs_application_log" add column if not exists "ts" text;
alter table "itsa_logs_application_log" add column if not exists "a" text;
alter table "itsa_logs_application_log" add column if not exists "msg" text;
create index if not exists "itsa_logs_application_log_tenant_seq_idx" on "itsa_logs_application_log" (_tenant, _seq);
create table if not exists "itsa_logs_access_log" (
  _pk         bigint generated always as identity primary key,
  _tenant     uuid references tenant(id) on delete cascade,
  _seq        integer not null default 0,
  "ts" text,
  "a" text,
  "res" text,
  _extra      jsonb not null default '{}'::jsonb,
  _created_at timestamptz not null default now(),
  _updated_at timestamptz not null default now()
);
alter table "itsa_logs_access_log" drop column if exists "id";
alter table "itsa_logs_access_log" drop column if exists "tenant_id";
alter table "itsa_logs_access_log" drop column if exists "seq";
alter table "itsa_logs_access_log" drop column if exists "extra";
alter table "itsa_logs_access_log" drop column if exists "created_at";
alter table "itsa_logs_access_log" drop column if exists "updated_at";
alter table "itsa_logs_access_log" add column if not exists _pk bigint generated always as identity;
alter table "itsa_logs_access_log" add column if not exists _tenant uuid references tenant(id) on delete cascade;
alter table "itsa_logs_access_log" add column if not exists _seq integer not null default 0;
alter table "itsa_logs_access_log" add column if not exists _extra jsonb not null default '{}'::jsonb;
alter table "itsa_logs_access_log" add column if not exists _created_at timestamptz not null default now();
alter table "itsa_logs_access_log" add column if not exists _updated_at timestamptz not null default now();
alter table "itsa_logs_access_log" add column if not exists "ts" text;
alter table "itsa_logs_access_log" add column if not exists "a" text;
alter table "itsa_logs_access_log" add column if not exists "res" text;
create index if not exists "itsa_logs_access_log_tenant_seq_idx" on "itsa_logs_access_log" (_tenant, _seq);
create table if not exists "itsa_logs_log_retention" (
  _pk         bigint generated always as identity primary key,
  _tenant     uuid references tenant(id) on delete cascade,
  _seq        integer not null default 0,
  "a" text,
  "d" text,
  "s" text,
  _extra      jsonb not null default '{}'::jsonb,
  _created_at timestamptz not null default now(),
  _updated_at timestamptz not null default now()
);
alter table "itsa_logs_log_retention" drop column if exists "id";
alter table "itsa_logs_log_retention" drop column if exists "tenant_id";
alter table "itsa_logs_log_retention" drop column if exists "seq";
alter table "itsa_logs_log_retention" drop column if exists "extra";
alter table "itsa_logs_log_retention" drop column if exists "created_at";
alter table "itsa_logs_log_retention" drop column if exists "updated_at";
alter table "itsa_logs_log_retention" add column if not exists _pk bigint generated always as identity;
alter table "itsa_logs_log_retention" add column if not exists _tenant uuid references tenant(id) on delete cascade;
alter table "itsa_logs_log_retention" add column if not exists _seq integer not null default 0;
alter table "itsa_logs_log_retention" add column if not exists _extra jsonb not null default '{}'::jsonb;
alter table "itsa_logs_log_retention" add column if not exists _created_at timestamptz not null default now();
alter table "itsa_logs_log_retention" add column if not exists _updated_at timestamptz not null default now();
alter table "itsa_logs_log_retention" add column if not exists "a" text;
alter table "itsa_logs_log_retention" add column if not exists "d" text;
alter table "itsa_logs_log_retention" add column if not exists "s" text;
create index if not exists "itsa_logs_log_retention_tenant_seq_idx" on "itsa_logs_log_retention" (_tenant, _seq);
create table if not exists "itsa_logs_log_search" (
  _pk         bigint generated always as identity primary key,
  _tenant     uuid references tenant(id) on delete cascade,
  _seq        integer not null default 0,
  "a" text,
  "cnt" text,
  "ts" text,
  _extra      jsonb not null default '{}'::jsonb,
  _created_at timestamptz not null default now(),
  _updated_at timestamptz not null default now()
);
alter table "itsa_logs_log_search" drop column if exists "id";
alter table "itsa_logs_log_search" drop column if exists "tenant_id";
alter table "itsa_logs_log_search" drop column if exists "seq";
alter table "itsa_logs_log_search" drop column if exists "extra";
alter table "itsa_logs_log_search" drop column if exists "created_at";
alter table "itsa_logs_log_search" drop column if exists "updated_at";
alter table "itsa_logs_log_search" add column if not exists _pk bigint generated always as identity;
alter table "itsa_logs_log_search" add column if not exists _tenant uuid references tenant(id) on delete cascade;
alter table "itsa_logs_log_search" add column if not exists _seq integer not null default 0;
alter table "itsa_logs_log_search" add column if not exists _extra jsonb not null default '{}'::jsonb;
alter table "itsa_logs_log_search" add column if not exists _created_at timestamptz not null default now();
alter table "itsa_logs_log_search" add column if not exists _updated_at timestamptz not null default now();
alter table "itsa_logs_log_search" add column if not exists "a" text;
alter table "itsa_logs_log_search" add column if not exists "cnt" text;
alter table "itsa_logs_log_search" add column if not exists "ts" text;
create index if not exists "itsa_logs_log_search_tenant_seq_idx" on "itsa_logs_log_search" (_tenant, _seq);

-- ============ ITSA-NOTI ============
create table if not exists "itsa_noti_notification_template" (
  _pk         bigint generated always as identity primary key,
  _tenant     uuid references tenant(id) on delete cascade,
  _seq        integer not null default 0,
  "no" text,
  "a" text,
  "ch" text,
  "evt" text,
  "s" text,
  _extra      jsonb not null default '{}'::jsonb,
  _created_at timestamptz not null default now(),
  _updated_at timestamptz not null default now()
);
alter table "itsa_noti_notification_template" drop column if exists "id";
alter table "itsa_noti_notification_template" drop column if exists "tenant_id";
alter table "itsa_noti_notification_template" drop column if exists "seq";
alter table "itsa_noti_notification_template" drop column if exists "extra";
alter table "itsa_noti_notification_template" drop column if exists "created_at";
alter table "itsa_noti_notification_template" drop column if exists "updated_at";
alter table "itsa_noti_notification_template" add column if not exists _pk bigint generated always as identity;
alter table "itsa_noti_notification_template" add column if not exists _tenant uuid references tenant(id) on delete cascade;
alter table "itsa_noti_notification_template" add column if not exists _seq integer not null default 0;
alter table "itsa_noti_notification_template" add column if not exists _extra jsonb not null default '{}'::jsonb;
alter table "itsa_noti_notification_template" add column if not exists _created_at timestamptz not null default now();
alter table "itsa_noti_notification_template" add column if not exists _updated_at timestamptz not null default now();
alter table "itsa_noti_notification_template" add column if not exists "no" text;
alter table "itsa_noti_notification_template" add column if not exists "a" text;
alter table "itsa_noti_notification_template" add column if not exists "ch" text;
alter table "itsa_noti_notification_template" add column if not exists "evt" text;
alter table "itsa_noti_notification_template" add column if not exists "s" text;
create index if not exists "itsa_noti_notification_template_tenant_seq_idx" on "itsa_noti_notification_template" (_tenant, _seq);
create table if not exists "itsa_noti_email_notification" (
  _pk         bigint generated always as identity primary key,
  _tenant     uuid references tenant(id) on delete cascade,
  _seq        integer not null default 0,
  "a" text,
  "d" text,
  "s" text,
  _extra      jsonb not null default '{}'::jsonb,
  _created_at timestamptz not null default now(),
  _updated_at timestamptz not null default now()
);
alter table "itsa_noti_email_notification" drop column if exists "id";
alter table "itsa_noti_email_notification" drop column if exists "tenant_id";
alter table "itsa_noti_email_notification" drop column if exists "seq";
alter table "itsa_noti_email_notification" drop column if exists "extra";
alter table "itsa_noti_email_notification" drop column if exists "created_at";
alter table "itsa_noti_email_notification" drop column if exists "updated_at";
alter table "itsa_noti_email_notification" add column if not exists _pk bigint generated always as identity;
alter table "itsa_noti_email_notification" add column if not exists _tenant uuid references tenant(id) on delete cascade;
alter table "itsa_noti_email_notification" add column if not exists _seq integer not null default 0;
alter table "itsa_noti_email_notification" add column if not exists _extra jsonb not null default '{}'::jsonb;
alter table "itsa_noti_email_notification" add column if not exists _created_at timestamptz not null default now();
alter table "itsa_noti_email_notification" add column if not exists _updated_at timestamptz not null default now();
alter table "itsa_noti_email_notification" add column if not exists "a" text;
alter table "itsa_noti_email_notification" add column if not exists "d" text;
alter table "itsa_noti_email_notification" add column if not exists "s" text;
create index if not exists "itsa_noti_email_notification_tenant_seq_idx" on "itsa_noti_email_notification" (_tenant, _seq);
create table if not exists "itsa_noti_sms_notification" (
  _pk         bigint generated always as identity primary key,
  _tenant     uuid references tenant(id) on delete cascade,
  _seq        integer not null default 0,
  "a" text,
  "d" text,
  "s" text,
  _extra      jsonb not null default '{}'::jsonb,
  _created_at timestamptz not null default now(),
  _updated_at timestamptz not null default now()
);
alter table "itsa_noti_sms_notification" drop column if exists "id";
alter table "itsa_noti_sms_notification" drop column if exists "tenant_id";
alter table "itsa_noti_sms_notification" drop column if exists "seq";
alter table "itsa_noti_sms_notification" drop column if exists "extra";
alter table "itsa_noti_sms_notification" drop column if exists "created_at";
alter table "itsa_noti_sms_notification" drop column if exists "updated_at";
alter table "itsa_noti_sms_notification" add column if not exists _pk bigint generated always as identity;
alter table "itsa_noti_sms_notification" add column if not exists _tenant uuid references tenant(id) on delete cascade;
alter table "itsa_noti_sms_notification" add column if not exists _seq integer not null default 0;
alter table "itsa_noti_sms_notification" add column if not exists _extra jsonb not null default '{}'::jsonb;
alter table "itsa_noti_sms_notification" add column if not exists _created_at timestamptz not null default now();
alter table "itsa_noti_sms_notification" add column if not exists _updated_at timestamptz not null default now();
alter table "itsa_noti_sms_notification" add column if not exists "a" text;
alter table "itsa_noti_sms_notification" add column if not exists "d" text;
alter table "itsa_noti_sms_notification" add column if not exists "s" text;
create index if not exists "itsa_noti_sms_notification_tenant_seq_idx" on "itsa_noti_sms_notification" (_tenant, _seq);
create table if not exists "itsa_noti_line_notification" (
  _pk         bigint generated always as identity primary key,
  _tenant     uuid references tenant(id) on delete cascade,
  _seq        integer not null default 0,
  "a" text,
  "d" text,
  "s" text,
  _extra      jsonb not null default '{}'::jsonb,
  _created_at timestamptz not null default now(),
  _updated_at timestamptz not null default now()
);
alter table "itsa_noti_line_notification" drop column if exists "id";
alter table "itsa_noti_line_notification" drop column if exists "tenant_id";
alter table "itsa_noti_line_notification" drop column if exists "seq";
alter table "itsa_noti_line_notification" drop column if exists "extra";
alter table "itsa_noti_line_notification" drop column if exists "created_at";
alter table "itsa_noti_line_notification" drop column if exists "updated_at";
alter table "itsa_noti_line_notification" add column if not exists _pk bigint generated always as identity;
alter table "itsa_noti_line_notification" add column if not exists _tenant uuid references tenant(id) on delete cascade;
alter table "itsa_noti_line_notification" add column if not exists _seq integer not null default 0;
alter table "itsa_noti_line_notification" add column if not exists _extra jsonb not null default '{}'::jsonb;
alter table "itsa_noti_line_notification" add column if not exists _created_at timestamptz not null default now();
alter table "itsa_noti_line_notification" add column if not exists _updated_at timestamptz not null default now();
alter table "itsa_noti_line_notification" add column if not exists "a" text;
alter table "itsa_noti_line_notification" add column if not exists "d" text;
alter table "itsa_noti_line_notification" add column if not exists "s" text;
create index if not exists "itsa_noti_line_notification_tenant_seq_idx" on "itsa_noti_line_notification" (_tenant, _seq);
create table if not exists "itsa_noti_push_notification" (
  _pk         bigint generated always as identity primary key,
  _tenant     uuid references tenant(id) on delete cascade,
  _seq        integer not null default 0,
  "a" text,
  "d" text,
  "s" text,
  _extra      jsonb not null default '{}'::jsonb,
  _created_at timestamptz not null default now(),
  _updated_at timestamptz not null default now()
);
alter table "itsa_noti_push_notification" drop column if exists "id";
alter table "itsa_noti_push_notification" drop column if exists "tenant_id";
alter table "itsa_noti_push_notification" drop column if exists "seq";
alter table "itsa_noti_push_notification" drop column if exists "extra";
alter table "itsa_noti_push_notification" drop column if exists "created_at";
alter table "itsa_noti_push_notification" drop column if exists "updated_at";
alter table "itsa_noti_push_notification" add column if not exists _pk bigint generated always as identity;
alter table "itsa_noti_push_notification" add column if not exists _tenant uuid references tenant(id) on delete cascade;
alter table "itsa_noti_push_notification" add column if not exists _seq integer not null default 0;
alter table "itsa_noti_push_notification" add column if not exists _extra jsonb not null default '{}'::jsonb;
alter table "itsa_noti_push_notification" add column if not exists _created_at timestamptz not null default now();
alter table "itsa_noti_push_notification" add column if not exists _updated_at timestamptz not null default now();
alter table "itsa_noti_push_notification" add column if not exists "a" text;
alter table "itsa_noti_push_notification" add column if not exists "d" text;
alter table "itsa_noti_push_notification" add column if not exists "s" text;
create index if not exists "itsa_noti_push_notification_tenant_seq_idx" on "itsa_noti_push_notification" (_tenant, _seq);
create table if not exists "itsa_noti_notification_log" (
  _pk         bigint generated always as identity primary key,
  _tenant     uuid references tenant(id) on delete cascade,
  _seq        integer not null default 0,
  "ts" text,
  "ch" text,
  "to" text,
  "s" text,
  _extra      jsonb not null default '{}'::jsonb,
  _created_at timestamptz not null default now(),
  _updated_at timestamptz not null default now()
);
alter table "itsa_noti_notification_log" drop column if exists "id";
alter table "itsa_noti_notification_log" drop column if exists "tenant_id";
alter table "itsa_noti_notification_log" drop column if exists "seq";
alter table "itsa_noti_notification_log" drop column if exists "extra";
alter table "itsa_noti_notification_log" drop column if exists "created_at";
alter table "itsa_noti_notification_log" drop column if exists "updated_at";
alter table "itsa_noti_notification_log" add column if not exists _pk bigint generated always as identity;
alter table "itsa_noti_notification_log" add column if not exists _tenant uuid references tenant(id) on delete cascade;
alter table "itsa_noti_notification_log" add column if not exists _seq integer not null default 0;
alter table "itsa_noti_notification_log" add column if not exists _extra jsonb not null default '{}'::jsonb;
alter table "itsa_noti_notification_log" add column if not exists _created_at timestamptz not null default now();
alter table "itsa_noti_notification_log" add column if not exists _updated_at timestamptz not null default now();
alter table "itsa_noti_notification_log" add column if not exists "ts" text;
alter table "itsa_noti_notification_log" add column if not exists "ch" text;
alter table "itsa_noti_notification_log" add column if not exists "to" text;
alter table "itsa_noti_notification_log" add column if not exists "s" text;
create index if not exists "itsa_noti_notification_log_tenant_seq_idx" on "itsa_noti_notification_log" (_tenant, _seq);

-- ============ ITSA-ORG ============
create table if not exists "itsa_org_business_group" (
  _pk         bigint generated always as identity primary key,
  _tenant     uuid references tenant(id) on delete cascade,
  _seq        integer not null default 0,
  "code" text,
  "bid" text,
  "name_th" text,
  "en" text,
  "bt" text,
  "status" text,
  "createdAt" text,
  "createdBy" text,
  "updatedAt" text,
  "updatedBy" text,
  "rowVersion" text,
  _extra      jsonb not null default '{}'::jsonb,
  _created_at timestamptz not null default now(),
  _updated_at timestamptz not null default now()
);
alter table "itsa_org_business_group" drop column if exists "id";
alter table "itsa_org_business_group" drop column if exists "tenant_id";
alter table "itsa_org_business_group" drop column if exists "seq";
alter table "itsa_org_business_group" drop column if exists "extra";
alter table "itsa_org_business_group" drop column if exists "created_at";
alter table "itsa_org_business_group" drop column if exists "updated_at";
alter table "itsa_org_business_group" add column if not exists _pk bigint generated always as identity;
alter table "itsa_org_business_group" add column if not exists _tenant uuid references tenant(id) on delete cascade;
alter table "itsa_org_business_group" add column if not exists _seq integer not null default 0;
alter table "itsa_org_business_group" add column if not exists _extra jsonb not null default '{}'::jsonb;
alter table "itsa_org_business_group" add column if not exists _created_at timestamptz not null default now();
alter table "itsa_org_business_group" add column if not exists _updated_at timestamptz not null default now();
alter table "itsa_org_business_group" add column if not exists "code" text;
alter table "itsa_org_business_group" add column if not exists "bid" text;
alter table "itsa_org_business_group" add column if not exists "name_th" text;
alter table "itsa_org_business_group" add column if not exists "en" text;
alter table "itsa_org_business_group" add column if not exists "bt" text;
alter table "itsa_org_business_group" add column if not exists "status" text;
alter table "itsa_org_business_group" add column if not exists "createdAt" text;
alter table "itsa_org_business_group" add column if not exists "createdBy" text;
alter table "itsa_org_business_group" add column if not exists "updatedAt" text;
alter table "itsa_org_business_group" add column if not exists "updatedBy" text;
alter table "itsa_org_business_group" add column if not exists "rowVersion" text;
create index if not exists "itsa_org_business_group_tenant_seq_idx" on "itsa_org_business_group" (_tenant, _seq);
create table if not exists "itsa_org_company" (
  _pk         bigint generated always as identity primary key,
  _tenant     uuid references tenant(id) on delete cascade,
  _seq        integer not null default 0,
  "code" text,
  "tax_id" text,
  _extra      jsonb not null default '{}'::jsonb,
  _created_at timestamptz not null default now(),
  _updated_at timestamptz not null default now()
);
alter table "itsa_org_company" drop column if exists "id";
alter table "itsa_org_company" drop column if exists "tenant_id";
alter table "itsa_org_company" drop column if exists "seq";
alter table "itsa_org_company" drop column if exists "extra";
alter table "itsa_org_company" drop column if exists "created_at";
alter table "itsa_org_company" drop column if exists "updated_at";
alter table "itsa_org_company" add column if not exists _pk bigint generated always as identity;
alter table "itsa_org_company" add column if not exists _tenant uuid references tenant(id) on delete cascade;
alter table "itsa_org_company" add column if not exists _seq integer not null default 0;
alter table "itsa_org_company" add column if not exists _extra jsonb not null default '{}'::jsonb;
alter table "itsa_org_company" add column if not exists _created_at timestamptz not null default now();
alter table "itsa_org_company" add column if not exists _updated_at timestamptz not null default now();
alter table "itsa_org_company" add column if not exists "code" text;
alter table "itsa_org_company" add column if not exists "tax_id" text;
create index if not exists "itsa_org_company_tenant_seq_idx" on "itsa_org_company" (_tenant, _seq);
create table if not exists "itsa_org_branch" (
  _pk         bigint generated always as identity primary key,
  _tenant     uuid references tenant(id) on delete cascade,
  _seq        integer not null default 0,
  "code" text,
  "name_th" text,
  "scope_company" text,
  _extra      jsonb not null default '{}'::jsonb,
  _created_at timestamptz not null default now(),
  _updated_at timestamptz not null default now()
);
alter table "itsa_org_branch" drop column if exists "id";
alter table "itsa_org_branch" drop column if exists "tenant_id";
alter table "itsa_org_branch" drop column if exists "seq";
alter table "itsa_org_branch" drop column if exists "extra";
alter table "itsa_org_branch" drop column if exists "created_at";
alter table "itsa_org_branch" drop column if exists "updated_at";
alter table "itsa_org_branch" add column if not exists _pk bigint generated always as identity;
alter table "itsa_org_branch" add column if not exists _tenant uuid references tenant(id) on delete cascade;
alter table "itsa_org_branch" add column if not exists _seq integer not null default 0;
alter table "itsa_org_branch" add column if not exists _extra jsonb not null default '{}'::jsonb;
alter table "itsa_org_branch" add column if not exists _created_at timestamptz not null default now();
alter table "itsa_org_branch" add column if not exists _updated_at timestamptz not null default now();
alter table "itsa_org_branch" add column if not exists "code" text;
alter table "itsa_org_branch" add column if not exists "name_th" text;
alter table "itsa_org_branch" add column if not exists "scope_company" text;
create index if not exists "itsa_org_branch_tenant_seq_idx" on "itsa_org_branch" (_tenant, _seq);
create table if not exists "itsa_org_division" (
  _pk         bigint generated always as identity primary key,
  _tenant     uuid references tenant(id) on delete cascade,
  _seq        integer not null default 0,
  "code" text,
  "name_th" text,
  "scope_company" text,
  "parent_branch" text,
  "manager" text,
  "dcnt" text,
  "cnt" text,
  _extra      jsonb not null default '{}'::jsonb,
  _created_at timestamptz not null default now(),
  _updated_at timestamptz not null default now()
);
alter table "itsa_org_division" drop column if exists "id";
alter table "itsa_org_division" drop column if exists "tenant_id";
alter table "itsa_org_division" drop column if exists "seq";
alter table "itsa_org_division" drop column if exists "extra";
alter table "itsa_org_division" drop column if exists "created_at";
alter table "itsa_org_division" drop column if exists "updated_at";
alter table "itsa_org_division" add column if not exists _pk bigint generated always as identity;
alter table "itsa_org_division" add column if not exists _tenant uuid references tenant(id) on delete cascade;
alter table "itsa_org_division" add column if not exists _seq integer not null default 0;
alter table "itsa_org_division" add column if not exists _extra jsonb not null default '{}'::jsonb;
alter table "itsa_org_division" add column if not exists _created_at timestamptz not null default now();
alter table "itsa_org_division" add column if not exists _updated_at timestamptz not null default now();
alter table "itsa_org_division" add column if not exists "code" text;
alter table "itsa_org_division" add column if not exists "name_th" text;
alter table "itsa_org_division" add column if not exists "scope_company" text;
alter table "itsa_org_division" add column if not exists "parent_branch" text;
alter table "itsa_org_division" add column if not exists "manager" text;
alter table "itsa_org_division" add column if not exists "dcnt" text;
alter table "itsa_org_division" add column if not exists "cnt" text;
create index if not exists "itsa_org_division_tenant_seq_idx" on "itsa_org_division" (_tenant, _seq);
create table if not exists "itsa_org_department" (
  _pk         bigint generated always as identity primary key,
  _tenant     uuid references tenant(id) on delete cascade,
  _seq        integer not null default 0,
  "code" text,
  "name_th" text,
  "scope_company" text,
  "parent_branch" text,
  "division" text,
  "manager" text,
  "cost_center" text,
  "cnt" text,
  _extra      jsonb not null default '{}'::jsonb,
  _created_at timestamptz not null default now(),
  _updated_at timestamptz not null default now()
);
alter table "itsa_org_department" drop column if exists "id";
alter table "itsa_org_department" drop column if exists "tenant_id";
alter table "itsa_org_department" drop column if exists "seq";
alter table "itsa_org_department" drop column if exists "extra";
alter table "itsa_org_department" drop column if exists "created_at";
alter table "itsa_org_department" drop column if exists "updated_at";
alter table "itsa_org_department" add column if not exists _pk bigint generated always as identity;
alter table "itsa_org_department" add column if not exists _tenant uuid references tenant(id) on delete cascade;
alter table "itsa_org_department" add column if not exists _seq integer not null default 0;
alter table "itsa_org_department" add column if not exists _extra jsonb not null default '{}'::jsonb;
alter table "itsa_org_department" add column if not exists _created_at timestamptz not null default now();
alter table "itsa_org_department" add column if not exists _updated_at timestamptz not null default now();
alter table "itsa_org_department" add column if not exists "code" text;
alter table "itsa_org_department" add column if not exists "name_th" text;
alter table "itsa_org_department" add column if not exists "scope_company" text;
alter table "itsa_org_department" add column if not exists "parent_branch" text;
alter table "itsa_org_department" add column if not exists "division" text;
alter table "itsa_org_department" add column if not exists "manager" text;
alter table "itsa_org_department" add column if not exists "cost_center" text;
alter table "itsa_org_department" add column if not exists "cnt" text;
create index if not exists "itsa_org_department_tenant_seq_idx" on "itsa_org_department" (_tenant, _seq);
create table if not exists "itsa_org_position" (
  _pk         bigint generated always as identity primary key,
  _tenant     uuid references tenant(id) on delete cascade,
  _seq        integer not null default 0,
  "code" text,
  "name_th" text,
  "scope_company" text,
  "parent_branch" text,
  "division" text,
  "department" text,
  "rep" text,
  "cnt" text,
  _extra      jsonb not null default '{}'::jsonb,
  _created_at timestamptz not null default now(),
  _updated_at timestamptz not null default now()
);
alter table "itsa_org_position" drop column if exists "id";
alter table "itsa_org_position" drop column if exists "tenant_id";
alter table "itsa_org_position" drop column if exists "seq";
alter table "itsa_org_position" drop column if exists "extra";
alter table "itsa_org_position" drop column if exists "created_at";
alter table "itsa_org_position" drop column if exists "updated_at";
alter table "itsa_org_position" add column if not exists _pk bigint generated always as identity;
alter table "itsa_org_position" add column if not exists _tenant uuid references tenant(id) on delete cascade;
alter table "itsa_org_position" add column if not exists _seq integer not null default 0;
alter table "itsa_org_position" add column if not exists _extra jsonb not null default '{}'::jsonb;
alter table "itsa_org_position" add column if not exists _created_at timestamptz not null default now();
alter table "itsa_org_position" add column if not exists _updated_at timestamptz not null default now();
alter table "itsa_org_position" add column if not exists "code" text;
alter table "itsa_org_position" add column if not exists "name_th" text;
alter table "itsa_org_position" add column if not exists "scope_company" text;
alter table "itsa_org_position" add column if not exists "parent_branch" text;
alter table "itsa_org_position" add column if not exists "division" text;
alter table "itsa_org_position" add column if not exists "department" text;
alter table "itsa_org_position" add column if not exists "rep" text;
alter table "itsa_org_position" add column if not exists "cnt" text;
create index if not exists "itsa_org_position_tenant_seq_idx" on "itsa_org_position" (_tenant, _seq);

-- ============ ITSA-RPTA ============
create table if not exists "itsa_rpta_system_reports" (
  _pk         bigint generated always as identity primary key,
  _tenant     uuid references tenant(id) on delete cascade,
  _seq        integer not null default 0,
  "no" text,
  "a" text,
  "module" text,
  "ts" text,
  "by" text,
  _extra      jsonb not null default '{}'::jsonb,
  _created_at timestamptz not null default now(),
  _updated_at timestamptz not null default now()
);
alter table "itsa_rpta_system_reports" drop column if exists "id";
alter table "itsa_rpta_system_reports" drop column if exists "tenant_id";
alter table "itsa_rpta_system_reports" drop column if exists "seq";
alter table "itsa_rpta_system_reports" drop column if exists "extra";
alter table "itsa_rpta_system_reports" drop column if exists "created_at";
alter table "itsa_rpta_system_reports" drop column if exists "updated_at";
alter table "itsa_rpta_system_reports" add column if not exists _pk bigint generated always as identity;
alter table "itsa_rpta_system_reports" add column if not exists _tenant uuid references tenant(id) on delete cascade;
alter table "itsa_rpta_system_reports" add column if not exists _seq integer not null default 0;
alter table "itsa_rpta_system_reports" add column if not exists _extra jsonb not null default '{}'::jsonb;
alter table "itsa_rpta_system_reports" add column if not exists _created_at timestamptz not null default now();
alter table "itsa_rpta_system_reports" add column if not exists _updated_at timestamptz not null default now();
alter table "itsa_rpta_system_reports" add column if not exists "no" text;
alter table "itsa_rpta_system_reports" add column if not exists "a" text;
alter table "itsa_rpta_system_reports" add column if not exists "module" text;
alter table "itsa_rpta_system_reports" add column if not exists "ts" text;
alter table "itsa_rpta_system_reports" add column if not exists "by" text;
create index if not exists "itsa_rpta_system_reports_tenant_seq_idx" on "itsa_rpta_system_reports" (_tenant, _seq);
create table if not exists "itsa_rpta_security_reports" (
  _pk         bigint generated always as identity primary key,
  _tenant     uuid references tenant(id) on delete cascade,
  _seq        integer not null default 0,
  "no" text,
  "a" text,
  "ts" text,
  _extra      jsonb not null default '{}'::jsonb,
  _created_at timestamptz not null default now(),
  _updated_at timestamptz not null default now()
);
alter table "itsa_rpta_security_reports" drop column if exists "id";
alter table "itsa_rpta_security_reports" drop column if exists "tenant_id";
alter table "itsa_rpta_security_reports" drop column if exists "seq";
alter table "itsa_rpta_security_reports" drop column if exists "extra";
alter table "itsa_rpta_security_reports" drop column if exists "created_at";
alter table "itsa_rpta_security_reports" drop column if exists "updated_at";
alter table "itsa_rpta_security_reports" add column if not exists _pk bigint generated always as identity;
alter table "itsa_rpta_security_reports" add column if not exists _tenant uuid references tenant(id) on delete cascade;
alter table "itsa_rpta_security_reports" add column if not exists _seq integer not null default 0;
alter table "itsa_rpta_security_reports" add column if not exists _extra jsonb not null default '{}'::jsonb;
alter table "itsa_rpta_security_reports" add column if not exists _created_at timestamptz not null default now();
alter table "itsa_rpta_security_reports" add column if not exists _updated_at timestamptz not null default now();
alter table "itsa_rpta_security_reports" add column if not exists "no" text;
alter table "itsa_rpta_security_reports" add column if not exists "a" text;
alter table "itsa_rpta_security_reports" add column if not exists "ts" text;
create index if not exists "itsa_rpta_security_reports_tenant_seq_idx" on "itsa_rpta_security_reports" (_tenant, _seq);
create table if not exists "itsa_rpta_audit_reports" (
  _pk         bigint generated always as identity primary key,
  _tenant     uuid references tenant(id) on delete cascade,
  _seq        integer not null default 0,
  "no" text,
  "a" text,
  "ts" text,
  _extra      jsonb not null default '{}'::jsonb,
  _created_at timestamptz not null default now(),
  _updated_at timestamptz not null default now()
);
alter table "itsa_rpta_audit_reports" drop column if exists "id";
alter table "itsa_rpta_audit_reports" drop column if exists "tenant_id";
alter table "itsa_rpta_audit_reports" drop column if exists "seq";
alter table "itsa_rpta_audit_reports" drop column if exists "extra";
alter table "itsa_rpta_audit_reports" drop column if exists "created_at";
alter table "itsa_rpta_audit_reports" drop column if exists "updated_at";
alter table "itsa_rpta_audit_reports" add column if not exists _pk bigint generated always as identity;
alter table "itsa_rpta_audit_reports" add column if not exists _tenant uuid references tenant(id) on delete cascade;
alter table "itsa_rpta_audit_reports" add column if not exists _seq integer not null default 0;
alter table "itsa_rpta_audit_reports" add column if not exists _extra jsonb not null default '{}'::jsonb;
alter table "itsa_rpta_audit_reports" add column if not exists _created_at timestamptz not null default now();
alter table "itsa_rpta_audit_reports" add column if not exists _updated_at timestamptz not null default now();
alter table "itsa_rpta_audit_reports" add column if not exists "no" text;
alter table "itsa_rpta_audit_reports" add column if not exists "a" text;
alter table "itsa_rpta_audit_reports" add column if not exists "ts" text;
create index if not exists "itsa_rpta_audit_reports_tenant_seq_idx" on "itsa_rpta_audit_reports" (_tenant, _seq);
create table if not exists "itsa_rpta_usage_reports" (
  _pk         bigint generated always as identity primary key,
  _tenant     uuid references tenant(id) on delete cascade,
  _seq        integer not null default 0,
  "no" text,
  "a" text,
  "ts" text,
  _extra      jsonb not null default '{}'::jsonb,
  _created_at timestamptz not null default now(),
  _updated_at timestamptz not null default now()
);
alter table "itsa_rpta_usage_reports" drop column if exists "id";
alter table "itsa_rpta_usage_reports" drop column if exists "tenant_id";
alter table "itsa_rpta_usage_reports" drop column if exists "seq";
alter table "itsa_rpta_usage_reports" drop column if exists "extra";
alter table "itsa_rpta_usage_reports" drop column if exists "created_at";
alter table "itsa_rpta_usage_reports" drop column if exists "updated_at";
alter table "itsa_rpta_usage_reports" add column if not exists _pk bigint generated always as identity;
alter table "itsa_rpta_usage_reports" add column if not exists _tenant uuid references tenant(id) on delete cascade;
alter table "itsa_rpta_usage_reports" add column if not exists _seq integer not null default 0;
alter table "itsa_rpta_usage_reports" add column if not exists _extra jsonb not null default '{}'::jsonb;
alter table "itsa_rpta_usage_reports" add column if not exists _created_at timestamptz not null default now();
alter table "itsa_rpta_usage_reports" add column if not exists _updated_at timestamptz not null default now();
alter table "itsa_rpta_usage_reports" add column if not exists "no" text;
alter table "itsa_rpta_usage_reports" add column if not exists "a" text;
alter table "itsa_rpta_usage_reports" add column if not exists "ts" text;
create index if not exists "itsa_rpta_usage_reports_tenant_seq_idx" on "itsa_rpta_usage_reports" (_tenant, _seq);
create table if not exists "itsa_rpta_custom_report" (
  _pk         bigint generated always as identity primary key,
  _tenant     uuid references tenant(id) on delete cascade,
  _seq        integer not null default 0,
  "no" text,
  "a" text,
  "ts" text,
  _extra      jsonb not null default '{}'::jsonb,
  _created_at timestamptz not null default now(),
  _updated_at timestamptz not null default now()
);
alter table "itsa_rpta_custom_report" drop column if exists "id";
alter table "itsa_rpta_custom_report" drop column if exists "tenant_id";
alter table "itsa_rpta_custom_report" drop column if exists "seq";
alter table "itsa_rpta_custom_report" drop column if exists "extra";
alter table "itsa_rpta_custom_report" drop column if exists "created_at";
alter table "itsa_rpta_custom_report" drop column if exists "updated_at";
alter table "itsa_rpta_custom_report" add column if not exists _pk bigint generated always as identity;
alter table "itsa_rpta_custom_report" add column if not exists _tenant uuid references tenant(id) on delete cascade;
alter table "itsa_rpta_custom_report" add column if not exists _seq integer not null default 0;
alter table "itsa_rpta_custom_report" add column if not exists _extra jsonb not null default '{}'::jsonb;
alter table "itsa_rpta_custom_report" add column if not exists _created_at timestamptz not null default now();
alter table "itsa_rpta_custom_report" add column if not exists _updated_at timestamptz not null default now();
alter table "itsa_rpta_custom_report" add column if not exists "no" text;
alter table "itsa_rpta_custom_report" add column if not exists "a" text;
alter table "itsa_rpta_custom_report" add column if not exists "ts" text;
create index if not exists "itsa_rpta_custom_report_tenant_seq_idx" on "itsa_rpta_custom_report" (_tenant, _seq);

-- ============ ITSA-RPTD ============
create table if not exists "itsa_rptd_report" (
  _pk         bigint generated always as identity primary key,
  _tenant     uuid references tenant(id) on delete cascade,
  _seq        integer not null default 0,
  "no" text,
  "a" text,
  "fmt" text,
  "mod" text,
  "s" text,
  _extra      jsonb not null default '{}'::jsonb,
  _created_at timestamptz not null default now(),
  _updated_at timestamptz not null default now()
);
alter table "itsa_rptd_report" drop column if exists "id";
alter table "itsa_rptd_report" drop column if exists "tenant_id";
alter table "itsa_rptd_report" drop column if exists "seq";
alter table "itsa_rptd_report" drop column if exists "extra";
alter table "itsa_rptd_report" drop column if exists "created_at";
alter table "itsa_rptd_report" drop column if exists "updated_at";
alter table "itsa_rptd_report" add column if not exists _pk bigint generated always as identity;
alter table "itsa_rptd_report" add column if not exists _tenant uuid references tenant(id) on delete cascade;
alter table "itsa_rptd_report" add column if not exists _seq integer not null default 0;
alter table "itsa_rptd_report" add column if not exists _extra jsonb not null default '{}'::jsonb;
alter table "itsa_rptd_report" add column if not exists _created_at timestamptz not null default now();
alter table "itsa_rptd_report" add column if not exists _updated_at timestamptz not null default now();
alter table "itsa_rptd_report" add column if not exists "no" text;
alter table "itsa_rptd_report" add column if not exists "a" text;
alter table "itsa_rptd_report" add column if not exists "fmt" text;
alter table "itsa_rptd_report" add column if not exists "mod" text;
alter table "itsa_rptd_report" add column if not exists "s" text;
create index if not exists "itsa_rptd_report_tenant_seq_idx" on "itsa_rptd_report" (_tenant, _seq);
create table if not exists "itsa_rptd_dataset_designer" (
  _pk         bigint generated always as identity primary key,
  _tenant     uuid references tenant(id) on delete cascade,
  _seq        integer not null default 0,
  "a" text,
  "d" text,
  "s" text,
  _extra      jsonb not null default '{}'::jsonb,
  _created_at timestamptz not null default now(),
  _updated_at timestamptz not null default now()
);
alter table "itsa_rptd_dataset_designer" drop column if exists "id";
alter table "itsa_rptd_dataset_designer" drop column if exists "tenant_id";
alter table "itsa_rptd_dataset_designer" drop column if exists "seq";
alter table "itsa_rptd_dataset_designer" drop column if exists "extra";
alter table "itsa_rptd_dataset_designer" drop column if exists "created_at";
alter table "itsa_rptd_dataset_designer" drop column if exists "updated_at";
alter table "itsa_rptd_dataset_designer" add column if not exists _pk bigint generated always as identity;
alter table "itsa_rptd_dataset_designer" add column if not exists _tenant uuid references tenant(id) on delete cascade;
alter table "itsa_rptd_dataset_designer" add column if not exists _seq integer not null default 0;
alter table "itsa_rptd_dataset_designer" add column if not exists _extra jsonb not null default '{}'::jsonb;
alter table "itsa_rptd_dataset_designer" add column if not exists _created_at timestamptz not null default now();
alter table "itsa_rptd_dataset_designer" add column if not exists _updated_at timestamptz not null default now();
alter table "itsa_rptd_dataset_designer" add column if not exists "a" text;
alter table "itsa_rptd_dataset_designer" add column if not exists "d" text;
alter table "itsa_rptd_dataset_designer" add column if not exists "s" text;
create index if not exists "itsa_rptd_dataset_designer_tenant_seq_idx" on "itsa_rptd_dataset_designer" (_tenant, _seq);
create table if not exists "itsa_rptd_query_builder" (
  _pk         bigint generated always as identity primary key,
  _tenant     uuid references tenant(id) on delete cascade,
  _seq        integer not null default 0,
  "a" text,
  "d" text,
  "s" text,
  _extra      jsonb not null default '{}'::jsonb,
  _created_at timestamptz not null default now(),
  _updated_at timestamptz not null default now()
);
alter table "itsa_rptd_query_builder" drop column if exists "id";
alter table "itsa_rptd_query_builder" drop column if exists "tenant_id";
alter table "itsa_rptd_query_builder" drop column if exists "seq";
alter table "itsa_rptd_query_builder" drop column if exists "extra";
alter table "itsa_rptd_query_builder" drop column if exists "created_at";
alter table "itsa_rptd_query_builder" drop column if exists "updated_at";
alter table "itsa_rptd_query_builder" add column if not exists _pk bigint generated always as identity;
alter table "itsa_rptd_query_builder" add column if not exists _tenant uuid references tenant(id) on delete cascade;
alter table "itsa_rptd_query_builder" add column if not exists _seq integer not null default 0;
alter table "itsa_rptd_query_builder" add column if not exists _extra jsonb not null default '{}'::jsonb;
alter table "itsa_rptd_query_builder" add column if not exists _created_at timestamptz not null default now();
alter table "itsa_rptd_query_builder" add column if not exists _updated_at timestamptz not null default now();
alter table "itsa_rptd_query_builder" add column if not exists "a" text;
alter table "itsa_rptd_query_builder" add column if not exists "d" text;
alter table "itsa_rptd_query_builder" add column if not exists "s" text;
create index if not exists "itsa_rptd_query_builder_tenant_seq_idx" on "itsa_rptd_query_builder" (_tenant, _seq);
create table if not exists "itsa_rptd_report_layout" (
  _pk         bigint generated always as identity primary key,
  _tenant     uuid references tenant(id) on delete cascade,
  _seq        integer not null default 0,
  "a" text,
  "d" text,
  "s" text,
  _extra      jsonb not null default '{}'::jsonb,
  _created_at timestamptz not null default now(),
  _updated_at timestamptz not null default now()
);
alter table "itsa_rptd_report_layout" drop column if exists "id";
alter table "itsa_rptd_report_layout" drop column if exists "tenant_id";
alter table "itsa_rptd_report_layout" drop column if exists "seq";
alter table "itsa_rptd_report_layout" drop column if exists "extra";
alter table "itsa_rptd_report_layout" drop column if exists "created_at";
alter table "itsa_rptd_report_layout" drop column if exists "updated_at";
alter table "itsa_rptd_report_layout" add column if not exists _pk bigint generated always as identity;
alter table "itsa_rptd_report_layout" add column if not exists _tenant uuid references tenant(id) on delete cascade;
alter table "itsa_rptd_report_layout" add column if not exists _seq integer not null default 0;
alter table "itsa_rptd_report_layout" add column if not exists _extra jsonb not null default '{}'::jsonb;
alter table "itsa_rptd_report_layout" add column if not exists _created_at timestamptz not null default now();
alter table "itsa_rptd_report_layout" add column if not exists _updated_at timestamptz not null default now();
alter table "itsa_rptd_report_layout" add column if not exists "a" text;
alter table "itsa_rptd_report_layout" add column if not exists "d" text;
alter table "itsa_rptd_report_layout" add column if not exists "s" text;
create index if not exists "itsa_rptd_report_layout_tenant_seq_idx" on "itsa_rptd_report_layout" (_tenant, _seq);
create table if not exists "itsa_rptd_chart_designer" (
  _pk         bigint generated always as identity primary key,
  _tenant     uuid references tenant(id) on delete cascade,
  _seq        integer not null default 0,
  "a" text,
  "d" text,
  "s" text,
  _extra      jsonb not null default '{}'::jsonb,
  _created_at timestamptz not null default now(),
  _updated_at timestamptz not null default now()
);
alter table "itsa_rptd_chart_designer" drop column if exists "id";
alter table "itsa_rptd_chart_designer" drop column if exists "tenant_id";
alter table "itsa_rptd_chart_designer" drop column if exists "seq";
alter table "itsa_rptd_chart_designer" drop column if exists "extra";
alter table "itsa_rptd_chart_designer" drop column if exists "created_at";
alter table "itsa_rptd_chart_designer" drop column if exists "updated_at";
alter table "itsa_rptd_chart_designer" add column if not exists _pk bigint generated always as identity;
alter table "itsa_rptd_chart_designer" add column if not exists _tenant uuid references tenant(id) on delete cascade;
alter table "itsa_rptd_chart_designer" add column if not exists _seq integer not null default 0;
alter table "itsa_rptd_chart_designer" add column if not exists _extra jsonb not null default '{}'::jsonb;
alter table "itsa_rptd_chart_designer" add column if not exists _created_at timestamptz not null default now();
alter table "itsa_rptd_chart_designer" add column if not exists _updated_at timestamptz not null default now();
alter table "itsa_rptd_chart_designer" add column if not exists "a" text;
alter table "itsa_rptd_chart_designer" add column if not exists "d" text;
alter table "itsa_rptd_chart_designer" add column if not exists "s" text;
create index if not exists "itsa_rptd_chart_designer_tenant_seq_idx" on "itsa_rptd_chart_designer" (_tenant, _seq);
create table if not exists "itsa_rptd_print_layout" (
  _pk         bigint generated always as identity primary key,
  _tenant     uuid references tenant(id) on delete cascade,
  _seq        integer not null default 0,
  "a" text,
  "d" text,
  "s" text,
  _extra      jsonb not null default '{}'::jsonb,
  _created_at timestamptz not null default now(),
  _updated_at timestamptz not null default now()
);
alter table "itsa_rptd_print_layout" drop column if exists "id";
alter table "itsa_rptd_print_layout" drop column if exists "tenant_id";
alter table "itsa_rptd_print_layout" drop column if exists "seq";
alter table "itsa_rptd_print_layout" drop column if exists "extra";
alter table "itsa_rptd_print_layout" drop column if exists "created_at";
alter table "itsa_rptd_print_layout" drop column if exists "updated_at";
alter table "itsa_rptd_print_layout" add column if not exists _pk bigint generated always as identity;
alter table "itsa_rptd_print_layout" add column if not exists _tenant uuid references tenant(id) on delete cascade;
alter table "itsa_rptd_print_layout" add column if not exists _seq integer not null default 0;
alter table "itsa_rptd_print_layout" add column if not exists _extra jsonb not null default '{}'::jsonb;
alter table "itsa_rptd_print_layout" add column if not exists _created_at timestamptz not null default now();
alter table "itsa_rptd_print_layout" add column if not exists _updated_at timestamptz not null default now();
alter table "itsa_rptd_print_layout" add column if not exists "a" text;
alter table "itsa_rptd_print_layout" add column if not exists "d" text;
alter table "itsa_rptd_print_layout" add column if not exists "s" text;
create index if not exists "itsa_rptd_print_layout_tenant_seq_idx" on "itsa_rptd_print_layout" (_tenant, _seq);
create table if not exists "itsa_rptd_report_version" (
  _pk         bigint generated always as identity primary key,
  _tenant     uuid references tenant(id) on delete cascade,
  _seq        integer not null default 0,
  "a" text,
  "d" text,
  "ts" text,
  _extra      jsonb not null default '{}'::jsonb,
  _created_at timestamptz not null default now(),
  _updated_at timestamptz not null default now()
);
alter table "itsa_rptd_report_version" drop column if exists "id";
alter table "itsa_rptd_report_version" drop column if exists "tenant_id";
alter table "itsa_rptd_report_version" drop column if exists "seq";
alter table "itsa_rptd_report_version" drop column if exists "extra";
alter table "itsa_rptd_report_version" drop column if exists "created_at";
alter table "itsa_rptd_report_version" drop column if exists "updated_at";
alter table "itsa_rptd_report_version" add column if not exists _pk bigint generated always as identity;
alter table "itsa_rptd_report_version" add column if not exists _tenant uuid references tenant(id) on delete cascade;
alter table "itsa_rptd_report_version" add column if not exists _seq integer not null default 0;
alter table "itsa_rptd_report_version" add column if not exists _extra jsonb not null default '{}'::jsonb;
alter table "itsa_rptd_report_version" add column if not exists _created_at timestamptz not null default now();
alter table "itsa_rptd_report_version" add column if not exists _updated_at timestamptz not null default now();
alter table "itsa_rptd_report_version" add column if not exists "a" text;
alter table "itsa_rptd_report_version" add column if not exists "d" text;
alter table "itsa_rptd_report_version" add column if not exists "ts" text;
create index if not exists "itsa_rptd_report_version_tenant_seq_idx" on "itsa_rptd_report_version" (_tenant, _seq);
create table if not exists "itsa_rptd_report_template" (
  _pk         bigint generated always as identity primary key,
  _tenant     uuid references tenant(id) on delete cascade,
  _seq        integer not null default 0,
  "a" text,
  "d" text,
  "s" text,
  _extra      jsonb not null default '{}'::jsonb,
  _created_at timestamptz not null default now(),
  _updated_at timestamptz not null default now()
);
alter table "itsa_rptd_report_template" drop column if exists "id";
alter table "itsa_rptd_report_template" drop column if exists "tenant_id";
alter table "itsa_rptd_report_template" drop column if exists "seq";
alter table "itsa_rptd_report_template" drop column if exists "extra";
alter table "itsa_rptd_report_template" drop column if exists "created_at";
alter table "itsa_rptd_report_template" drop column if exists "updated_at";
alter table "itsa_rptd_report_template" add column if not exists _pk bigint generated always as identity;
alter table "itsa_rptd_report_template" add column if not exists _tenant uuid references tenant(id) on delete cascade;
alter table "itsa_rptd_report_template" add column if not exists _seq integer not null default 0;
alter table "itsa_rptd_report_template" add column if not exists _extra jsonb not null default '{}'::jsonb;
alter table "itsa_rptd_report_template" add column if not exists _created_at timestamptz not null default now();
alter table "itsa_rptd_report_template" add column if not exists _updated_at timestamptz not null default now();
alter table "itsa_rptd_report_template" add column if not exists "a" text;
alter table "itsa_rptd_report_template" add column if not exists "d" text;
alter table "itsa_rptd_report_template" add column if not exists "s" text;
create index if not exists "itsa_rptd_report_template_tenant_seq_idx" on "itsa_rptd_report_template" (_tenant, _seq);

-- ============ ITSA-TENT ============
create table if not exists "itsa_tent_management" (
  _pk         bigint generated always as identity primary key,
  _tenant     uuid references tenant(id) on delete cascade,
  _seq        integer not null default 0,
  "code" text,
  "name_th" text,
  "name_en" text,
  "seats" text,
  "domain" text,
  _extra      jsonb not null default '{}'::jsonb,
  _created_at timestamptz not null default now(),
  _updated_at timestamptz not null default now()
);
alter table "itsa_tent_management" drop column if exists "id";
alter table "itsa_tent_management" drop column if exists "tenant_id";
alter table "itsa_tent_management" drop column if exists "seq";
alter table "itsa_tent_management" drop column if exists "extra";
alter table "itsa_tent_management" drop column if exists "created_at";
alter table "itsa_tent_management" drop column if exists "updated_at";
alter table "itsa_tent_management" add column if not exists _pk bigint generated always as identity;
alter table "itsa_tent_management" add column if not exists _tenant uuid references tenant(id) on delete cascade;
alter table "itsa_tent_management" add column if not exists _seq integer not null default 0;
alter table "itsa_tent_management" add column if not exists _extra jsonb not null default '{}'::jsonb;
alter table "itsa_tent_management" add column if not exists _created_at timestamptz not null default now();
alter table "itsa_tent_management" add column if not exists _updated_at timestamptz not null default now();
alter table "itsa_tent_management" add column if not exists "code" text;
alter table "itsa_tent_management" add column if not exists "name_th" text;
alter table "itsa_tent_management" add column if not exists "name_en" text;
alter table "itsa_tent_management" add column if not exists "seats" text;
alter table "itsa_tent_management" add column if not exists "domain" text;
create index if not exists "itsa_tent_management_tenant_seq_idx" on "itsa_tent_management" (_tenant, _seq);
create table if not exists "itsa_tent_provisioning" (
  _pk         bigint generated always as identity primary key,
  _tenant     uuid references tenant(id) on delete cascade,
  _seq        integer not null default 0,
  "code" text,
  "name_th" text,
  "plan" text,
  _extra      jsonb not null default '{}'::jsonb,
  _created_at timestamptz not null default now(),
  _updated_at timestamptz not null default now()
);
alter table "itsa_tent_provisioning" drop column if exists "id";
alter table "itsa_tent_provisioning" drop column if exists "tenant_id";
alter table "itsa_tent_provisioning" drop column if exists "seq";
alter table "itsa_tent_provisioning" drop column if exists "extra";
alter table "itsa_tent_provisioning" drop column if exists "created_at";
alter table "itsa_tent_provisioning" drop column if exists "updated_at";
alter table "itsa_tent_provisioning" add column if not exists _pk bigint generated always as identity;
alter table "itsa_tent_provisioning" add column if not exists _tenant uuid references tenant(id) on delete cascade;
alter table "itsa_tent_provisioning" add column if not exists _seq integer not null default 0;
alter table "itsa_tent_provisioning" add column if not exists _extra jsonb not null default '{}'::jsonb;
alter table "itsa_tent_provisioning" add column if not exists _created_at timestamptz not null default now();
alter table "itsa_tent_provisioning" add column if not exists _updated_at timestamptz not null default now();
alter table "itsa_tent_provisioning" add column if not exists "code" text;
alter table "itsa_tent_provisioning" add column if not exists "name_th" text;
alter table "itsa_tent_provisioning" add column if not exists "plan" text;
create index if not exists "itsa_tent_provisioning_tenant_seq_idx" on "itsa_tent_provisioning" (_tenant, _seq);
create table if not exists "itsa_tent_subscription_plan" (
  _pk         bigint generated always as identity primary key,
  _tenant     uuid references tenant(id) on delete cascade,
  _seq        integer not null default 0,
  "plan_code" text,
  "name_th" text,
  "name_en" text,
  "seats" text,
  "price" numeric,
  "cnt" text,
  "status" text,
  _extra      jsonb not null default '{}'::jsonb,
  _created_at timestamptz not null default now(),
  _updated_at timestamptz not null default now()
);
alter table "itsa_tent_subscription_plan" drop column if exists "id";
alter table "itsa_tent_subscription_plan" drop column if exists "tenant_id";
alter table "itsa_tent_subscription_plan" drop column if exists "seq";
alter table "itsa_tent_subscription_plan" drop column if exists "extra";
alter table "itsa_tent_subscription_plan" drop column if exists "created_at";
alter table "itsa_tent_subscription_plan" drop column if exists "updated_at";
alter table "itsa_tent_subscription_plan" add column if not exists _pk bigint generated always as identity;
alter table "itsa_tent_subscription_plan" add column if not exists _tenant uuid references tenant(id) on delete cascade;
alter table "itsa_tent_subscription_plan" add column if not exists _seq integer not null default 0;
alter table "itsa_tent_subscription_plan" add column if not exists _extra jsonb not null default '{}'::jsonb;
alter table "itsa_tent_subscription_plan" add column if not exists _created_at timestamptz not null default now();
alter table "itsa_tent_subscription_plan" add column if not exists _updated_at timestamptz not null default now();
alter table "itsa_tent_subscription_plan" add column if not exists "plan_code" text;
alter table "itsa_tent_subscription_plan" add column if not exists "name_th" text;
alter table "itsa_tent_subscription_plan" add column if not exists "name_en" text;
alter table "itsa_tent_subscription_plan" add column if not exists "seats" text;
alter table "itsa_tent_subscription_plan" add column if not exists "price" numeric;
alter table "itsa_tent_subscription_plan" add column if not exists "cnt" text;
alter table "itsa_tent_subscription_plan" add column if not exists "status" text;
create index if not exists "itsa_tent_subscription_plan_tenant_seq_idx" on "itsa_tent_subscription_plan" (_tenant, _seq);
create table if not exists "itsa_tent_configuration" (
  _pk         bigint generated always as identity primary key,
  _tenant     uuid references tenant(id) on delete cascade,
  _seq        integer not null default 0,
  "name_th" text,
  "tz" text,
  "cur" text,
  "lang" text,
  _extra      jsonb not null default '{}'::jsonb,
  _created_at timestamptz not null default now(),
  _updated_at timestamptz not null default now()
);
alter table "itsa_tent_configuration" drop column if exists "id";
alter table "itsa_tent_configuration" drop column if exists "tenant_id";
alter table "itsa_tent_configuration" drop column if exists "seq";
alter table "itsa_tent_configuration" drop column if exists "extra";
alter table "itsa_tent_configuration" drop column if exists "created_at";
alter table "itsa_tent_configuration" drop column if exists "updated_at";
alter table "itsa_tent_configuration" add column if not exists _pk bigint generated always as identity;
alter table "itsa_tent_configuration" add column if not exists _tenant uuid references tenant(id) on delete cascade;
alter table "itsa_tent_configuration" add column if not exists _seq integer not null default 0;
alter table "itsa_tent_configuration" add column if not exists _extra jsonb not null default '{}'::jsonb;
alter table "itsa_tent_configuration" add column if not exists _created_at timestamptz not null default now();
alter table "itsa_tent_configuration" add column if not exists _updated_at timestamptz not null default now();
alter table "itsa_tent_configuration" add column if not exists "name_th" text;
alter table "itsa_tent_configuration" add column if not exists "tz" text;
alter table "itsa_tent_configuration" add column if not exists "cur" text;
alter table "itsa_tent_configuration" add column if not exists "lang" text;
create index if not exists "itsa_tent_configuration_tenant_seq_idx" on "itsa_tent_configuration" (_tenant, _seq);
create table if not exists "itsa_tent_isolation" (
  _pk         bigint generated always as identity primary key,
  _tenant     uuid references tenant(id) on delete cascade,
  _seq        integer not null default 0,
  "name_th" text,
  "mode" text,
  "db" text,
  _extra      jsonb not null default '{}'::jsonb,
  _created_at timestamptz not null default now(),
  _updated_at timestamptz not null default now()
);
alter table "itsa_tent_isolation" drop column if exists "id";
alter table "itsa_tent_isolation" drop column if exists "tenant_id";
alter table "itsa_tent_isolation" drop column if exists "seq";
alter table "itsa_tent_isolation" drop column if exists "extra";
alter table "itsa_tent_isolation" drop column if exists "created_at";
alter table "itsa_tent_isolation" drop column if exists "updated_at";
alter table "itsa_tent_isolation" add column if not exists _pk bigint generated always as identity;
alter table "itsa_tent_isolation" add column if not exists _tenant uuid references tenant(id) on delete cascade;
alter table "itsa_tent_isolation" add column if not exists _seq integer not null default 0;
alter table "itsa_tent_isolation" add column if not exists _extra jsonb not null default '{}'::jsonb;
alter table "itsa_tent_isolation" add column if not exists _created_at timestamptz not null default now();
alter table "itsa_tent_isolation" add column if not exists _updated_at timestamptz not null default now();
alter table "itsa_tent_isolation" add column if not exists "name_th" text;
alter table "itsa_tent_isolation" add column if not exists "mode" text;
alter table "itsa_tent_isolation" add column if not exists "db" text;
create index if not exists "itsa_tent_isolation_tenant_seq_idx" on "itsa_tent_isolation" (_tenant, _seq);
create table if not exists "itsa_tent_billing" (
  _pk         bigint generated always as identity primary key,
  _tenant     uuid references tenant(id) on delete cascade,
  _seq        integer not null default 0,
  "code" text,
  "name_th" text,
  "period" text,
  "amt" numeric,
  _extra      jsonb not null default '{}'::jsonb,
  _created_at timestamptz not null default now(),
  _updated_at timestamptz not null default now()
);
alter table "itsa_tent_billing" drop column if exists "id";
alter table "itsa_tent_billing" drop column if exists "tenant_id";
alter table "itsa_tent_billing" drop column if exists "seq";
alter table "itsa_tent_billing" drop column if exists "extra";
alter table "itsa_tent_billing" drop column if exists "created_at";
alter table "itsa_tent_billing" drop column if exists "updated_at";
alter table "itsa_tent_billing" add column if not exists _pk bigint generated always as identity;
alter table "itsa_tent_billing" add column if not exists _tenant uuid references tenant(id) on delete cascade;
alter table "itsa_tent_billing" add column if not exists _seq integer not null default 0;
alter table "itsa_tent_billing" add column if not exists _extra jsonb not null default '{}'::jsonb;
alter table "itsa_tent_billing" add column if not exists _created_at timestamptz not null default now();
alter table "itsa_tent_billing" add column if not exists _updated_at timestamptz not null default now();
alter table "itsa_tent_billing" add column if not exists "code" text;
alter table "itsa_tent_billing" add column if not exists "name_th" text;
alter table "itsa_tent_billing" add column if not exists "period" text;
alter table "itsa_tent_billing" add column if not exists "amt" numeric;
create index if not exists "itsa_tent_billing_tenant_seq_idx" on "itsa_tent_billing" (_tenant, _seq);
create table if not exists "itsa_tent_monitoring" (
  _pk         bigint generated always as identity primary key,
  _tenant     uuid references tenant(id) on delete cascade,
  _seq        integer not null default 0,
  "name_th" text,
  "cpu" text,
  "stor" text,
  "status" text,
  _extra      jsonb not null default '{}'::jsonb,
  _created_at timestamptz not null default now(),
  _updated_at timestamptz not null default now()
);
alter table "itsa_tent_monitoring" drop column if exists "id";
alter table "itsa_tent_monitoring" drop column if exists "tenant_id";
alter table "itsa_tent_monitoring" drop column if exists "seq";
alter table "itsa_tent_monitoring" drop column if exists "extra";
alter table "itsa_tent_monitoring" drop column if exists "created_at";
alter table "itsa_tent_monitoring" drop column if exists "updated_at";
alter table "itsa_tent_monitoring" add column if not exists _pk bigint generated always as identity;
alter table "itsa_tent_monitoring" add column if not exists _tenant uuid references tenant(id) on delete cascade;
alter table "itsa_tent_monitoring" add column if not exists _seq integer not null default 0;
alter table "itsa_tent_monitoring" add column if not exists _extra jsonb not null default '{}'::jsonb;
alter table "itsa_tent_monitoring" add column if not exists _created_at timestamptz not null default now();
alter table "itsa_tent_monitoring" add column if not exists _updated_at timestamptz not null default now();
alter table "itsa_tent_monitoring" add column if not exists "name_th" text;
alter table "itsa_tent_monitoring" add column if not exists "cpu" text;
alter table "itsa_tent_monitoring" add column if not exists "stor" text;
alter table "itsa_tent_monitoring" add column if not exists "status" text;
create index if not exists "itsa_tent_monitoring_tenant_seq_idx" on "itsa_tent_monitoring" (_tenant, _seq);

-- ============ ITSA-UAM ============
create table if not exists "itsa_uam_user" (
  _pk         bigint generated always as identity primary key,
  _tenant     uuid references tenant(id) on delete cascade,
  _seq        integer not null default 0,
  "no" text,
  "a" text,
  "co" text,
  "br" text,
  "dept" text,
  "email" text,
  "division" text,
  _extra      jsonb not null default '{}'::jsonb,
  _created_at timestamptz not null default now(),
  _updated_at timestamptz not null default now()
);
alter table "itsa_uam_user" drop column if exists "id";
alter table "itsa_uam_user" drop column if exists "tenant_id";
alter table "itsa_uam_user" drop column if exists "seq";
alter table "itsa_uam_user" drop column if exists "extra";
alter table "itsa_uam_user" drop column if exists "created_at";
alter table "itsa_uam_user" drop column if exists "updated_at";
alter table "itsa_uam_user" add column if not exists _pk bigint generated always as identity;
alter table "itsa_uam_user" add column if not exists _tenant uuid references tenant(id) on delete cascade;
alter table "itsa_uam_user" add column if not exists _seq integer not null default 0;
alter table "itsa_uam_user" add column if not exists _extra jsonb not null default '{}'::jsonb;
alter table "itsa_uam_user" add column if not exists _created_at timestamptz not null default now();
alter table "itsa_uam_user" add column if not exists _updated_at timestamptz not null default now();
alter table "itsa_uam_user" add column if not exists "no" text;
alter table "itsa_uam_user" add column if not exists "a" text;
alter table "itsa_uam_user" add column if not exists "co" text;
alter table "itsa_uam_user" add column if not exists "br" text;
alter table "itsa_uam_user" add column if not exists "dept" text;
alter table "itsa_uam_user" add column if not exists "email" text;
alter table "itsa_uam_user" add column if not exists "division" text;
create index if not exists "itsa_uam_user_tenant_seq_idx" on "itsa_uam_user" (_tenant, _seq);
create table if not exists "itsa_uam_role" (
  _pk         bigint generated always as identity primary key,
  _tenant     uuid references tenant(id) on delete cascade,
  _seq        integer not null default 0,
  "no" text,
  "a" text,
  "d" text,
  "cnt" text,
  "s" text,
  _extra      jsonb not null default '{}'::jsonb,
  _created_at timestamptz not null default now(),
  _updated_at timestamptz not null default now()
);
alter table "itsa_uam_role" drop column if exists "id";
alter table "itsa_uam_role" drop column if exists "tenant_id";
alter table "itsa_uam_role" drop column if exists "seq";
alter table "itsa_uam_role" drop column if exists "extra";
alter table "itsa_uam_role" drop column if exists "created_at";
alter table "itsa_uam_role" drop column if exists "updated_at";
alter table "itsa_uam_role" add column if not exists _pk bigint generated always as identity;
alter table "itsa_uam_role" add column if not exists _tenant uuid references tenant(id) on delete cascade;
alter table "itsa_uam_role" add column if not exists _seq integer not null default 0;
alter table "itsa_uam_role" add column if not exists _extra jsonb not null default '{}'::jsonb;
alter table "itsa_uam_role" add column if not exists _created_at timestamptz not null default now();
alter table "itsa_uam_role" add column if not exists _updated_at timestamptz not null default now();
alter table "itsa_uam_role" add column if not exists "no" text;
alter table "itsa_uam_role" add column if not exists "a" text;
alter table "itsa_uam_role" add column if not exists "d" text;
alter table "itsa_uam_role" add column if not exists "cnt" text;
alter table "itsa_uam_role" add column if not exists "s" text;
create index if not exists "itsa_uam_role_tenant_seq_idx" on "itsa_uam_role" (_tenant, _seq);
create table if not exists "itsa_uam_permission" (
  _pk         bigint generated always as identity primary key,
  _tenant     uuid references tenant(id) on delete cascade,
  _seq        integer not null default 0,
  "no" text,
  "a" text,
  "d" text,
  "role" text,
  _extra      jsonb not null default '{}'::jsonb,
  _created_at timestamptz not null default now(),
  _updated_at timestamptz not null default now()
);
alter table "itsa_uam_permission" drop column if exists "id";
alter table "itsa_uam_permission" drop column if exists "tenant_id";
alter table "itsa_uam_permission" drop column if exists "seq";
alter table "itsa_uam_permission" drop column if exists "extra";
alter table "itsa_uam_permission" drop column if exists "created_at";
alter table "itsa_uam_permission" drop column if exists "updated_at";
alter table "itsa_uam_permission" add column if not exists _pk bigint generated always as identity;
alter table "itsa_uam_permission" add column if not exists _tenant uuid references tenant(id) on delete cascade;
alter table "itsa_uam_permission" add column if not exists _seq integer not null default 0;
alter table "itsa_uam_permission" add column if not exists _extra jsonb not null default '{}'::jsonb;
alter table "itsa_uam_permission" add column if not exists _created_at timestamptz not null default now();
alter table "itsa_uam_permission" add column if not exists _updated_at timestamptz not null default now();
alter table "itsa_uam_permission" add column if not exists "no" text;
alter table "itsa_uam_permission" add column if not exists "a" text;
alter table "itsa_uam_permission" add column if not exists "d" text;
alter table "itsa_uam_permission" add column if not exists "role" text;
create index if not exists "itsa_uam_permission_tenant_seq_idx" on "itsa_uam_permission" (_tenant, _seq);

-- ============ ITSA-WFD ============
create table if not exists "itsa_wfd_workflow" (
  _pk         bigint generated always as identity primary key,
  _tenant     uuid references tenant(id) on delete cascade,
  _seq        integer not null default 0,
  "no" text,
  "a" text,
  "mod" text,
  "steps" text,
  "s" text,
  _extra      jsonb not null default '{}'::jsonb,
  _created_at timestamptz not null default now(),
  _updated_at timestamptz not null default now()
);
alter table "itsa_wfd_workflow" drop column if exists "id";
alter table "itsa_wfd_workflow" drop column if exists "tenant_id";
alter table "itsa_wfd_workflow" drop column if exists "seq";
alter table "itsa_wfd_workflow" drop column if exists "extra";
alter table "itsa_wfd_workflow" drop column if exists "created_at";
alter table "itsa_wfd_workflow" drop column if exists "updated_at";
alter table "itsa_wfd_workflow" add column if not exists _pk bigint generated always as identity;
alter table "itsa_wfd_workflow" add column if not exists _tenant uuid references tenant(id) on delete cascade;
alter table "itsa_wfd_workflow" add column if not exists _seq integer not null default 0;
alter table "itsa_wfd_workflow" add column if not exists _extra jsonb not null default '{}'::jsonb;
alter table "itsa_wfd_workflow" add column if not exists _created_at timestamptz not null default now();
alter table "itsa_wfd_workflow" add column if not exists _updated_at timestamptz not null default now();
alter table "itsa_wfd_workflow" add column if not exists "no" text;
alter table "itsa_wfd_workflow" add column if not exists "a" text;
alter table "itsa_wfd_workflow" add column if not exists "mod" text;
alter table "itsa_wfd_workflow" add column if not exists "steps" text;
alter table "itsa_wfd_workflow" add column if not exists "s" text;
create index if not exists "itsa_wfd_workflow_tenant_seq_idx" on "itsa_wfd_workflow" (_tenant, _seq);
create table if not exists "itsa_wfd_workflow_builder" (
  _pk         bigint generated always as identity primary key,
  _tenant     uuid references tenant(id) on delete cascade,
  _seq        integer not null default 0,
  "a" text,
  "ts" text,
  "s" text,
  _extra      jsonb not null default '{}'::jsonb,
  _created_at timestamptz not null default now(),
  _updated_at timestamptz not null default now()
);
alter table "itsa_wfd_workflow_builder" drop column if exists "id";
alter table "itsa_wfd_workflow_builder" drop column if exists "tenant_id";
alter table "itsa_wfd_workflow_builder" drop column if exists "seq";
alter table "itsa_wfd_workflow_builder" drop column if exists "extra";
alter table "itsa_wfd_workflow_builder" drop column if exists "created_at";
alter table "itsa_wfd_workflow_builder" drop column if exists "updated_at";
alter table "itsa_wfd_workflow_builder" add column if not exists _pk bigint generated always as identity;
alter table "itsa_wfd_workflow_builder" add column if not exists _tenant uuid references tenant(id) on delete cascade;
alter table "itsa_wfd_workflow_builder" add column if not exists _seq integer not null default 0;
alter table "itsa_wfd_workflow_builder" add column if not exists _extra jsonb not null default '{}'::jsonb;
alter table "itsa_wfd_workflow_builder" add column if not exists _created_at timestamptz not null default now();
alter table "itsa_wfd_workflow_builder" add column if not exists _updated_at timestamptz not null default now();
alter table "itsa_wfd_workflow_builder" add column if not exists "a" text;
alter table "itsa_wfd_workflow_builder" add column if not exists "ts" text;
alter table "itsa_wfd_workflow_builder" add column if not exists "s" text;
create index if not exists "itsa_wfd_workflow_builder_tenant_seq_idx" on "itsa_wfd_workflow_builder" (_tenant, _seq);
create table if not exists "itsa_wfd_workflow_step" (
  _pk         bigint generated always as identity primary key,
  _tenant     uuid references tenant(id) on delete cascade,
  _seq        integer not null default 0,
  "a" text,
  "d" text,
  "who" text,
  _extra      jsonb not null default '{}'::jsonb,
  _created_at timestamptz not null default now(),
  _updated_at timestamptz not null default now()
);
alter table "itsa_wfd_workflow_step" drop column if exists "id";
alter table "itsa_wfd_workflow_step" drop column if exists "tenant_id";
alter table "itsa_wfd_workflow_step" drop column if exists "seq";
alter table "itsa_wfd_workflow_step" drop column if exists "extra";
alter table "itsa_wfd_workflow_step" drop column if exists "created_at";
alter table "itsa_wfd_workflow_step" drop column if exists "updated_at";
alter table "itsa_wfd_workflow_step" add column if not exists _pk bigint generated always as identity;
alter table "itsa_wfd_workflow_step" add column if not exists _tenant uuid references tenant(id) on delete cascade;
alter table "itsa_wfd_workflow_step" add column if not exists _seq integer not null default 0;
alter table "itsa_wfd_workflow_step" add column if not exists _extra jsonb not null default '{}'::jsonb;
alter table "itsa_wfd_workflow_step" add column if not exists _created_at timestamptz not null default now();
alter table "itsa_wfd_workflow_step" add column if not exists _updated_at timestamptz not null default now();
alter table "itsa_wfd_workflow_step" add column if not exists "a" text;
alter table "itsa_wfd_workflow_step" add column if not exists "d" text;
alter table "itsa_wfd_workflow_step" add column if not exists "who" text;
create index if not exists "itsa_wfd_workflow_step_tenant_seq_idx" on "itsa_wfd_workflow_step" (_tenant, _seq);
create table if not exists "itsa_wfd_approval_workflow" (
  _pk         bigint generated always as identity primary key,
  _tenant     uuid references tenant(id) on delete cascade,
  _seq        integer not null default 0,
  "a" text,
  "d" text,
  "s" text,
  _extra      jsonb not null default '{}'::jsonb,
  _created_at timestamptz not null default now(),
  _updated_at timestamptz not null default now()
);
alter table "itsa_wfd_approval_workflow" drop column if exists "id";
alter table "itsa_wfd_approval_workflow" drop column if exists "tenant_id";
alter table "itsa_wfd_approval_workflow" drop column if exists "seq";
alter table "itsa_wfd_approval_workflow" drop column if exists "extra";
alter table "itsa_wfd_approval_workflow" drop column if exists "created_at";
alter table "itsa_wfd_approval_workflow" drop column if exists "updated_at";
alter table "itsa_wfd_approval_workflow" add column if not exists _pk bigint generated always as identity;
alter table "itsa_wfd_approval_workflow" add column if not exists _tenant uuid references tenant(id) on delete cascade;
alter table "itsa_wfd_approval_workflow" add column if not exists _seq integer not null default 0;
alter table "itsa_wfd_approval_workflow" add column if not exists _extra jsonb not null default '{}'::jsonb;
alter table "itsa_wfd_approval_workflow" add column if not exists _created_at timestamptz not null default now();
alter table "itsa_wfd_approval_workflow" add column if not exists _updated_at timestamptz not null default now();
alter table "itsa_wfd_approval_workflow" add column if not exists "a" text;
alter table "itsa_wfd_approval_workflow" add column if not exists "d" text;
alter table "itsa_wfd_approval_workflow" add column if not exists "s" text;
create index if not exists "itsa_wfd_approval_workflow_tenant_seq_idx" on "itsa_wfd_approval_workflow" (_tenant, _seq);
create table if not exists "itsa_wfd_business_rule" (
  _pk         bigint generated always as identity primary key,
  _tenant     uuid references tenant(id) on delete cascade,
  _seq        integer not null default 0,
  "a" text,
  "d" text,
  "s" text,
  _extra      jsonb not null default '{}'::jsonb,
  _created_at timestamptz not null default now(),
  _updated_at timestamptz not null default now()
);
alter table "itsa_wfd_business_rule" drop column if exists "id";
alter table "itsa_wfd_business_rule" drop column if exists "tenant_id";
alter table "itsa_wfd_business_rule" drop column if exists "seq";
alter table "itsa_wfd_business_rule" drop column if exists "extra";
alter table "itsa_wfd_business_rule" drop column if exists "created_at";
alter table "itsa_wfd_business_rule" drop column if exists "updated_at";
alter table "itsa_wfd_business_rule" add column if not exists _pk bigint generated always as identity;
alter table "itsa_wfd_business_rule" add column if not exists _tenant uuid references tenant(id) on delete cascade;
alter table "itsa_wfd_business_rule" add column if not exists _seq integer not null default 0;
alter table "itsa_wfd_business_rule" add column if not exists _extra jsonb not null default '{}'::jsonb;
alter table "itsa_wfd_business_rule" add column if not exists _created_at timestamptz not null default now();
alter table "itsa_wfd_business_rule" add column if not exists _updated_at timestamptz not null default now();
alter table "itsa_wfd_business_rule" add column if not exists "a" text;
alter table "itsa_wfd_business_rule" add column if not exists "d" text;
alter table "itsa_wfd_business_rule" add column if not exists "s" text;
create index if not exists "itsa_wfd_business_rule_tenant_seq_idx" on "itsa_wfd_business_rule" (_tenant, _seq);
create table if not exists "itsa_wfd_workflow_version" (
  _pk         bigint generated always as identity primary key,
  _tenant     uuid references tenant(id) on delete cascade,
  _seq        integer not null default 0,
  "a" text,
  "d" text,
  "ts" text,
  _extra      jsonb not null default '{}'::jsonb,
  _created_at timestamptz not null default now(),
  _updated_at timestamptz not null default now()
);
alter table "itsa_wfd_workflow_version" drop column if exists "id";
alter table "itsa_wfd_workflow_version" drop column if exists "tenant_id";
alter table "itsa_wfd_workflow_version" drop column if exists "seq";
alter table "itsa_wfd_workflow_version" drop column if exists "extra";
alter table "itsa_wfd_workflow_version" drop column if exists "created_at";
alter table "itsa_wfd_workflow_version" drop column if exists "updated_at";
alter table "itsa_wfd_workflow_version" add column if not exists _pk bigint generated always as identity;
alter table "itsa_wfd_workflow_version" add column if not exists _tenant uuid references tenant(id) on delete cascade;
alter table "itsa_wfd_workflow_version" add column if not exists _seq integer not null default 0;
alter table "itsa_wfd_workflow_version" add column if not exists _extra jsonb not null default '{}'::jsonb;
alter table "itsa_wfd_workflow_version" add column if not exists _created_at timestamptz not null default now();
alter table "itsa_wfd_workflow_version" add column if not exists _updated_at timestamptz not null default now();
alter table "itsa_wfd_workflow_version" add column if not exists "a" text;
alter table "itsa_wfd_workflow_version" add column if not exists "d" text;
alter table "itsa_wfd_workflow_version" add column if not exists "ts" text;
create index if not exists "itsa_wfd_workflow_version_tenant_seq_idx" on "itsa_wfd_workflow_version" (_tenant, _seq);
create table if not exists "itsa_wfd_workflow_deployment" (
  _pk         bigint generated always as identity primary key,
  _tenant     uuid references tenant(id) on delete cascade,
  _seq        integer not null default 0,
  "a" text,
  "d" text,
  "s" text,
  _extra      jsonb not null default '{}'::jsonb,
  _created_at timestamptz not null default now(),
  _updated_at timestamptz not null default now()
);
alter table "itsa_wfd_workflow_deployment" drop column if exists "id";
alter table "itsa_wfd_workflow_deployment" drop column if exists "tenant_id";
alter table "itsa_wfd_workflow_deployment" drop column if exists "seq";
alter table "itsa_wfd_workflow_deployment" drop column if exists "extra";
alter table "itsa_wfd_workflow_deployment" drop column if exists "created_at";
alter table "itsa_wfd_workflow_deployment" drop column if exists "updated_at";
alter table "itsa_wfd_workflow_deployment" add column if not exists _pk bigint generated always as identity;
alter table "itsa_wfd_workflow_deployment" add column if not exists _tenant uuid references tenant(id) on delete cascade;
alter table "itsa_wfd_workflow_deployment" add column if not exists _seq integer not null default 0;
alter table "itsa_wfd_workflow_deployment" add column if not exists _extra jsonb not null default '{}'::jsonb;
alter table "itsa_wfd_workflow_deployment" add column if not exists _created_at timestamptz not null default now();
alter table "itsa_wfd_workflow_deployment" add column if not exists _updated_at timestamptz not null default now();
alter table "itsa_wfd_workflow_deployment" add column if not exists "a" text;
alter table "itsa_wfd_workflow_deployment" add column if not exists "d" text;
alter table "itsa_wfd_workflow_deployment" add column if not exists "s" text;
create index if not exists "itsa_wfd_workflow_deployment_tenant_seq_idx" on "itsa_wfd_workflow_deployment" (_tenant, _seq);
create table if not exists "itsa_wfd_workflow_monitoring" (
  _pk         bigint generated always as identity primary key,
  _tenant     uuid references tenant(id) on delete cascade,
  _seq        integer not null default 0,
  "a" text,
  "d" text,
  "s" text,
  _extra      jsonb not null default '{}'::jsonb,
  _created_at timestamptz not null default now(),
  _updated_at timestamptz not null default now()
);
alter table "itsa_wfd_workflow_monitoring" drop column if exists "id";
alter table "itsa_wfd_workflow_monitoring" drop column if exists "tenant_id";
alter table "itsa_wfd_workflow_monitoring" drop column if exists "seq";
alter table "itsa_wfd_workflow_monitoring" drop column if exists "extra";
alter table "itsa_wfd_workflow_monitoring" drop column if exists "created_at";
alter table "itsa_wfd_workflow_monitoring" drop column if exists "updated_at";
alter table "itsa_wfd_workflow_monitoring" add column if not exists _pk bigint generated always as identity;
alter table "itsa_wfd_workflow_monitoring" add column if not exists _tenant uuid references tenant(id) on delete cascade;
alter table "itsa_wfd_workflow_monitoring" add column if not exists _seq integer not null default 0;
alter table "itsa_wfd_workflow_monitoring" add column if not exists _extra jsonb not null default '{}'::jsonb;
alter table "itsa_wfd_workflow_monitoring" add column if not exists _created_at timestamptz not null default now();
alter table "itsa_wfd_workflow_monitoring" add column if not exists _updated_at timestamptz not null default now();
alter table "itsa_wfd_workflow_monitoring" add column if not exists "a" text;
alter table "itsa_wfd_workflow_monitoring" add column if not exists "d" text;
alter table "itsa_wfd_workflow_monitoring" add column if not exists "s" text;
create index if not exists "itsa_wfd_workflow_monitoring_tenant_seq_idx" on "itsa_wfd_workflow_monitoring" (_tenant, _seq);
create table if not exists "itsa_wfd_workflow_template" (
  _pk         bigint generated always as identity primary key,
  _tenant     uuid references tenant(id) on delete cascade,
  _seq        integer not null default 0,
  "a" text,
  "d" text,
  "s" text,
  _extra      jsonb not null default '{}'::jsonb,
  _created_at timestamptz not null default now(),
  _updated_at timestamptz not null default now()
);
alter table "itsa_wfd_workflow_template" drop column if exists "id";
alter table "itsa_wfd_workflow_template" drop column if exists "tenant_id";
alter table "itsa_wfd_workflow_template" drop column if exists "seq";
alter table "itsa_wfd_workflow_template" drop column if exists "extra";
alter table "itsa_wfd_workflow_template" drop column if exists "created_at";
alter table "itsa_wfd_workflow_template" drop column if exists "updated_at";
alter table "itsa_wfd_workflow_template" add column if not exists _pk bigint generated always as identity;
alter table "itsa_wfd_workflow_template" add column if not exists _tenant uuid references tenant(id) on delete cascade;
alter table "itsa_wfd_workflow_template" add column if not exists _seq integer not null default 0;
alter table "itsa_wfd_workflow_template" add column if not exists _extra jsonb not null default '{}'::jsonb;
alter table "itsa_wfd_workflow_template" add column if not exists _created_at timestamptz not null default now();
alter table "itsa_wfd_workflow_template" add column if not exists _updated_at timestamptz not null default now();
alter table "itsa_wfd_workflow_template" add column if not exists "a" text;
alter table "itsa_wfd_workflow_template" add column if not exists "d" text;
alter table "itsa_wfd_workflow_template" add column if not exists "s" text;
create index if not exists "itsa_wfd_workflow_template_tenant_seq_idx" on "itsa_wfd_workflow_template" (_tenant, _seq);

-- ============ PROC-PO ============
create table if not exists "proc_po_header" (
  _pk         bigint generated always as identity primary key,
  _tenant     uuid references tenant(id) on delete cascade,
  _seq        integer not null default 0,
  "no" text,
  "co" text,
  "vend" text,
  "prRef" text,
  "ts" text,
  "amt" numeric,
  "cc" text,
  _extra      jsonb not null default '{}'::jsonb,
  _created_at timestamptz not null default now(),
  _updated_at timestamptz not null default now()
);
alter table "proc_po_header" drop column if exists "id";
alter table "proc_po_header" drop column if exists "tenant_id";
alter table "proc_po_header" drop column if exists "seq";
alter table "proc_po_header" drop column if exists "extra";
alter table "proc_po_header" drop column if exists "created_at";
alter table "proc_po_header" drop column if exists "updated_at";
alter table "proc_po_header" add column if not exists _pk bigint generated always as identity;
alter table "proc_po_header" add column if not exists _tenant uuid references tenant(id) on delete cascade;
alter table "proc_po_header" add column if not exists _seq integer not null default 0;
alter table "proc_po_header" add column if not exists _extra jsonb not null default '{}'::jsonb;
alter table "proc_po_header" add column if not exists _created_at timestamptz not null default now();
alter table "proc_po_header" add column if not exists _updated_at timestamptz not null default now();
alter table "proc_po_header" add column if not exists "no" text;
alter table "proc_po_header" add column if not exists "co" text;
alter table "proc_po_header" add column if not exists "vend" text;
alter table "proc_po_header" add column if not exists "prRef" text;
alter table "proc_po_header" add column if not exists "ts" text;
alter table "proc_po_header" add column if not exists "amt" numeric;
alter table "proc_po_header" add column if not exists "cc" text;
create index if not exists "proc_po_header_tenant_seq_idx" on "proc_po_header" (_tenant, _seq);
create table if not exists "proc_po_detail" (
  _pk         bigint generated always as identity primary key,
  _tenant     uuid references tenant(id) on delete cascade,
  _seq        integer not null default 0,
  _extra      jsonb not null default '{}'::jsonb,
  _created_at timestamptz not null default now(),
  _updated_at timestamptz not null default now()
);
alter table "proc_po_detail" drop column if exists "id";
alter table "proc_po_detail" drop column if exists "tenant_id";
alter table "proc_po_detail" drop column if exists "seq";
alter table "proc_po_detail" drop column if exists "extra";
alter table "proc_po_detail" drop column if exists "created_at";
alter table "proc_po_detail" drop column if exists "updated_at";
alter table "proc_po_detail" add column if not exists _pk bigint generated always as identity;
alter table "proc_po_detail" add column if not exists _tenant uuid references tenant(id) on delete cascade;
alter table "proc_po_detail" add column if not exists _seq integer not null default 0;
alter table "proc_po_detail" add column if not exists _extra jsonb not null default '{}'::jsonb;
alter table "proc_po_detail" add column if not exists _created_at timestamptz not null default now();
alter table "proc_po_detail" add column if not exists _updated_at timestamptz not null default now();
create index if not exists "proc_po_detail_tenant_seq_idx" on "proc_po_detail" (_tenant, _seq);

-- ============ PROC-PR ============
create table if not exists "proc_pr_header" (
  _pk         bigint generated always as identity primary key,
  _tenant     uuid references tenant(id) on delete cascade,
  _seq        integer not null default 0,
  "no" text,
  "co" text,
  "br" text,
  "dept" text,
  "ts" text,
  "amt" numeric,
  "cc" text,
  _extra      jsonb not null default '{}'::jsonb,
  _created_at timestamptz not null default now(),
  _updated_at timestamptz not null default now()
);
alter table "proc_pr_header" drop column if exists "id";
alter table "proc_pr_header" drop column if exists "tenant_id";
alter table "proc_pr_header" drop column if exists "seq";
alter table "proc_pr_header" drop column if exists "extra";
alter table "proc_pr_header" drop column if exists "created_at";
alter table "proc_pr_header" drop column if exists "updated_at";
alter table "proc_pr_header" add column if not exists _pk bigint generated always as identity;
alter table "proc_pr_header" add column if not exists _tenant uuid references tenant(id) on delete cascade;
alter table "proc_pr_header" add column if not exists _seq integer not null default 0;
alter table "proc_pr_header" add column if not exists _extra jsonb not null default '{}'::jsonb;
alter table "proc_pr_header" add column if not exists _created_at timestamptz not null default now();
alter table "proc_pr_header" add column if not exists _updated_at timestamptz not null default now();
alter table "proc_pr_header" add column if not exists "no" text;
alter table "proc_pr_header" add column if not exists "co" text;
alter table "proc_pr_header" add column if not exists "br" text;
alter table "proc_pr_header" add column if not exists "dept" text;
alter table "proc_pr_header" add column if not exists "ts" text;
alter table "proc_pr_header" add column if not exists "amt" numeric;
alter table "proc_pr_header" add column if not exists "cc" text;
create index if not exists "proc_pr_header_tenant_seq_idx" on "proc_pr_header" (_tenant, _seq);
create table if not exists "proc_pr_detail" (
  _pk         bigint generated always as identity primary key,
  _tenant     uuid references tenant(id) on delete cascade,
  _seq        integer not null default 0,
  _extra      jsonb not null default '{}'::jsonb,
  _created_at timestamptz not null default now(),
  _updated_at timestamptz not null default now()
);
alter table "proc_pr_detail" drop column if exists "id";
alter table "proc_pr_detail" drop column if exists "tenant_id";
alter table "proc_pr_detail" drop column if exists "seq";
alter table "proc_pr_detail" drop column if exists "extra";
alter table "proc_pr_detail" drop column if exists "created_at";
alter table "proc_pr_detail" drop column if exists "updated_at";
alter table "proc_pr_detail" add column if not exists _pk bigint generated always as identity;
alter table "proc_pr_detail" add column if not exists _tenant uuid references tenant(id) on delete cascade;
alter table "proc_pr_detail" add column if not exists _seq integer not null default 0;
alter table "proc_pr_detail" add column if not exists _extra jsonb not null default '{}'::jsonb;
alter table "proc_pr_detail" add column if not exists _created_at timestamptz not null default now();
alter table "proc_pr_detail" add column if not exists _updated_at timestamptz not null default now();
create index if not exists "proc_pr_detail_tenant_seq_idx" on "proc_pr_detail" (_tenant, _seq);

-- ============ PROC-VM ============
create table if not exists "proc_vm" (
  _pk         bigint generated always as identity primary key,
  _tenant     uuid references tenant(id) on delete cascade,
  _seq        integer not null default 0,
  "no" text,
  "a" text,
  "co" text,
  "br" text,
  "type" text,
  "grade" text,
  _extra      jsonb not null default '{}'::jsonb,
  _created_at timestamptz not null default now(),
  _updated_at timestamptz not null default now()
);
alter table "proc_vm" drop column if exists "id";
alter table "proc_vm" drop column if exists "tenant_id";
alter table "proc_vm" drop column if exists "seq";
alter table "proc_vm" drop column if exists "extra";
alter table "proc_vm" drop column if exists "created_at";
alter table "proc_vm" drop column if exists "updated_at";
alter table "proc_vm" add column if not exists _pk bigint generated always as identity;
alter table "proc_vm" add column if not exists _tenant uuid references tenant(id) on delete cascade;
alter table "proc_vm" add column if not exists _seq integer not null default 0;
alter table "proc_vm" add column if not exists _extra jsonb not null default '{}'::jsonb;
alter table "proc_vm" add column if not exists _created_at timestamptz not null default now();
alter table "proc_vm" add column if not exists _updated_at timestamptz not null default now();
alter table "proc_vm" add column if not exists "no" text;
alter table "proc_vm" add column if not exists "a" text;
alter table "proc_vm" add column if not exists "co" text;
alter table "proc_vm" add column if not exists "br" text;
alter table "proc_vm" add column if not exists "type" text;
alter table "proc_vm" add column if not exists "grade" text;
create index if not exists "proc_vm_tenant_seq_idx" on "proc_vm" (_tenant, _seq);

-- ============ Row Level Security (multi-tenant) ============
create or replace function current_tenant_id() returns uuid language sql stable as $$
  select coalesce(
    nullif(current_setting('request.jwt.claims', true)::json->>'tenant_id','')::uuid,
    (select id from tenant where code = 'default')
  );
$$;

-- tenant: anon อ่านได้อย่างเดียว (กันลบแล้ว cascade ทั้งระบบ)
alter table tenant enable row level security;
drop policy if exists tenant_read on tenant;
create policy tenant_read on tenant for select using (true);

alter table "invt_item_class" enable row level security;
drop policy if exists "invt_item_class_tenant" on "invt_item_class";
create policy "invt_item_class_tenant" on "invt_item_class" for all
  using (_tenant = current_tenant_id()) with check (_tenant = current_tenant_id());
alter table "invt_item_type" enable row level security;
drop policy if exists "invt_item_type_tenant" on "invt_item_type";
create policy "invt_item_type_tenant" on "invt_item_type" for all
  using (_tenant = current_tenant_id()) with check (_tenant = current_tenant_id());
alter table "invt_item_category" enable row level security;
drop policy if exists "invt_item_category_tenant" on "invt_item_category";
create policy "invt_item_category_tenant" on "invt_item_category" for all
  using (_tenant = current_tenant_id()) with check (_tenant = current_tenant_id());
alter table "invt_item_grade" enable row level security;
drop policy if exists "invt_item_grade_tenant" on "invt_item_grade";
create policy "invt_item_grade_tenant" on "invt_item_grade" for all
  using (_tenant = current_tenant_id()) with check (_tenant = current_tenant_id());
alter table "invt_item_brand" enable row level security;
drop policy if exists "invt_item_brand_tenant" on "invt_item_brand";
create policy "invt_item_brand_tenant" on "invt_item_brand" for all
  using (_tenant = current_tenant_id()) with check (_tenant = current_tenant_id());
alter table "invt_uom" enable row level security;
drop policy if exists "invt_uom_tenant" on "invt_uom";
create policy "invt_uom_tenant" on "invt_uom" for all
  using (_tenant = current_tenant_id()) with check (_tenant = current_tenant_id());
alter table "invt_uom_group" enable row level security;
drop policy if exists "invt_uom_group_tenant" on "invt_uom_group";
create policy "invt_uom_group_tenant" on "invt_uom_group" for all
  using (_tenant = current_tenant_id()) with check (_tenant = current_tenant_id());
alter table "invt_uom_group_conversion" enable row level security;
drop policy if exists "invt_uom_group_conversion_tenant" on "invt_uom_group_conversion";
create policy "invt_uom_group_conversion_tenant" on "invt_uom_group_conversion" for all
  using (_tenant = current_tenant_id()) with check (_tenant = current_tenant_id());
alter table "invt_item" enable row level security;
drop policy if exists "invt_item_tenant" on "invt_item";
create policy "invt_item_tenant" on "invt_item" for all
  using (_tenant = current_tenant_id()) with check (_tenant = current_tenant_id());
alter table "invt_item_group" enable row level security;
drop policy if exists "invt_item_group_tenant" on "invt_item_group";
create policy "invt_item_group_tenant" on "invt_item_group" for all
  using (_tenant = current_tenant_id()) with check (_tenant = current_tenant_id());
alter table "itsa_audt_user_activity_log" enable row level security;
drop policy if exists "itsa_audt_user_activity_log_tenant" on "itsa_audt_user_activity_log";
create policy "itsa_audt_user_activity_log_tenant" on "itsa_audt_user_activity_log" for all
  using (_tenant = current_tenant_id()) with check (_tenant = current_tenant_id());
alter table "itsa_audt_login_log" enable row level security;
drop policy if exists "itsa_audt_login_log_tenant" on "itsa_audt_login_log";
create policy "itsa_audt_login_log_tenant" on "itsa_audt_login_log" for all
  using (_tenant = current_tenant_id()) with check (_tenant = current_tenant_id());
alter table "itsa_audt_data_change_log" enable row level security;
drop policy if exists "itsa_audt_data_change_log_tenant" on "itsa_audt_data_change_log";
create policy "itsa_audt_data_change_log_tenant" on "itsa_audt_data_change_log" for all
  using (_tenant = current_tenant_id()) with check (_tenant = current_tenant_id());
alter table "itsa_audt_permission_audit" enable row level security;
drop policy if exists "itsa_audt_permission_audit_tenant" on "itsa_audt_permission_audit";
create policy "itsa_audt_permission_audit_tenant" on "itsa_audt_permission_audit" for all
  using (_tenant = current_tenant_id()) with check (_tenant = current_tenant_id());
alter table "itsa_audt_api_audit" enable row level security;
drop policy if exists "itsa_audt_api_audit_tenant" on "itsa_audt_api_audit";
create policy "itsa_audt_api_audit_tenant" on "itsa_audt_api_audit" for all
  using (_tenant = current_tenant_id()) with check (_tenant = current_tenant_id());
alter table "itsa_audt_audit_report" enable row level security;
drop policy if exists "itsa_audt_audit_report_tenant" on "itsa_audt_audit_report";
create policy "itsa_audt_audit_report_tenant" on "itsa_audt_audit_report" for all
  using (_tenant = current_tenant_id()) with check (_tenant = current_tenant_id());
alter table "itsa_conf_modules" enable row level security;
drop policy if exists "itsa_conf_modules_tenant" on "itsa_conf_modules";
create policy "itsa_conf_modules_tenant" on "itsa_conf_modules" for all
  using (_tenant = current_tenant_id()) with check (_tenant = current_tenant_id());
alter table "itsa_conf_submodules" enable row level security;
drop policy if exists "itsa_conf_submodules_tenant" on "itsa_conf_submodules";
create policy "itsa_conf_submodules_tenant" on "itsa_conf_submodules" for all
  using (_tenant = current_tenant_id()) with check (_tenant = current_tenant_id());
alter table "itsa_conf_docnum" enable row level security;
drop policy if exists "itsa_conf_docnum_tenant" on "itsa_conf_docnum";
create policy "itsa_conf_docnum_tenant" on "itsa_conf_docnum" for all
  using (_tenant = current_tenant_id()) with check (_tenant = current_tenant_id());
alter table "itsa_conf_general" enable row level security;
drop policy if exists "itsa_conf_general_tenant" on "itsa_conf_general";
create policy "itsa_conf_general_tenant" on "itsa_conf_general" for all
  using (_tenant = current_tenant_id()) with check (_tenant = current_tenant_id());
alter table "itsa_conf_sysparam" enable row level security;
drop policy if exists "itsa_conf_sysparam_tenant" on "itsa_conf_sysparam";
create policy "itsa_conf_sysparam_tenant" on "itsa_conf_sysparam" for all
  using (_tenant = current_tenant_id()) with check (_tenant = current_tenant_id());
alter table "itsa_conf_localization" enable row level security;
drop policy if exists "itsa_conf_localization_tenant" on "itsa_conf_localization";
create policy "itsa_conf_localization_tenant" on "itsa_conf_localization" for all
  using (_tenant = current_tenant_id()) with check (_tenant = current_tenant_id());
alter table "itsa_conf_featureflag" enable row level security;
drop policy if exists "itsa_conf_featureflag_tenant" on "itsa_conf_featureflag";
create policy "itsa_conf_featureflag_tenant" on "itsa_conf_featureflag" for all
  using (_tenant = current_tenant_id()) with check (_tenant = current_tenant_id());
alter table "itsa_dash_user_dashboard" enable row level security;
drop policy if exists "itsa_dash_user_dashboard_tenant" on "itsa_dash_user_dashboard";
create policy "itsa_dash_user_dashboard_tenant" on "itsa_dash_user_dashboard" for all
  using (_tenant = current_tenant_id()) with check (_tenant = current_tenant_id());
alter table "itsa_dash_security_dashboard" enable row level security;
drop policy if exists "itsa_dash_security_dashboard_tenant" on "itsa_dash_security_dashboard";
create policy "itsa_dash_security_dashboard_tenant" on "itsa_dash_security_dashboard" for all
  using (_tenant = current_tenant_id()) with check (_tenant = current_tenant_id());
alter table "itsa_dash_system_dashboard" enable row level security;
drop policy if exists "itsa_dash_system_dashboard_tenant" on "itsa_dash_system_dashboard";
create policy "itsa_dash_system_dashboard_tenant" on "itsa_dash_system_dashboard" for all
  using (_tenant = current_tenant_id()) with check (_tenant = current_tenant_id());
alter table "itsa_dash_integration_dashboard" enable row level security;
drop policy if exists "itsa_dash_integration_dashboard_tenant" on "itsa_dash_integration_dashboard";
create policy "itsa_dash_integration_dashboard_tenant" on "itsa_dash_integration_dashboard" for all
  using (_tenant = current_tenant_id()) with check (_tenant = current_tenant_id());
alter table "itsa_dash_audit_dashboard" enable row level security;
drop policy if exists "itsa_dash_audit_dashboard_tenant" on "itsa_dash_audit_dashboard";
create policy "itsa_dash_audit_dashboard_tenant" on "itsa_dash_audit_dashboard" for all
  using (_tenant = current_tenant_id()) with check (_tenant = current_tenant_id());
alter table "itsa_dash_performance_dashboard" enable row level security;
drop policy if exists "itsa_dash_performance_dashboard_tenant" on "itsa_dash_performance_dashboard";
create policy "itsa_dash_performance_dashboard_tenant" on "itsa_dash_performance_dashboard" for all
  using (_tenant = current_tenant_id()) with check (_tenant = current_tenant_id());
alter table "itsa_dash_backup_dashboard" enable row level security;
drop policy if exists "itsa_dash_backup_dashboard_tenant" on "itsa_dash_backup_dashboard";
create policy "itsa_dash_backup_dashboard_tenant" on "itsa_dash_backup_dashboard" for all
  using (_tenant = current_tenant_id()) with check (_tenant = current_tenant_id());
alter table "itsa_file_storage_configuration" enable row level security;
drop policy if exists "itsa_file_storage_configuration_tenant" on "itsa_file_storage_configuration";
create policy "itsa_file_storage_configuration_tenant" on "itsa_file_storage_configuration" for all
  using (_tenant = current_tenant_id()) with check (_tenant = current_tenant_id());
alter table "itsa_file_folder" enable row level security;
drop policy if exists "itsa_file_folder_tenant" on "itsa_file_folder";
create policy "itsa_file_folder_tenant" on "itsa_file_folder" for all
  using (_tenant = current_tenant_id()) with check (_tenant = current_tenant_id());
alter table "itsa_file_quota" enable row level security;
drop policy if exists "itsa_file_quota_tenant" on "itsa_file_quota";
create policy "itsa_file_quota_tenant" on "itsa_file_quota" for all
  using (_tenant = current_tenant_id()) with check (_tenant = current_tenant_id());
alter table "itsa_file_file_sharing" enable row level security;
drop policy if exists "itsa_file_file_sharing_tenant" on "itsa_file_file_sharing";
create policy "itsa_file_file_sharing_tenant" on "itsa_file_file_sharing" for all
  using (_tenant = current_tenant_id()) with check (_tenant = current_tenant_id());
alter table "itsa_file_file_log" enable row level security;
drop policy if exists "itsa_file_file_log_tenant" on "itsa_file_file_log";
create policy "itsa_file_file_log_tenant" on "itsa_file_file_log" for all
  using (_tenant = current_tenant_id()) with check (_tenant = current_tenant_id());
alter table "itsa_intg_api" enable row level security;
drop policy if exists "itsa_intg_api_tenant" on "itsa_intg_api";
create policy "itsa_intg_api_tenant" on "itsa_intg_api" for all
  using (_tenant = current_tenant_id()) with check (_tenant = current_tenant_id());
alter table "itsa_intg_webhook" enable row level security;
drop policy if exists "itsa_intg_webhook_tenant" on "itsa_intg_webhook";
create policy "itsa_intg_webhook_tenant" on "itsa_intg_webhook" for all
  using (_tenant = current_tenant_id()) with check (_tenant = current_tenant_id());
alter table "itsa_intg_oauth_client" enable row level security;
drop policy if exists "itsa_intg_oauth_client_tenant" on "itsa_intg_oauth_client";
create policy "itsa_intg_oauth_client_tenant" on "itsa_intg_oauth_client" for all
  using (_tenant = current_tenant_id()) with check (_tenant = current_tenant_id());
alter table "itsa_intg_external_system" enable row level security;
drop policy if exists "itsa_intg_external_system_tenant" on "itsa_intg_external_system";
create policy "itsa_intg_external_system_tenant" on "itsa_intg_external_system" for all
  using (_tenant = current_tenant_id()) with check (_tenant = current_tenant_id());
alter table "itsa_intg_api_monitor" enable row level security;
drop policy if exists "itsa_intg_api_monitor_tenant" on "itsa_intg_api_monitor";
create policy "itsa_intg_api_monitor_tenant" on "itsa_intg_api_monitor" for all
  using (_tenant = current_tenant_id()) with check (_tenant = current_tenant_id());
alter table "itsa_intg_api_log" enable row level security;
drop policy if exists "itsa_intg_api_log_tenant" on "itsa_intg_api_log";
create policy "itsa_intg_api_log_tenant" on "itsa_intg_api_log" for all
  using (_tenant = current_tenant_id()) with check (_tenant = current_tenant_id());
alter table "itsa_logs_system_log" enable row level security;
drop policy if exists "itsa_logs_system_log_tenant" on "itsa_logs_system_log";
create policy "itsa_logs_system_log_tenant" on "itsa_logs_system_log" for all
  using (_tenant = current_tenant_id()) with check (_tenant = current_tenant_id());
alter table "itsa_logs_application_log" enable row level security;
drop policy if exists "itsa_logs_application_log_tenant" on "itsa_logs_application_log";
create policy "itsa_logs_application_log_tenant" on "itsa_logs_application_log" for all
  using (_tenant = current_tenant_id()) with check (_tenant = current_tenant_id());
alter table "itsa_logs_access_log" enable row level security;
drop policy if exists "itsa_logs_access_log_tenant" on "itsa_logs_access_log";
create policy "itsa_logs_access_log_tenant" on "itsa_logs_access_log" for all
  using (_tenant = current_tenant_id()) with check (_tenant = current_tenant_id());
alter table "itsa_logs_log_retention" enable row level security;
drop policy if exists "itsa_logs_log_retention_tenant" on "itsa_logs_log_retention";
create policy "itsa_logs_log_retention_tenant" on "itsa_logs_log_retention" for all
  using (_tenant = current_tenant_id()) with check (_tenant = current_tenant_id());
alter table "itsa_logs_log_search" enable row level security;
drop policy if exists "itsa_logs_log_search_tenant" on "itsa_logs_log_search";
create policy "itsa_logs_log_search_tenant" on "itsa_logs_log_search" for all
  using (_tenant = current_tenant_id()) with check (_tenant = current_tenant_id());
alter table "itsa_noti_notification_template" enable row level security;
drop policy if exists "itsa_noti_notification_template_tenant" on "itsa_noti_notification_template";
create policy "itsa_noti_notification_template_tenant" on "itsa_noti_notification_template" for all
  using (_tenant = current_tenant_id()) with check (_tenant = current_tenant_id());
alter table "itsa_noti_email_notification" enable row level security;
drop policy if exists "itsa_noti_email_notification_tenant" on "itsa_noti_email_notification";
create policy "itsa_noti_email_notification_tenant" on "itsa_noti_email_notification" for all
  using (_tenant = current_tenant_id()) with check (_tenant = current_tenant_id());
alter table "itsa_noti_sms_notification" enable row level security;
drop policy if exists "itsa_noti_sms_notification_tenant" on "itsa_noti_sms_notification";
create policy "itsa_noti_sms_notification_tenant" on "itsa_noti_sms_notification" for all
  using (_tenant = current_tenant_id()) with check (_tenant = current_tenant_id());
alter table "itsa_noti_line_notification" enable row level security;
drop policy if exists "itsa_noti_line_notification_tenant" on "itsa_noti_line_notification";
create policy "itsa_noti_line_notification_tenant" on "itsa_noti_line_notification" for all
  using (_tenant = current_tenant_id()) with check (_tenant = current_tenant_id());
alter table "itsa_noti_push_notification" enable row level security;
drop policy if exists "itsa_noti_push_notification_tenant" on "itsa_noti_push_notification";
create policy "itsa_noti_push_notification_tenant" on "itsa_noti_push_notification" for all
  using (_tenant = current_tenant_id()) with check (_tenant = current_tenant_id());
alter table "itsa_noti_notification_log" enable row level security;
drop policy if exists "itsa_noti_notification_log_tenant" on "itsa_noti_notification_log";
create policy "itsa_noti_notification_log_tenant" on "itsa_noti_notification_log" for all
  using (_tenant = current_tenant_id()) with check (_tenant = current_tenant_id());
alter table "itsa_org_business_group" enable row level security;
drop policy if exists "itsa_org_business_group_tenant" on "itsa_org_business_group";
create policy "itsa_org_business_group_tenant" on "itsa_org_business_group" for all
  using (_tenant = current_tenant_id()) with check (_tenant = current_tenant_id());
alter table "itsa_org_company" enable row level security;
drop policy if exists "itsa_org_company_tenant" on "itsa_org_company";
create policy "itsa_org_company_tenant" on "itsa_org_company" for all
  using (_tenant = current_tenant_id()) with check (_tenant = current_tenant_id());
alter table "itsa_org_branch" enable row level security;
drop policy if exists "itsa_org_branch_tenant" on "itsa_org_branch";
create policy "itsa_org_branch_tenant" on "itsa_org_branch" for all
  using (_tenant = current_tenant_id()) with check (_tenant = current_tenant_id());
alter table "itsa_org_division" enable row level security;
drop policy if exists "itsa_org_division_tenant" on "itsa_org_division";
create policy "itsa_org_division_tenant" on "itsa_org_division" for all
  using (_tenant = current_tenant_id()) with check (_tenant = current_tenant_id());
alter table "itsa_org_department" enable row level security;
drop policy if exists "itsa_org_department_tenant" on "itsa_org_department";
create policy "itsa_org_department_tenant" on "itsa_org_department" for all
  using (_tenant = current_tenant_id()) with check (_tenant = current_tenant_id());
alter table "itsa_org_position" enable row level security;
drop policy if exists "itsa_org_position_tenant" on "itsa_org_position";
create policy "itsa_org_position_tenant" on "itsa_org_position" for all
  using (_tenant = current_tenant_id()) with check (_tenant = current_tenant_id());
alter table "itsa_rpta_system_reports" enable row level security;
drop policy if exists "itsa_rpta_system_reports_tenant" on "itsa_rpta_system_reports";
create policy "itsa_rpta_system_reports_tenant" on "itsa_rpta_system_reports" for all
  using (_tenant = current_tenant_id()) with check (_tenant = current_tenant_id());
alter table "itsa_rpta_security_reports" enable row level security;
drop policy if exists "itsa_rpta_security_reports_tenant" on "itsa_rpta_security_reports";
create policy "itsa_rpta_security_reports_tenant" on "itsa_rpta_security_reports" for all
  using (_tenant = current_tenant_id()) with check (_tenant = current_tenant_id());
alter table "itsa_rpta_audit_reports" enable row level security;
drop policy if exists "itsa_rpta_audit_reports_tenant" on "itsa_rpta_audit_reports";
create policy "itsa_rpta_audit_reports_tenant" on "itsa_rpta_audit_reports" for all
  using (_tenant = current_tenant_id()) with check (_tenant = current_tenant_id());
alter table "itsa_rpta_usage_reports" enable row level security;
drop policy if exists "itsa_rpta_usage_reports_tenant" on "itsa_rpta_usage_reports";
create policy "itsa_rpta_usage_reports_tenant" on "itsa_rpta_usage_reports" for all
  using (_tenant = current_tenant_id()) with check (_tenant = current_tenant_id());
alter table "itsa_rpta_custom_report" enable row level security;
drop policy if exists "itsa_rpta_custom_report_tenant" on "itsa_rpta_custom_report";
create policy "itsa_rpta_custom_report_tenant" on "itsa_rpta_custom_report" for all
  using (_tenant = current_tenant_id()) with check (_tenant = current_tenant_id());
alter table "itsa_rptd_report" enable row level security;
drop policy if exists "itsa_rptd_report_tenant" on "itsa_rptd_report";
create policy "itsa_rptd_report_tenant" on "itsa_rptd_report" for all
  using (_tenant = current_tenant_id()) with check (_tenant = current_tenant_id());
alter table "itsa_rptd_dataset_designer" enable row level security;
drop policy if exists "itsa_rptd_dataset_designer_tenant" on "itsa_rptd_dataset_designer";
create policy "itsa_rptd_dataset_designer_tenant" on "itsa_rptd_dataset_designer" for all
  using (_tenant = current_tenant_id()) with check (_tenant = current_tenant_id());
alter table "itsa_rptd_query_builder" enable row level security;
drop policy if exists "itsa_rptd_query_builder_tenant" on "itsa_rptd_query_builder";
create policy "itsa_rptd_query_builder_tenant" on "itsa_rptd_query_builder" for all
  using (_tenant = current_tenant_id()) with check (_tenant = current_tenant_id());
alter table "itsa_rptd_report_layout" enable row level security;
drop policy if exists "itsa_rptd_report_layout_tenant" on "itsa_rptd_report_layout";
create policy "itsa_rptd_report_layout_tenant" on "itsa_rptd_report_layout" for all
  using (_tenant = current_tenant_id()) with check (_tenant = current_tenant_id());
alter table "itsa_rptd_chart_designer" enable row level security;
drop policy if exists "itsa_rptd_chart_designer_tenant" on "itsa_rptd_chart_designer";
create policy "itsa_rptd_chart_designer_tenant" on "itsa_rptd_chart_designer" for all
  using (_tenant = current_tenant_id()) with check (_tenant = current_tenant_id());
alter table "itsa_rptd_print_layout" enable row level security;
drop policy if exists "itsa_rptd_print_layout_tenant" on "itsa_rptd_print_layout";
create policy "itsa_rptd_print_layout_tenant" on "itsa_rptd_print_layout" for all
  using (_tenant = current_tenant_id()) with check (_tenant = current_tenant_id());
alter table "itsa_rptd_report_version" enable row level security;
drop policy if exists "itsa_rptd_report_version_tenant" on "itsa_rptd_report_version";
create policy "itsa_rptd_report_version_tenant" on "itsa_rptd_report_version" for all
  using (_tenant = current_tenant_id()) with check (_tenant = current_tenant_id());
alter table "itsa_rptd_report_template" enable row level security;
drop policy if exists "itsa_rptd_report_template_tenant" on "itsa_rptd_report_template";
create policy "itsa_rptd_report_template_tenant" on "itsa_rptd_report_template" for all
  using (_tenant = current_tenant_id()) with check (_tenant = current_tenant_id());
alter table "itsa_tent_management" enable row level security;
drop policy if exists "itsa_tent_management_tenant" on "itsa_tent_management";
create policy "itsa_tent_management_tenant" on "itsa_tent_management" for all
  using (_tenant = current_tenant_id()) with check (_tenant = current_tenant_id());
alter table "itsa_tent_provisioning" enable row level security;
drop policy if exists "itsa_tent_provisioning_tenant" on "itsa_tent_provisioning";
create policy "itsa_tent_provisioning_tenant" on "itsa_tent_provisioning" for all
  using (_tenant = current_tenant_id()) with check (_tenant = current_tenant_id());
alter table "itsa_tent_subscription_plan" enable row level security;
drop policy if exists "itsa_tent_subscription_plan_tenant" on "itsa_tent_subscription_plan";
create policy "itsa_tent_subscription_plan_tenant" on "itsa_tent_subscription_plan" for all
  using (_tenant = current_tenant_id()) with check (_tenant = current_tenant_id());
alter table "itsa_tent_configuration" enable row level security;
drop policy if exists "itsa_tent_configuration_tenant" on "itsa_tent_configuration";
create policy "itsa_tent_configuration_tenant" on "itsa_tent_configuration" for all
  using (_tenant = current_tenant_id()) with check (_tenant = current_tenant_id());
alter table "itsa_tent_isolation" enable row level security;
drop policy if exists "itsa_tent_isolation_tenant" on "itsa_tent_isolation";
create policy "itsa_tent_isolation_tenant" on "itsa_tent_isolation" for all
  using (_tenant = current_tenant_id()) with check (_tenant = current_tenant_id());
alter table "itsa_tent_billing" enable row level security;
drop policy if exists "itsa_tent_billing_tenant" on "itsa_tent_billing";
create policy "itsa_tent_billing_tenant" on "itsa_tent_billing" for all
  using (_tenant = current_tenant_id()) with check (_tenant = current_tenant_id());
alter table "itsa_tent_monitoring" enable row level security;
drop policy if exists "itsa_tent_monitoring_tenant" on "itsa_tent_monitoring";
create policy "itsa_tent_monitoring_tenant" on "itsa_tent_monitoring" for all
  using (_tenant = current_tenant_id()) with check (_tenant = current_tenant_id());
alter table "itsa_uam_user" enable row level security;
drop policy if exists "itsa_uam_user_tenant" on "itsa_uam_user";
create policy "itsa_uam_user_tenant" on "itsa_uam_user" for all
  using (_tenant = current_tenant_id()) with check (_tenant = current_tenant_id());
alter table "itsa_uam_role" enable row level security;
drop policy if exists "itsa_uam_role_tenant" on "itsa_uam_role";
create policy "itsa_uam_role_tenant" on "itsa_uam_role" for all
  using (_tenant = current_tenant_id()) with check (_tenant = current_tenant_id());
alter table "itsa_uam_permission" enable row level security;
drop policy if exists "itsa_uam_permission_tenant" on "itsa_uam_permission";
create policy "itsa_uam_permission_tenant" on "itsa_uam_permission" for all
  using (_tenant = current_tenant_id()) with check (_tenant = current_tenant_id());
alter table "itsa_wfd_workflow" enable row level security;
drop policy if exists "itsa_wfd_workflow_tenant" on "itsa_wfd_workflow";
create policy "itsa_wfd_workflow_tenant" on "itsa_wfd_workflow" for all
  using (_tenant = current_tenant_id()) with check (_tenant = current_tenant_id());
alter table "itsa_wfd_workflow_builder" enable row level security;
drop policy if exists "itsa_wfd_workflow_builder_tenant" on "itsa_wfd_workflow_builder";
create policy "itsa_wfd_workflow_builder_tenant" on "itsa_wfd_workflow_builder" for all
  using (_tenant = current_tenant_id()) with check (_tenant = current_tenant_id());
alter table "itsa_wfd_workflow_step" enable row level security;
drop policy if exists "itsa_wfd_workflow_step_tenant" on "itsa_wfd_workflow_step";
create policy "itsa_wfd_workflow_step_tenant" on "itsa_wfd_workflow_step" for all
  using (_tenant = current_tenant_id()) with check (_tenant = current_tenant_id());
alter table "itsa_wfd_approval_workflow" enable row level security;
drop policy if exists "itsa_wfd_approval_workflow_tenant" on "itsa_wfd_approval_workflow";
create policy "itsa_wfd_approval_workflow_tenant" on "itsa_wfd_approval_workflow" for all
  using (_tenant = current_tenant_id()) with check (_tenant = current_tenant_id());
alter table "itsa_wfd_business_rule" enable row level security;
drop policy if exists "itsa_wfd_business_rule_tenant" on "itsa_wfd_business_rule";
create policy "itsa_wfd_business_rule_tenant" on "itsa_wfd_business_rule" for all
  using (_tenant = current_tenant_id()) with check (_tenant = current_tenant_id());
alter table "itsa_wfd_workflow_version" enable row level security;
drop policy if exists "itsa_wfd_workflow_version_tenant" on "itsa_wfd_workflow_version";
create policy "itsa_wfd_workflow_version_tenant" on "itsa_wfd_workflow_version" for all
  using (_tenant = current_tenant_id()) with check (_tenant = current_tenant_id());
alter table "itsa_wfd_workflow_deployment" enable row level security;
drop policy if exists "itsa_wfd_workflow_deployment_tenant" on "itsa_wfd_workflow_deployment";
create policy "itsa_wfd_workflow_deployment_tenant" on "itsa_wfd_workflow_deployment" for all
  using (_tenant = current_tenant_id()) with check (_tenant = current_tenant_id());
alter table "itsa_wfd_workflow_monitoring" enable row level security;
drop policy if exists "itsa_wfd_workflow_monitoring_tenant" on "itsa_wfd_workflow_monitoring";
create policy "itsa_wfd_workflow_monitoring_tenant" on "itsa_wfd_workflow_monitoring" for all
  using (_tenant = current_tenant_id()) with check (_tenant = current_tenant_id());
alter table "itsa_wfd_workflow_template" enable row level security;
drop policy if exists "itsa_wfd_workflow_template_tenant" on "itsa_wfd_workflow_template";
create policy "itsa_wfd_workflow_template_tenant" on "itsa_wfd_workflow_template" for all
  using (_tenant = current_tenant_id()) with check (_tenant = current_tenant_id());
alter table "proc_po_header" enable row level security;
drop policy if exists "proc_po_header_tenant" on "proc_po_header";
create policy "proc_po_header_tenant" on "proc_po_header" for all
  using (_tenant = current_tenant_id()) with check (_tenant = current_tenant_id());
alter table "proc_po_detail" enable row level security;
drop policy if exists "proc_po_detail_tenant" on "proc_po_detail";
create policy "proc_po_detail_tenant" on "proc_po_detail" for all
  using (_tenant = current_tenant_id()) with check (_tenant = current_tenant_id());
alter table "proc_pr_header" enable row level security;
drop policy if exists "proc_pr_header_tenant" on "proc_pr_header";
create policy "proc_pr_header_tenant" on "proc_pr_header" for all
  using (_tenant = current_tenant_id()) with check (_tenant = current_tenant_id());
alter table "proc_pr_detail" enable row level security;
drop policy if exists "proc_pr_detail_tenant" on "proc_pr_detail";
create policy "proc_pr_detail_tenant" on "proc_pr_detail" for all
  using (_tenant = current_tenant_id()) with check (_tenant = current_tenant_id());
alter table "proc_vm" enable row level security;
drop policy if exists "proc_vm_tenant" on "proc_vm";
create policy "proc_vm_tenant" on "proc_vm" for all
  using (_tenant = current_tenant_id()) with check (_tenant = current_tenant_id());

-- ============ สิทธิ์ระดับ role (จำเป็น — RLS อย่างเดียวไม่พอ) ============
grant usage on schema public to anon, authenticated;
grant select, insert, update, delete on all tables in schema public to anon, authenticated;
grant usage, select on all sequences in schema public to anon, authenticated;
revoke insert, update, delete on public.tenant from anon;
alter default privileges in schema public grant select, insert, update, delete on tables to anon, authenticated;

notify pgrst, 'reload schema';
