// Mee-ERP OS — Data Layer Adapter (OS Core)
// =============================================================
// เปลี่ยนฐานข้อมูลจาก Google Sheet → Supabase (PostgreSQL / PostgREST)
// โมดูลทุกตัว "ไม่ต้องแก้": erp-kit.js › sheetsBind() จะเรียก adapter ตัวนี้แทน
// เมื่อมีการตั้งค่า Supabase ไว้ ถ้าไม่มี จะถอยกลับไปใช้ Apps Script เหมือนเดิม
//
// สัญญา (contract) ที่ adapter ต้องมี:
//   pull(table)          → Promise<{ok:boolean, rows:Array}>
//   push(table, rows)    → Promise<{ok:boolean, error?:string}>   (replaceAll)
//   label                → ชื่อฐานข้อมูลที่แสดงใน UI
//
// การเก็บข้อมูล: 1 แท็บชีตเดิม = 1 ตาราง SQL จริง
//   คอลัมน์ระบบขึ้นต้นด้วย _ เพื่อไม่ชนกับฟิลด์ข้อมูลจริง (id, tenant_id ในชีต)
//   _pk · _tenant · _seq (ลำดับแถว) · _extra (jsonb เก็บคีย์ที่ยังไม่ประกาศ)
//   ดู supabase-schema.sql — รันครั้งเดียวใน Supabase › SQL Editor

const LS_CFG = 'mee:db:cfg:v1';
const SYS = ['_pk', '_tenant', '_seq', '_extra', '_created_at', '_updated_at'];

// ค่าเริ่มต้นที่ติดมากับระบบ — ทำให้ทุกเครื่อง/ทุกโดเมน (รวม GitHub Pages) ต่อ Supabase ได้ทันที
// โดยไม่ต้องไปตั้งค่าในหน้า Database Setup ก่อน  (ตั้งค่าเองจะทับค่านี้เสมอ)
// publishable / anon key เปิดเผยฝั่ง client ได้ตามปกติ — การกันข้อมูลข้ามผู้เช่าอยู่ที่ RLS
const DEFAULT_CFG = {
  url: 'https://ymnuorzuicooqbosjwzq.supabase.co',
  anonKey: 'sb_publishable_xOBove8qm8Wds1TEiXT8NQ_WCsmasp5',
  tenant: 'default'
};

// ชื่อแท็บชีต → ชื่อตาราง SQL — กฎเดียวกันกับตัวสร้าง schema (ขีดกลาง → ขีดล่าง)
export function sqlName(tab) { return String(tab).replace(/[^a-z0-9_]/gi, '_').toLowerCase(); }

export function getCfg() {
  if (typeof window === 'undefined') return null;
  if (window.__meeDbCfg) return window.__meeDbCfg;
  let c = null;
  try { c = JSON.parse(window.localStorage.getItem(LS_CFG) || 'null'); } catch (e) { c = null; }
  if (c && c.url && c.anonKey) { window.__meeDbCfg = c; return c; }
  if (DEFAULT_CFG.url && DEFAULT_CFG.anonKey) { window.__meeDbCfg = Object.assign({}, DEFAULT_CFG); return window.__meeDbCfg; }
  return null;
}

export function setCfg(cfg) {
  if (typeof window === 'undefined') return;
  if (!cfg || !cfg.url || !cfg.anonKey) {
    window.__meeDbCfg = null; window.__meeDbAdapter = null;
    try { window.localStorage.removeItem(LS_CFG); } catch (e) {}
    return;
  }
  const clean = {
    url: String(cfg.url).replace(/\/+$/, ''),
    anonKey: String(cfg.anonKey).trim(),
    tenant: cfg.tenant || 'default'
  };
  window.__meeDbCfg = clean;
  try { window.localStorage.setItem(LS_CFG, JSON.stringify(clean)); } catch (e) {}
  window.__meeDbAdapter = createAdapter(clean);
  return clean;
}

