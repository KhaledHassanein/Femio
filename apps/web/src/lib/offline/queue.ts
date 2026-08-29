// Minimal IndexedDB-backed queue for log entries made while offline. Raw
// IndexedDB (platform, no dependency). Client-only — guard usage behind an
// `navigator`/`window` check or call from client components.

const DB_NAME = "femio-offline";
const STORE = "log-queue";
const VERSION = 1;

export type QueuePayload = Record<string, unknown> | Record<string, unknown>[];

export type QueueItem = {
  id?: number;
  // A movement session is queued like any other log. It matters more than most that
  // this works offline: a hospital or clinic corridor is exactly where signal drops
  // and exactly where someone may be counting (P2.2).
  // `fertility_logs` and `vitals` joined when the rebuilt log screen became one
  // surface over four tables (RB-C6). Queueing them matters for the same reason it
  // matters for the others: a day logged on a train is a day that must survive the
  // tunnel.
  table: "cycles" | "symptom_logs" | "fetal_movement_sessions" | "fertility_logs" | "vitals";
  payload: QueuePayload;
  createdAt: string;
};

function openDb(): Promise<IDBDatabase> {
  return new Promise((resolve, reject) => {
    const req = indexedDB.open(DB_NAME, VERSION);
    req.onupgradeneeded = () => {
      req.result.createObjectStore(STORE, { keyPath: "id", autoIncrement: true });
    };
    req.onsuccess = () => resolve(req.result);
    req.onerror = () => reject(req.error);
  });
}

function promisify<T>(req: IDBRequest<T>): Promise<T> {
  return new Promise((resolve, reject) => {
    req.onsuccess = () => resolve(req.result);
    req.onerror = () => reject(req.error);
  });
}

export async function enqueue(item: Omit<QueueItem, "id">): Promise<void> {
  const db = await openDb();
  const tx = db.transaction(STORE, "readwrite");
  await promisify(tx.objectStore(STORE).add(item));
  db.close();
}

export async function getAllQueued(): Promise<QueueItem[]> {
  const db = await openDb();
  const items = await promisify(db.transaction(STORE, "readonly").objectStore(STORE).getAll());
  db.close();
  return items as QueueItem[];
}

export async function removeQueued(id: number): Promise<void> {
  const db = await openDb();
  const tx = db.transaction(STORE, "readwrite");
  await promisify(tx.objectStore(STORE).delete(id));
  db.close();
}

export async function queueCount(): Promise<number> {
  const db = await openDb();
  const n = await promisify(db.transaction(STORE, "readonly").objectStore(STORE).count());
  db.close();
  return n;
}