export function createAdapter(cfg) {
  const base = cfg.url + '/rest/v1';
  const H = () => ({ apikey: cfg.anonKey, Authorization: 'Bearer ' + cfg.anonKey, 'Content-Type': 'application/json' });
  const cache = { cols: {}, tenantId: null };
  let noAutoTable = false; // true เมื่อยังไม่ได้รัน supabase-autotable.sql

  const withTimeout = (p, ms) => Promise.race([p, new Promise((_, rej) => setTimeout(() => rej(new Error('timeout')), ms || 15000))]);

  // คอลัมน์จริงของตาราง: อ่านจากแถวแรก — OpenAPI ของ Supabase อ่านด้วย anon key ไม่ได้
  async function columns(t) {
    if (cache.cols[t] !== undefined) return cache.cols[t];
    try {
      const r = await withTimeout(fetch(base + '/' + t + '?select=*&limit=1', { headers: H() }));
      const j = await r.json();
      cache.cols[t] = (Array.isArray(j) && j[0]) ? Object.keys(j[0]) : null;
    } catch (e) { cache.cols[t] = null; }
    return cache.cols[t];
  }

  // สร้างตาราง / เพิ่มคอลัมน์อัตโนมัติ (ต้องรัน supabase-autotable.sql ครั้งเดียวก่อน)
  function colTypes(rows) {
    const cols = {};
    (rows || []).slice(0, 80).forEach(r => Object.keys(r || {}).forEach(k => {
      if (SYS.indexOf(k) > -1 || !/^[A-Za-z_][A-Za-z0-9_]*$/.test(k) || k.charAt(0) === '_') return;
      const v = r[k];
      if (v === null || v === undefined || v === '') { if (!cols[k]) cols[k] = 'text'; return; }
      const ty = typeof v === 'number' ? 'numeric' : typeof v === 'boolean' ? 'boolean' : 'text';
      cols[k] = (cols[k] && cols[k] !== ty) ? 'text' : ty;
    }));
    return cols;
  }
  async function ensureTable(t, rows) {
    if (noAutoTable) return false;
    try {
      const r = await withTimeout(fetch(base + '/rpc/mee_ensure_table', {
        method: 'POST', headers: H(), body: JSON.stringify({ p_table: t, p_cols: colTypes(rows) })
      }), 30000);
      if (!r.ok) { if (r.status === 404) noAutoTable = true; return false; }
      delete cache.cols[t];
      await new Promise(done => setTimeout(done, 600)); // รอ PostgREST โหลด schema ใหม่
      return true;
    } catch (e) { return false; }
  }

  async function tenantId() {
    if (cache.tenantId) return cache.tenantId;
    cache.tenantId = (async () => {
      // ปกติใช้ผู้เช่า 'default' ที่ schema สร้างไว้ให้ — ถ้าไม่เจอ ใช้ผู้เช่าแรกในตาราง
      const one = async (q) => {
        const r = await withTimeout(fetch(base + '/tenant?select=id,code&' + q, { headers: H() }));
        if (!r.ok) {
          let j = null; try { j = JSON.parse(await r.text()); } catch (e) {}
          const code = j && j.code;
          if (r.status === 404 || code === 'PGRST205') throw new Error('ยังไม่มีตารางในฐานข้อมูลนี้ — กลับไปขั้นที่ 1 กด “สร้างสคริปต์จากชีตจริง” แล้วนำไปรันใน Supabase › SQL Editor ก่อน');
          if (r.status === 401 || r.status === 403) throw new Error('คีย์ใช้ไม่ได้ (' + r.status + ') — ตรวจว่าใช้ anon / publishable key ของโปรเจกต์นี้');
          throw new Error('HTTP ' + r.status + ((j && j.message) ? ' · ' + j.message : ''));
        }
        const j = await r.json();
        return (Array.isArray(j) && j[0]) || null;
      };
      const hit = (await one('code=eq.' + encodeURIComponent(cfg.tenant || 'default') + '&limit=1')) || (await one('order=created_at.asc&limit=1'));
      if (hit && hit.id) { cfg.tenant = hit.code; return hit.id; }
      throw new Error('ตาราง tenant ว่าง — รันสคริปต์สร้างตารางใหม่อีกครั้งให้จบทั้งไฟล์');
    })();
    return cache.tenantId;
  }

  // อ่าน body ของ PostgREST แล้วแปลงเป็นข้อความที่ตามต่อได้ (แทนการคืน 'HTTP 400' ลอย ๆ)
  async function decodeErr(res, t) {
    let body = '';
    try { body = await res.text(); } catch (e) {}
    let j = null; try { j = JSON.parse(body); } catch (e) {}
    const msg = (j && (j.message || j.error)) || body.slice(0, 200);
    const code = j && j.code;
    if (res.status === 404 || code === 'PGRST205') return 'ไม่พบตาราง "' + t + '" ในฐานข้อมูล — กลับไปขั้นที่ 1 สร้างตารางก่อน';
    if (code === '42703' || /_seq|_tenant|_extra/.test(msg)) {
      return 'ตาราง "' + t + '" ยังเป็นโครงสร้างเวอร์ชันเก่า (คอลัมน์ seq/tenant_id/extra) — กลับไปขั้นที่ 1 กด “สร้างสคริปต์จากชีตจริง” โดยติ๊ก “ลบตารางเดิมทิ้งก่อนสร้างใหม่” แล้วรันใน SQL Editor';
    }
    if (res.status === 401 || res.status === 403) return 'สิทธิ์ไม่พอ (' + res.status + ') — ตรวจ anon key และนโยบาย RLS ของตาราง "' + t + '"';
    return 'HTTP ' + res.status + (msg ? ' · ' + msg : '');
  }

  // แถว SQL → แถวที่โมดูลใช้ (คืนคีย์ใน extra กลับมารวม, ตัดคอลัมน์ระบบทิ้ง)
  function fromRow(r) {
    const o = {};
    Object.keys(r).forEach(k => { if (SYS.indexOf(k) < 0 && r[k] !== null) o[k] = r[k]; });
    const ex = r._extra;
    if (ex && typeof ex === 'object') Object.keys(ex).forEach(k => { o[k] = ex[k]; });
    return o;
  }

  // แถวโมดูล → แถว SQL (คีย์ที่ไม่มีคอลัมน์จริงถูกยัดลง extra)
  function toRow(r, cols, tid, i, dropped) {
    const known = {}, extra = {};
    Object.keys(r || {}).forEach(k => {
      const v = r[k];
      const isCol = SYS.indexOf(k) < 0 && (dropped || []).indexOf(k) < 0 && (cols ? cols.indexOf(k) > -1 : true);
      if (isCol) known[k] = (v && typeof v === 'object') ? JSON.stringify(v) : v;
      else extra[k] = v;
    });
    return Object.assign({ _tenant: tid, _seq: i, _extra: extra }, known);
  }

  return {
    label: 'Supabase',
    cfg: cfg,
    async ping() {
      try { await tenantId(); return { ok: true }; }
      catch (e) { cache.tenantId = null; return { ok: false, error: e.message }; }
    },
    async pull(tab) {
      const t = sqlName(tab);
      try {
        const tid = await tenantId();
        const url = base + '/' + t + '?select=*&_tenant=eq.' + tid + '&order=_seq.asc';
        let r = await withTimeout(fetch(url, { headers: H(), cache: 'no-store' }));
        if (r.status === 404 && await ensureTable(t, [])) return { ok: true, rows: [] };
        if (!r.ok) return { ok: false, error: await decodeErr(r, t) };
        const j = await r.json();
        if (!Array.isArray(j)) return { ok: false, error: (j && j.message) || 'bad response' };
        if (j[0]) cache.cols[t] = Object.keys(j[0]);
        return { ok: true, rows: j.map(fromRow) };
      } catch (e) { return { ok: false, error: e.message }; }
    },
    // replaceAll: ลบแถวของ tenant นี้ในตารางแล้วเขียนใหม่ทั้งชุด (semantics เดิมของ Sheet)
    async push(tab, rows) {
      const t = sqlName(tab);
      try {
        const tid = await tenantId();
        let cols = await columns(t);
        let del = await withTimeout(fetch(base + '/' + t + '?_tenant=eq.' + tid, {
          method: 'DELETE', headers: Object.assign({ Prefer: 'return=minimal' }, H())
        }));
        if (del.status === 404 && await ensureTable(t, rows)) {
          cols = null;
          del = await withTimeout(fetch(base + '/' + t + '?_tenant=eq.' + tid, {
            method: 'DELETE', headers: Object.assign({ Prefer: 'return=minimal' }, H())
          }));
        }
        if (!del.ok) return { ok: false, error: await decodeErr(del, t) };
        if (!(rows || []).length) return { ok: true };
        // ตารางว่างยังไม่รู้คอลัมน์ → ส่งทุกคีย์ก่อน ถ้า PostgREST ฟ้องว่าคอลัมน์ไหนไม่มี ค่อยย้ายคีย์นั้นลง _extra แล้วลองใหม่
        const dropped = [];
        for (let attempt = 0; attempt < 12; attempt++) {
          const body = rows.map((r, i) => toRow(r, cols, tid, i, dropped));
          const res = await withTimeout(fetch(base + '/' + t, {
            method: 'POST', headers: Object.assign({ Prefer: 'return=minimal' }, H()), body: JSON.stringify(body)
          }), 30000);
          if (res.ok) { if (dropped.length) delete cache.cols[t]; return { ok: true, extraKeys: dropped.slice() }; }
          const txt = await res.clone().text();
          const miss = txt.match(/Could not find the '([^']+)' column/);
          if (miss && dropped.indexOf(miss[1]) < 0) {
            // มีคอลัมน์ใหม่ → พยายามเพิ่มคอลัมน์จริงก่อน ถ้าเพิ่มไม่ได้ค่อยเก็บลง _extra
            if (await ensureTable(t, rows)) { cols = null; continue; }
            dropped.push(miss[1]); continue;
          }
          return { ok: false, error: await decodeErr(res, t) };
        }
        return { ok: false, error: 'บันทึกไม่สำเร็จ: คอลัมน์ไม่ตรงกับข้อมูลหลายจุด' };
      } catch (e) { return { ok: false, error: e.message }; }
    }
  };
}

// เรียกตอนบูต Shell — คืน adapter ถ้าตั้งค่าไว้แล้ว
export function boot() {
  const cfg = getCfg();
  if (!cfg) return null;
  if (!window.__meeDbAdapter) window.__meeDbAdapter = createAdapter(cfg);
  // แจ้งหน้าจอที่โหลดไปก่อนหน้าว่ามี adapter แล้ว (Shell/โมดูลจะรีเฟรชสถานะเอง)
  try { window.dispatchEvent(new CustomEvent('mee-db-ready', { detail: { label: window.__meeDbAdapter.label } })); } catch (e) {}
  return window.__meeDbAdapter;
}

if (typeof window !== 'undefined') {
  window.__meeDb = { getCfg, setCfg, createAdapter, boot, sqlName };
  boot();
}
